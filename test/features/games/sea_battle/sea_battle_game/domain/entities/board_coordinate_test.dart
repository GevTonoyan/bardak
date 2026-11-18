import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/board_coordinate.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('isOnBoard covers rows and columns 0 to 9', () {
    expect(const BoardCoordinate(0, 0).isOnBoard, isTrue);
    expect(const BoardCoordinate(9, 9).isOnBoard, isTrue);
    expect(const BoardCoordinate(-1, 0).isOnBoard, isFalse);
    expect(const BoardCoordinate(0, -1).isOnBoard, isFalse);
    expect(const BoardCoordinate(10, 0).isOnBoard, isFalse);
    expect(const BoardCoordinate(0, 10).isOnBoard, isFalse);
  });

  test('shift moves by rows and columns, defaulting to zero', () {
    const cell = BoardCoordinate(4, 4);

    expect(cell.shift(rows: 2), const BoardCoordinate(6, 4));
    expect(cell.shift(columns: -3), const BoardCoordinate(4, 1));
    expect(cell.shift(rows: -1, columns: 1), const BoardCoordinate(3, 5));
    expect(cell.shift(), cell);
  });

  test('equal by row and column', () {
    expect(const BoardCoordinate(2, 3), const BoardCoordinate(2, 3));
    expect(const BoardCoordinate(2, 3), isNot(const BoardCoordinate(3, 2)));
  });
}
