import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/board_coordinate.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/fleet_entity.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/sea_battle_entity.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/sea_battle_side.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/shot_entity.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/usecases/choose_bot_shot_usecase.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/usecases/start_sea_battle_usecase.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/presentation/bloc/sea_battle_game_bloc/sea_battle_game_event.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/presentation/bloc/sea_battle_game_bloc/sea_battle_game_state.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_settings/domain/entities/sea_battle_bot_difficulty.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Runs a battle against the bot: the player's shots, then the bot's
/// replies after a short pause, until one fleet is sunk.
class SeaBattleGameBloc extends Bloc<SeaBattleGameEvent, SeaBattleGameState> {
  SeaBattleGameBloc({
    required FleetEntity playerFleet,
    required this._botDifficulty,
    required StartSeaBattleUseCase startSeaBattleUseCase,
    required this._chooseBotShotUseCase,
  }) : super(
         SeaBattleGameState(
           battle: startSeaBattleUseCase(
             StartSeaBattleParams(playerFleet: playerFleet),
           ),
         ),
       ) {
    on<FireShot>(_onFireShot);
    // One bot shot at a time, in order: each hit queues the next one.
    on<FireBotShot>(_onFireBotShot, transformer: sequential());

    _letBotFireIfItsTurn(state.battle);
  }

  final SeaBattleBotDifficulty _botDifficulty;
  final ChooseBotShotUseCase _chooseBotShotUseCase;

  void _onFireShot(FireShot event, Emitter<SeaBattleGameState> emit) {
    // Taps during the bot's turn or on marked cells are ignored.
    if (!state.battle.canFire(.player, event.cell)) return;

    _fire(.player, event.cell, emit);
  }

  Future<void> _onFireBotShot(
    FireBotShot event,
    Emitter<SeaBattleGameState> emit,
  ) async {
    /// Pause before each bot shot, so the player can follow it.
    await Future<void>.delayed(const Duration(milliseconds: 700));
    final battle = state.battle;
    if (isClosed || battle.isOver || battle.turn != .opponent) {
      return;
    }

    final cell = _chooseBotShotUseCase(
      ChooseBotShotParams(
        board: battle.playerBoard,
        difficulty: _botDifficulty,
      ),
    );
    _fire(.opponent, cell, emit);
  }

  void _fire(
    SeaBattleSide shooter,
    BoardCoordinate cell,
    Emitter<SeaBattleGameState> emit,
  ) {
    final (battle, result) = state.battle.fire(cell);
    emit(
      SeaBattleGameState(
        battle: battle,
        lastShot: ShotEntity(shooter: shooter, cell: cell, result: result),
      ),
    );
    _letBotFireIfItsTurn(battle);
  }

  /// Queues the bot's shot whenever the turn is (still) the bot's.
  void _letBotFireIfItsTurn(SeaBattleEntity battle) {
    if (!battle.isOver && battle.turn == .opponent) {
      add(const FireBotShot());
    }
  }
}
