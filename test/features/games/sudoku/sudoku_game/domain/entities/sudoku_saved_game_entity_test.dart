import 'dart:convert';
import 'dart:math';

import 'package:bardak/features/games/sudoku/sudoku_game/domain/entities/sudoku_board_entity.dart';
import 'package:bardak/features/games/sudoku/sudoku_game/domain/entities/sudoku_saved_game_entity.dart';
import 'package:bardak/features/games/sudoku/sudoku_settings/domain/entities/sudoku_board_size.dart';
import 'package:bardak/features/games/sudoku/sudoku_settings/domain/entities/sudoku_difficulty.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('a saved game survives a JSON round-trip', () {
    var board = SudokuBoardEntity.generate(
      boxSize: 3,
      givensCount: 36,
      random: Random(3),
    );
    final editable = board.given.indexOf(false);
    board = board
        .withNote(editable, 4)
        .withNote(editable, 7)
        .withValue(board.given.lastIndexOf(false), 5);

    final game = SudokuSavedGameEntity(
      board: board,
      boardSize: SudokuBoardSize.standard,
      difficulty: SudokuDifficulty.extreme,
      mistakes: 2,
      elapsedSeconds: 913,
    );

    // Through actual JSON text, as the data source stores it.
    final restored = SudokuSavedGameEntity.fromJson(
      jsonDecode(jsonEncode(game.toJson())) as Map<String, dynamic>,
    );

    expect(restored, game);
  });

  test('a 4×4 saved game survives a JSON round-trip', () {
    final board = SudokuBoardEntity.generate(
      boxSize: 2,
      givensCount: 8,
      random: Random(1),
    );

    final game = SudokuSavedGameEntity(
      board: board,
      boardSize: SudokuBoardSize.small,
      difficulty: SudokuDifficulty.medium,
      mistakes: 1,
      elapsedSeconds: 42,
    );

    final restored = SudokuSavedGameEntity.fromJson(
      jsonDecode(jsonEncode(game.toJson())) as Map<String, dynamic>,
    );

    expect(restored, game);
    expect(restored.board.boxSize, 2);
    expect(restored.boardSize, SudokuBoardSize.small);
  });

  test('missing optional fields fall back to defaults', () {
    final board = SudokuBoardEntity.generate(
      boxSize: 3,
      givensCount: 36,
      random: Random(3),
    );
    final json = {'board': board.toJson(), 'difficulty': 'hard'};

    final restored = SudokuSavedGameEntity.fromJson(json);

    expect(restored.board, board);
    expect(restored.boardSize, SudokuBoardSize.standard);
    expect(restored.difficulty, SudokuDifficulty.hard);
    expect(restored.mistakes, 0);
    expect(restored.elapsedSeconds, 0);
  });
}
