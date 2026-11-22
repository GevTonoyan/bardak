import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/fleet_entity.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/sea_battle_entity.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/usecases/fire_at_opponent_usecase.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/usecases/get_opponent_fleet_usecase.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/usecases/get_opponent_shot_usecase.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/usecases/get_random_shot_usecase.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/usecases/report_opponent_shot_usecase.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/usecases/start_sea_battle_usecase.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/presentation/bloc/sea_battle_game_event.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/presentation/bloc/sea_battle_game_state.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Runs a battle against an opponent — the bot, or a remote player — until
/// one fleet is sunk.
///
/// The player's shots are answered by the opponent; the opponent's shots
/// are answered from the player's own fleet and reported back.
///
/// With a `turnTimeLimit` (online), every shot must come within it: when
/// the player's time runs out, a random shot is fired for them. The
/// opponent's own phone does the same for the opponent.
class SeaBattleGameBloc extends Bloc<SeaBattleGameEvent, SeaBattleGameState> {
  SeaBattleGameBloc({
    required FleetEntity playerFleet,
    required StartSeaBattleUseCase startSeaBattleUseCase,
    required this._fireAtOpponentUseCase,
    required this._getOpponentShotUseCase,
    required this._reportOpponentShotUseCase,
    required this._getOpponentFleetUseCase,
    required this._getRandomShotUseCase,
    SeaBattleSide? firstTurn,
    this._turnTimeLimit,
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

    _startTurn(state.battle);
  }

  final FireAtOpponentUseCase _fireAtOpponentUseCase;
  final GetOpponentShotUseCase _getOpponentShotUseCase;
  final ReportOpponentShotUseCase _reportOpponentShotUseCase;
  final GetOpponentFleetUseCase _getOpponentFleetUseCase;
  final GetRandomShotUseCase _getRandomShotUseCase;
  final Duration? _turnTimeLimit;

  Future<void> _onFireShot(
    FireShot event,
    Emitter<SeaBattleGameState> emit,
  ) async {
    // Taps during the opponent's turn or on marked cells are ignored.
    if (!state.battle.canFire(.player, event.cell)) return;

    final shot = await _fireAtOpponentUseCase(event.cell);
    if (isClosed) return;

    emit(state.withBattle(state.battle.record(shot)));
    await _finishShot(emit);
  }

  Future<void> _onPlayOpponentTurn(
    PlayOpponentTurn event,
    Emitter<SeaBattleGameState> emit,
  ) async {
    final cell = await _getOpponentShotUseCase(state.battle.playerBoard);
    final battle = state.battle;
    if (isClosed || !battle.canFire(.opponent, cell)) return;

    final shot = battle.answerOpponentShot(cell);
    emit(state.withBattle(battle.record(shot)));
    // Reported before the battle can end: online, the answer is what
    // tells the opponent they have won.
    await _reportOpponentShotUseCase(shot);
    await _finishShot(emit);
  }

  Future<void> _onRunTurnTimer(
    RunTurnTimer event,
    Emitter<SeaBattleGameState> emit,
  ) async {
    final limit = _turnTimeLimit;
    if (limit == null) return;
    if (state.battle.isOver) {
      emit(SeaBattleGameState(battle: state.battle));
      return;
    }

    final seconds = limit.inSeconds;
    emit(SeaBattleGameState(battle: state.battle, turnSecondsLeft: seconds));
    await emit.forEach<int>(
      Stream.periodic(
        const Duration(seconds: 1),
        (tick) => seconds - tick - 1,
      ).take(seconds),
      onData: (secondsLeft) => SeaBattleGameState(
        battle: state.battle,
        turnSecondsLeft: secondsLeft,
      ),
    );

    // A shot restarted the countdown, or the battle closed: the time did
    // not run out.
    if (emit.isDone || isClosed) return;

    final battle = state.battle;
    if (!battle.isOver && battle.turn == .player) {
      add(FireShot(_getRandomShotUseCase(battle.opponentBoard)));
    }
  }

  /// Shows the opponent's fleet once the battle is over; otherwise starts
  /// the next turn.
  Future<void> _finishShot(Emitter<SeaBattleGameState> emit) async {
    final battle = state.battle;
    if (battle.isOver) {
      add(const RunTurnTimer());
      final fleet = await _getOpponentFleetUseCase();
      if (!isClosed) {
        emit(state.withBattle(state.battle.revealOpponentFleet(fleet)));
      }
      return;
    }
    _startTurn(battle);
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
}
