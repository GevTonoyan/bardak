import 'dart:async';

import 'package:bardak/core/di/di.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/fleet_entity.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/sea_battle_entity.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/exceptions/sea_battle_opponent_exception.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/usecases/fire_at_opponent_usecase.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/usecases/get_opponent_fleet_usecase.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/usecases/get_opponent_shot_usecase.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/usecases/get_random_shot_usecase.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/usecases/leave_sea_battle_usecase.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/usecases/report_opponent_shot_usecase.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/usecases/start_sea_battle_usecase.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/usecases/watch_opponent_left_usecase.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/presentation/bloc/sea_battle_game_event.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/presentation/bloc/sea_battle_game_state.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Runs a battle against an opponent — the bot, or a remote player — until
/// one fleet is sunk, or the battle is interrupted.
///
/// The player's shots are answered by the opponent; the opponent's shots
/// are answered from the player's own fleet and reported back.
///
/// With a `turnTimeLimit` (online), every shot must come within it: when
/// the player's time runs out, a random shot is fired for them. The
/// opponent's own phone does the same for the opponent; when no shot
/// comes even then, the opponent counts as gone. Closing the bloc leaves
/// the battle, so the opponent is not kept waiting.
class SeaBattleGameBloc extends Bloc<SeaBattleGameEvent, SeaBattleGameState> {
  SeaBattleGameBloc({
    required FleetEntity playerFleet,
    required StartSeaBattleUseCase startSeaBattleUseCase,
    required this._fireAtOpponentUseCase,
    required this._getOpponentShotUseCase,
    required this._reportOpponentShotUseCase,
    required this._getOpponentFleetUseCase,
    required this._getRandomShotUseCase,
    required this._watchOpponentLeftUseCase,
    required this._leaveSeaBattleUseCase,
    SeaBattleSide? firstTurn,
    this._turnTimeLimit,
    this._opponentGrace = const Duration(seconds: 10),
  }) : super(
         SeaBattleGameState(
           battle: startSeaBattleUseCase(playerFleet, firstTurn: firstTurn),
         ),
       ) {
    // Taps while the last shot is still being answered are dropped.
    on<FireShot>(_onFireShot, transformer: droppable());
    // One opponent shot at a time, in order: each hit queues the next one.
    on<PlayOpponentTurn>(_onPlayOpponentTurn, transformer: sequential());
    // Each shot starts the countdown over.
    on<RunTurnTimer>(_onRunTurnTimer, transformer: restartable());
    on<WatchOpponent>(_onWatchOpponent, transformer: restartable());

    add(const WatchOpponent());
    _startTurn(state.battle);
  }

  final FireAtOpponentUseCase _fireAtOpponentUseCase;
  final GetOpponentShotUseCase _getOpponentShotUseCase;
  final ReportOpponentShotUseCase _reportOpponentShotUseCase;
  final GetOpponentFleetUseCase _getOpponentFleetUseCase;
  final GetRandomShotUseCase _getRandomShotUseCase;
  final WatchOpponentLeftUseCase _watchOpponentLeftUseCase;
  final LeaveSeaBattleUseCase _leaveSeaBattleUseCase;
  final Duration? _turnTimeLimit;

  /// How long past the opponent's own time limit their shot is waited
  /// for, allowing for the network, before they count as gone.
  final Duration _opponentGrace;

  Future<void> _onFireShot(
    FireShot event,
    Emitter<SeaBattleGameState> emit,
  ) async {
    // Taps during the opponent's turn or on marked cells are ignored.
    if (!state.isPlaying || !state.battle.canFire(.player, event.cell)) {
      return;
    }

    final ShotEntity shot;
    try {
      shot = await _fireAtOpponentUseCase(event.cell);
    } on SeaBattleOpponentException catch (error, stackTrace) {
      return _interrupt(emit, error, stackTrace);
    }
    if (isClosed || !state.isPlaying) return;

    emit(state.withBattle(state.battle.record(shot)));
    await _finishShot(emit);
  }

  Future<void> _onPlayOpponentTurn(
    PlayOpponentTurn event,
    Emitter<SeaBattleGameState> emit,
  ) async {
    try {
      final cell = await _getOpponentShotUseCase(state.battle.playerBoard);
      final battle = state.battle;
      if (isClosed || !state.isPlaying) return;
      if (!battle.canFire(.opponent, cell)) {
        // Only a broken or tampered opponent fires out of turn or at a
        // marked cell; the battle cannot go on with it.
        throw SeaBattleOpponentException(
          .connection,
          cause: StateError('The opponent fired at $cell, out of the rules'),
        );
      }

      final shot = battle.answerOpponentShot(cell);
      emit(state.withBattle(battle.record(shot)));
      // Reported before the battle can end: online, the answer is what
      // tells the opponent they have won.
      await _reportOpponentShotUseCase(shot);
    } on SeaBattleOpponentException catch (error, stackTrace) {
      return _interrupt(emit, error, stackTrace);
    }
    await _finishShot(emit);
  }

  Future<void> _onRunTurnTimer(
    RunTurnTimer event,
    Emitter<SeaBattleGameState> emit,
  ) async {
    final limit = _turnTimeLimit;
    if (limit == null) return;
    if (!state.isPlaying) {
      emit(
        SeaBattleGameState(
          battle: state.battle,
          interruption: state.interruption,
        ),
      );
      return;
    }

    final seconds = limit.inSeconds;
    emit(SeaBattleGameState(battle: state.battle, turnSecondsLeft: seconds));
    await emit.forEach<int>(
      Stream.periodic(
        const Duration(seconds: 1),
        (tick) => seconds - tick - 1,
      ).take(seconds),
      // Keeps an interruption that comes in before the restart does.
      onData: (secondsLeft) => SeaBattleGameState(
        battle: state.battle,
        turnSecondsLeft: state.isPlaying ? secondsLeft : null,
        interruption: state.interruption,
      ),
    );

    // A shot restarted the countdown, or the battle closed: the time did
    // not run out.
    if (emit.isDone || isClosed || !state.isPlaying) return;

    if (state.battle.turn == .player) {
      add(FireShot(_getRandomShotUseCase(state.battle.opponentBoard)));
      return;
    }

    await Future<void>.delayed(_opponentGrace);
    if (emit.isDone || isClosed || !state.isPlaying) return;
    _interrupt(
      emit,
      const SeaBattleOpponentException(
        .left,
        cause: 'No shot came in time from the opponent',
      ),
      StackTrace.current,
    );
  }

  Future<void> _onWatchOpponent(
    WatchOpponent event,
    Emitter<SeaBattleGameState> emit,
  ) {
    return emit.onEach<void>(
      _watchOpponentLeftUseCase(),
      // Once the battle is over, leaving is what both players do.
      onData: (_) {
        if (!state.isPlaying) return;
        _interrupt(
          emit,
          const SeaBattleOpponentException(.left),
          StackTrace.current,
        );
      },
      onError: (error, stackTrace) {
        if (error is SeaBattleOpponentException && state.isPlaying) {
          _interrupt(emit, error, stackTrace);
        } else {
          logger.error(
            'Lost track of the opponent',
            error: error,
            stackTrace: stackTrace,
          );
        }
      },
    );
  }

  /// Stops the battle for good: no more shots, and the timer goes.
  void _interrupt(
    Emitter<SeaBattleGameState> emit,
    SeaBattleOpponentException error,
    StackTrace stackTrace,
  ) {
    if (isClosed || !state.isPlaying) return;

    // An opponent leaving is part of the game; a lost connection is not.
    if (error.reason == .left) {
      logger.info('The opponent left the battle: ${error.cause}');
    } else {
      logger.error(
        'The battle was interrupted',
        error: error,
        stackTrace: stackTrace,
      );
    }
    emit(SeaBattleGameState(battle: state.battle, interruption: error.reason));
    add(const RunTurnTimer());
  }

  /// Shows the opponent's fleet once the battle is over; otherwise starts
  /// the next turn.
  Future<void> _finishShot(Emitter<SeaBattleGameState> emit) async {
    final battle = state.battle;
    if (!battle.isOver) return _startTurn(battle);

    add(const RunTurnTimer());
    try {
      final fleet = await _getOpponentFleetUseCase();
      if (!isClosed) {
        emit(state.withBattle(state.battle.revealOpponentFleet(fleet)));
      }
    } on SeaBattleOpponentException catch (error, stackTrace) {
      // The battle is decided; only the reveal is missed.
      logger.warning(
        'Could not reveal the opponent fleet',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  /// Restarts the countdown, and queues the opponent's shot when the turn
  /// is (still) theirs.
  void _startTurn(SeaBattleEntity battle) {
    if (isClosed) return;
    add(const RunTurnTimer());
    if (!battle.isOver && battle.turn == .opponent) {
      add(const PlayOpponentTurn());
    }
  }

  @override
  Future<void> close() {
    // Not waited for: the player is already on their way out.
    unawaited(
      _leaveSeaBattleUseCase().catchError((Object error, StackTrace stack) {
        logger.warning(
          'Could not leave the battle',
          error: error,
          stackTrace: stack,
        );
      }),
    );
    return super.close();
  }
}
