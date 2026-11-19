import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/fleet_entity.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/sea_battle_entity.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/usecases/fire_at_opponent_usecase.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/usecases/get_opponent_fleet_usecase.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/usecases/get_opponent_shot_usecase.dart';
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
class SeaBattleGameBloc extends Bloc<SeaBattleGameEvent, SeaBattleGameState> {
  SeaBattleGameBloc({
    required FleetEntity playerFleet,
    required StartSeaBattleUseCase startSeaBattleUseCase,
    required this._fireAtOpponentUseCase,
    required this._getOpponentShotUseCase,
    required this._reportOpponentShotUseCase,
    required this._getOpponentFleetUseCase,
  }) : super(SeaBattleGameState(battle: startSeaBattleUseCase(playerFleet))) {
    // Taps while the last shot is still being answered are dropped.
    on<FireShot>(_onFireShot, transformer: droppable());
    // One opponent shot at a time, in order: each hit queues the next one.
    on<PlayOpponentTurn>(_onPlayOpponentTurn, transformer: sequential());

    _letOpponentPlayIfItsTurn(state.battle);
  }

  final FireAtOpponentUseCase _fireAtOpponentUseCase;
  final GetOpponentShotUseCase _getOpponentShotUseCase;
  final ReportOpponentShotUseCase _reportOpponentShotUseCase;
  final GetOpponentFleetUseCase _getOpponentFleetUseCase;

  Future<void> _onFireShot(
    FireShot event,
    Emitter<SeaBattleGameState> emit,
  ) async {
    // Taps during the opponent's turn or on marked cells are ignored.
    if (!state.battle.canFire(.player, event.cell)) return;

    final shot = await _fireAtOpponentUseCase(event.cell);
    if (isClosed) return;

    await _record(shot, emit);
  }

  Future<void> _onPlayOpponentTurn(
    PlayOpponentTurn event,
    Emitter<SeaBattleGameState> emit,
  ) async {
    final cell = await _getOpponentShotUseCase(state.battle.playerBoard);
    final battle = state.battle;
    if (isClosed || !battle.canFire(.opponent, cell)) return;

    final shot = battle.answerOpponentShot(cell);
    await _record(shot, emit);
    await _reportOpponentShotUseCase(shot);
  }

  /// Applies [shot], shows the opponent's fleet once the battle is over,
  /// and hands the turn to the opponent when it is theirs.
  Future<void> _record(
    ShotEntity shot,
    Emitter<SeaBattleGameState> emit,
  ) async {
    var battle = state.battle.record(shot);
    emit(SeaBattleGameState(battle: battle));

    if (battle.isOver) {
      battle = battle.revealOpponentFleet(await _getOpponentFleetUseCase());
      if (!isClosed) emit(SeaBattleGameState(battle: battle));
      return;
    }
    _letOpponentPlayIfItsTurn(battle);
  }

  /// Queues the opponent's shot whenever the turn is (still) theirs.
  void _letOpponentPlayIfItsTurn(SeaBattleEntity battle) {
    if (!isClosed && !battle.isOver && battle.turn == .opponent) {
      add(const PlayOpponentTurn());
    }
  }
}
