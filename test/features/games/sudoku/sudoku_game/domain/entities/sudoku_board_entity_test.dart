import 'dart:math';

import 'package:bardak/features/games/sudoku/sudoku_game/domain/entities/sudoku_board_entity.dart';
import 'package:flutter_test/flutter_test.dart';

/// Fails unless every row, column and box of the board's solution holds each
/// digit 1..size exactly once — for any board size.
void _expectValidSolution(SudokuBoardEntity board) {
  final size = board.size;
  final box = board.boxSize;
  final all = {for (var d = 1; d <= size; d++) d};

  for (var i = 0; i < size; i++) {
    final row = {for (var c = 0; c < size; c++) board.solution[i * size + c]};
    final col = {for (var r = 0; r < size; r++) board.solution[r * size + i]};
    final boxCells = {
      for (var j = 0; j < size; j++)
        board.solution[(i ~/ box * box + j ~/ box) * size +
            (i % box * box + j % box)],
    };
    expect(row, all, reason: 'row $i');
    expect(col, all, reason: 'col $i');
    expect(boxCells, all, reason: 'box $i');
  }
}

void main() {
  group('SudokuBoardEntity.generate', () {
    test('produces a valid 9×9 solution across seeds', () {
      for (var seed = 0; seed < 10; seed++) {
        _expectValidSolution(
          SudokuBoardEntity.generate(
            boxSize: 3,
            givensCount: 36,
            random: Random(seed),
          ),
        );
      }
    });

    test('produces a valid 4×4 solution with a unique puzzle', () {
      for (var seed = 0; seed < 10; seed++) {
        final board = SudokuBoardEntity.generate(
          boxSize: 2,
          givensCount: 6,
          random: Random(seed),
        );
        expect(board.size, 4);
        expect(board.cellCount, 16);
        _expectValidSolution(board);
        // The dig keeps a unique solution, so the givens are enough to imply
        // the whole board — i.e. filling the solution solves it.
        var solved = board;
        for (var i = 0; i < board.cellCount; i++) {
          if (!board.given[i]) {
            solved = solved.withValue(i, board.solution[i]);
          }
        }
        expect(solved.isSolved, isTrue);
      }
    });

    test('exposes exactly the requested number of givens', () {
      final board = SudokuBoardEntity.generate(
        boxSize: 3,
        givensCount: 30,
        random: Random(1),
      );

      expect(board.given.where((g) => g).length, 30);
      expect(
        board.values.where((v) => v != SudokuBoardEntity.empty).length,
        30,
      );
    });

    test('given cells show their solution value, others are empty', () {
      final board = SudokuBoardEntity.generate(
        boxSize: 3,
        givensCount: 36,
        random: Random(2),
      );

      for (var i = 0; i < board.cellCount; i++) {
        if (board.given[i]) {
          expect(board.values[i], board.solution[i]);
        } else {
          expect(board.values[i], SudokuBoardEntity.empty);
        }
      }
    });

    test('different seeds produce different puzzles', () {
      final a = SudokuBoardEntity.generate(
        boxSize: 3,
        givensCount: 36,
        random: Random(1),
      );
      final b = SudokuBoardEntity.generate(
        boxSize: 3,
        givensCount: 36,
        random: Random(2),
      );

      expect(a.solution, isNot(b.solution));
    });
  });

  group('withValue', () {
    test('sets an editable cell and leaves givens locked', () {
      final board = SudokuBoardEntity.generate(
        boxSize: 3,
        givensCount: 36,
        random: Random(3),
      );
      final editable = board.given.indexOf(false);
      final locked = board.given.indexOf(true);

      final updated = board.withValue(editable, 5);
      expect(updated.values[editable], 5);

      final unchanged = updated.withValue(locked, 5);
      expect(unchanged.values[locked], board.solution[locked]);
    });
  });

  group('isSolved and isWrong', () {
    test('filling every cell with the solution solves the board', () {
      var board = SudokuBoardEntity.generate(
        boxSize: 3,
        givensCount: 36,
        random: Random(4),
      );
      expect(board.isSolved, isFalse);

      for (var i = 0; i < board.cellCount; i++) {
        if (!board.given[i]) {
          board = board.withValue(i, board.solution[i]);
        }
      }

      expect(board.isSolved, isTrue);
    });

    test('a wrong digit is flagged, empty and correct cells are not', () {
      final board = SudokuBoardEntity.generate(
        boxSize: 3,
        givensCount: 36,
        random: Random(5),
      );
      final index = board.given.indexOf(false);
      final wrongDigit = board.solution[index] == 9 ? 1 : 9;

      expect(board.isWrong(index), isFalse, reason: 'empty is not wrong');
      expect(board.withValue(index, wrongDigit).isWrong(index), isTrue);
      expect(
        board.withValue(index, board.solution[index]).isWrong(index),
        isFalse,
      );
    });
  });
}
