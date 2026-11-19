import 'dart:math';

import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/fleet_entity.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/sea_battle_board_entity.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/sea_battle_entity.dart';

/// Starts a battle against the bot: the player's fleet against a random
/// one, with a random side firing first.
class StartSeaBattleUseCase {
  StartSeaBattleUseCase({Random? random}) : _random = random ?? Random();

  final Random _random;

  SeaBattleEntity call(StartSeaBattleParams params) {
    return SeaBattleEntity(
      playerBoard: SeaBattleBoardEntity(fleet: params.playerFleet),
      opponentBoard: SeaBattleBoardEntity(fleet: FleetEntity.random(_random)),
      turn: _random.nextBool() ? .player : .opponent,
    );
  }
}

class StartSeaBattleParams {
  const StartSeaBattleParams({required this.playerFleet});

  /// The complete fleet the player placed.
  final FleetEntity playerFleet;
}
