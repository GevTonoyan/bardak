import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/board_coordinate.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/ship_entity.dart';
import 'package:flutter_test/flutter_test.dart';

ShipEntity _ship(
  int row,
  int column, {
  int length = 2,
  ShipOrientation orientation = ShipOrientation.horizontal,
}) => ShipEntity(
  id: 0,
  length: length,
  origin: BoardCoordinate(row, column),
  orientation: orientation,
);

void main() {
  test('cells extend right when horizontal and down when vertical', () {
    expect(_ship(2, 3, length: 3).cells, const [
      BoardCoordinate(2, 3),
      BoardCoordinate(2, 4),
      BoardCoordinate(2, 5),
    ]);
    expect(
      _ship(2, 3, length: 3, orientation: ShipOrientation.vertical).cells,
      const [
        BoardCoordinate(2, 3),
        BoardCoordinate(3, 3),
        BoardCoordinate(4, 3),
      ],
    );
  });

  test('is off the board when it sticks out', () {
    expect(_ship(0, 8).isOnBoard, isTrue);
    expect(_ship(0, 9).isOnBoard, isFalse);
    expect(_ship(-1, 0).isOnBoard, isFalse);
    expect(
      _ship(9, 0, orientation: ShipOrientation.vertical).isOnBoard,
      isFalse,
    );
  });

  test('occupies only its own cells', () {
    final ship = _ship(4, 4);

    expect(ship.occupies(const BoardCoordinate(4, 4)), isTrue);
    expect(ship.occupies(const BoardCoordinate(4, 5)), isTrue);
    expect(ship.occupies(const BoardCoordinate(4, 6)), isFalse);
    expect(ship.occupies(const BoardCoordinate(5, 4)), isFalse);
  });

  test('area is the ship and every cell touching it, diagonals included', () {
    // A 2-cell ship in the middle: a 3×4 block.
    final area = _ship(4, 4).area;

    expect(area, hasLength(12));
    expect(area, containsAll(_ship(4, 4).cells));
    expect(area, contains(const BoardCoordinate(3, 3)));
    expect(area, contains(const BoardCoordinate(5, 6)));
    expect(area, isNot(contains(const BoardCoordinate(4, 7))));
  });

  test('surroundingCells are the area without the ship', () {
    final ship = _ship(4, 4);

    expect(ship.surroundingCells, hasLength(10));
    expect(ship.surroundingCells.any(ship.occupies), isFalse);
  });

  test('surroundingCells are clipped to the board', () {
    // A single-cell ship in the corner touches three cells.
    expect(_ship(0, 0, length: 1).surroundingCells, {
      const BoardCoordinate(0, 1),
      const BoardCoordinate(1, 0),
      const BoardCoordinate(1, 1),
    });
  });

  test('copyWith moves or rotates the ship but keeps its id and length', () {
    const ship = ShipEntity(id: 3, length: 3, origin: BoardCoordinate(1, 1));

    expect(
      ship.copyWith(
        origin: const BoardCoordinate(5, 2),
        orientation: ShipOrientation.vertical,
      ),
      const ShipEntity(
        id: 3,
        length: 3,
        origin: BoardCoordinate(5, 2),
        orientation: ShipOrientation.vertical,
      ),
    );
    expect(ship.copyWith(), ship);
  });

  test('ShipOrientation.rotated flips between horizontal and vertical', () {
    expect(ShipOrientation.horizontal.rotated, ShipOrientation.vertical);
    expect(ShipOrientation.vertical.rotated, ShipOrientation.horizontal);
  });
}
