import 'dart:math';

import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/board_coordinate.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/sea_battle_board_entity.dart';

/// A random cell of [SeaBattleBoardEntity] that can still be shot at: the
/// shot fired for a player who runs out of time.
class GetRandomShotUseCase {
  GetRandomShotUseCase({Random? random}) : _random = random ?? Random();

  final Random _random;

  BoardCoordinate call(SeaBattleBoardEntity board) {
    final cells = board.openCells;
    return cells[_random.nextInt(cells.length)];
  }
}
