import 'dart:math';

import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/board_coordinate.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/fleet_entity.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/ship_entity.dart';
import 'package:flutter_test/flutter_test.dart';

ShipEntity _ship(
  int id,
  int row,
  int column, {
  int length = 2,
  ShipOrientation orientation = ShipOrientation.horizontal,
}) => ShipEntity(
  id: id,
  length: length,
  origin: BoardCoordinate(row, column),
  orientation: orientation,
);

void main() {
  group('FleetEntity.canPlace', () {
    final fleet = const FleetEntity().withShip(_ship(0, 4, 4));

    test('rejects overlapping and touching ships, diagonals included', () {
      expect(fleet.canPlace(_ship(1, 4, 5)), isFalse); // overlap
      expect(fleet.canPlace(_ship(1, 4, 6)), isFalse); // side by side
      expect(fleet.canPlace(_ship(1, 3, 6)), isFalse); // diagonal
      expect(fleet.canPlace(_ship(1, 5, 2)), isFalse); // diagonal, left
    });

    test('accepts a ship one empty cell away', () {
      expect(fleet.canPlace(_ship(1, 4, 7)), isTrue);
      expect(fleet.canPlace(_ship(1, 2, 4)), isTrue);
    });

    test('rejects a ship off the board', () {
      expect(fleet.canPlace(_ship(1, 9, 9)), isFalse);
    });

    test('ignores the ship itself when moving it', () {
      expect(fleet.canPlace(_ship(0, 4, 5)), isTrue);
    });
  });

  test('withShip replaces a ship with the same id', () {
    final fleet = const FleetEntity()
        .withShip(_ship(0, 0, 0))
        .withShip(_ship(0, 5, 5));

    expect(fleet.ships, [_ship(0, 5, 5)]);
  });

  test('tracks unplaced ships and completeness', () {
    final fleet = const FleetEntity().withShip(_ship(3, 0, 0));

    expect(fleet.unplacedShipIds, [0, 1, 2, 4, 5, 6, 7, 8, 9]);
    expect(fleet.isComplete, isFalse);
  });

  test('random places the full fleet without any ships touching', () {
    for (var seed = 0; seed < 200; seed++) {
      final fleet = FleetEntity.random(Random(seed));

      expect(fleet.isComplete, isTrue);
      expect(
        fleet.ships.map((ship) => ship.length).toList()..sort(),
        [...FleetEntity.shipLengths]..sort(),
      );
      for (final ship in fleet.ships) {
        expect(fleet.canPlace(ship), isTrue, reason: 'seed $seed');
      }
    }
  });
}
