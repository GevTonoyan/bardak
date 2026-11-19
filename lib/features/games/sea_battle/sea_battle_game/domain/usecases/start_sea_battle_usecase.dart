import 'dart:math';

import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/fleet_entity.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/sea_battle_board_entity.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/sea_battle_entity.dart';

/// Starts a battle: the player's fleet against the opponent's hidden one,
/// with a random side firing first.
class StartSeaBattleUseCase {
  StartSeaBattleUseCase({Random? random}) : _random = random ?? Random();

  final Random _random;

  SeaBattleEntity call(FleetEntity playerFleet) {
    return SeaBattleEntity(
      playerBoard: SeaBattleBoardEntity(fleet: playerFleet),
      opponentBoard: const SeaBattleBoardEntity(),
      turn: _random.nextBool() ? .player : .opponent,
    );
  }
}
