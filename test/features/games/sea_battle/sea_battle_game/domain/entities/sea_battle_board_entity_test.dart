import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/board_coordinate.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/fleet_entity.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/sea_battle_board_entity.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/ship_entity.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/shot_result.dart';
import 'package:flutter_test/flutter_test.dart';

const _cruiser = ShipEntity(id: 1, length: 2, origin: BoardCoordinate(4, 4));
const _boat = ShipEntity(id: 6, length: 1, origin: BoardCoordinate(0, 0));

final _board = SeaBattleBoardEntity(
  fleet: const FleetEntity().withShip(_cruiser).withShip(_boat),
);

void main() {
  test('a shot at water is a miss', () {
    final (board, result) = _board.shoot(const BoardCoordinate(9, 9));

    expect(result, ShotResult.miss);
    expect(board.missCells, {const BoardCoordinate(9, 9)});
    expect(board.hitCells, isEmpty);
  });

  test('a shot at a ship still afloat is a hit', () {
    final (board, result) = _board.shoot(const BoardCoordinate(4, 4));

    expect(result, ShotResult.hit);
    expect(board.hitCells, {const BoardCoordinate(4, 4)});
    expect(board.woundedCells, {const BoardCoordinate(4, 4)});
    expect(board.sunkShips, isEmpty);
  });

  test('the last cell of a ship sinks it and marks the cells around it', () {
    final (wounded, _) = _board.shoot(const BoardCoordinate(4, 4));
    final (board, result) = wounded.shoot(const BoardCoordinate(4, 5));

    expect(result, ShotResult.sunk);
    expect(board.sunkShips, [_cruiser]);
    expect(board.woundedCells, isEmpty);
    expect(board.missCells, _cruiser.surroundingCells);
    expect(board.canShoot(const BoardCoordinate(3, 3)), isFalse);
  });

  test('marked and off-board cells cannot be shot', () {
    final (board, _) = _board.shoot(const BoardCoordinate(2, 2));

    expect(board.canShoot(const BoardCoordinate(2, 2)), isFalse);
    expect(board.canShoot(const BoardCoordinate(-1, 0)), isFalse);
    expect(board.canShoot(const BoardCoordinate(2, 3)), isTrue);
    expect(board.openCells, hasLength(99));
  });

  test('afloatShipLengths drops each sunk ship from the full fleet', () {
    final (board, _) = _board.shoot(const BoardCoordinate(0, 0));

    expect(board.afloatShipLengths, [4, 3, 3, 2, 2, 2, 1, 1, 1]);
  });

  test('is defeated once every ship is sunk', () {
    var board = _board;
    for (final cell in [..._cruiser.cells, ..._boat.cells]) {
      expect(board.isDefeated, isFalse);
      (board, _) = board.shoot(cell);
    }

    expect(board.isDefeated, isTrue);
  });
}
