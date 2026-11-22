import 'dart:math';

import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/fleet_entity.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/sea_battle_board_entity.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/sea_battle_entity.dart';

/// Starts a battle: the player's fleet against the opponent's hidden one.
/// `firstTurn` is the side that fires first when it is already decided,
/// as online; otherwise a random side does.
class StartSeaBattleUseCase {
  StartSeaBattleUseCase({Random? random}) : _random = random ?? Random();

  final Random _random;

  SeaBattleEntity call(FleetEntity playerFleet, {SeaBattleSide? firstTurn}) {
    return SeaBattleEntity(
      playerBoard: SeaBattleBoardEntity(fleet: playerFleet),
      opponentBoard: const SeaBattleBoardEntity(),
      turn: firstTurn ?? (_random.nextBool() ? .player : .opponent),
    );
  }
}
