import 'dart:math';

import 'package:bardak/features/games/sudoku/sudoku_game/domain/entities/sudoku_board_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SudokuBoardEntity.generate', () {
    test('the solution is a valid sudoku grid', () {
      for (var seed = 0; seed < 10; seed++) {
        final board = SudokuBoardEntity.generate(random: Random(seed));
        final all = {1, 2, 3, 4, 5, 6, 7, 8, 9};

        for (var i = 0; i < SudokuBoardEntity.size; i++) {
          final row = {
            for (var c = 0; c < SudokuBoardEntity.size; c++)
              board.solution[i * SudokuBoardEntity.size + c],
          };
          final col = {
            for (var r = 0; r < SudokuBoardEntity.size; r++)
              board.solution[r * SudokuBoardEntity.size + i],
          };
          final box = {
            for (var j = 0; j < SudokuBoardEntity.size; j++)
              board.solution[(i ~/ 3 * 3 + j ~/ 3) * SudokuBoardEntity.size +
                  (i % 3 * 3 + j % 3)],
          };
          expect(row, all, reason: 'row $i, seed $seed');
          expect(col, all, reason: 'col $i, seed $seed');
          expect(box, all, reason: 'box $i, seed $seed');
        }
      }
    });

    test('exposes exactly the requested number of givens', () {
      final board = SudokuBoardEntity.generate(
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
      final board = SudokuBoardEntity.generate(random: Random(2));

      for (var i = 0; i < SudokuBoardEntity.cellCount; i++) {
        if (board.given[i]) {
          expect(board.values[i], board.solution[i]);
        } else {
          expect(board.values[i], SudokuBoardEntity.empty);
        }
      }
    });

    test('different seeds produce different puzzles', () {
      final a = SudokuBoardEntity.generate(random: Random(1));
      final b = SudokuBoardEntity.generate(random: Random(2));

      expect(a.solution, isNot(b.solution));
    });
  });

  group('withValue', () {
    test('sets an editable cell and leaves givens locked', () {
      final board = SudokuBoardEntity.generate(random: Random(3));
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
      var board = SudokuBoardEntity.generate(random: Random(4));
      expect(board.isSolved, isFalse);

      for (var i = 0; i < SudokuBoardEntity.cellCount; i++) {
        if (!board.given[i]) {
          board = board.withValue(i, board.solution[i]);
        }
      }

      expect(board.isSolved, isTrue);
    });

    test('a wrong digit is flagged, empty and correct cells are not', () {
      final board = SudokuBoardEntity.generate(random: Random(5));
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
