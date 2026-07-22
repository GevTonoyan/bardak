import 'dart:convert';
import 'dart:math';

import 'package:bardak/features/games/sudoku/sudoku_game/domain/entities/sudoku_board_entity.dart';
import 'package:bardak/features/games/sudoku/sudoku_game/domain/entities/sudoku_saved_game_entity.dart';
import 'package:bardak/features/games/sudoku/sudoku_settings/domain/entities/sudoku_difficulty.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('a saved game survives a JSON round-trip', () {
    var board = SudokuBoardEntity.generate(random: Random(3));
    final editable = board.given.indexOf(false);
    board = board
        .withNote(editable, 4)
        .withNote(editable, 7)
        .withValue(board.given.lastIndexOf(false), 5);

    final game = SudokuSavedGameEntity(
      board: board,
      difficulty: SudokuDifficulty.extreme,
      mistakes: 2,
      score: 675,
      scoredCells: {editable, 42},
      elapsedSeconds: 913,
    );

    // Through actual JSON text, as the data source stores it.
    final restored = SudokuSavedGameEntity.fromJson(
      jsonDecode(jsonEncode(game.toJson())) as Map<String, dynamic>,
    );

    expect(restored, game);
  });

  test('missing optional fields fall back to defaults', () {
    final board = SudokuBoardEntity.generate(random: Random(3));
    final json = {'board': board.toJson(), 'difficulty': 'hard'};

    final restored = SudokuSavedGameEntity.fromJson(json);

    expect(restored.board, board);
    expect(restored.difficulty, SudokuDifficulty.hard);
    expect(restored.mistakes, 0);
    expect(restored.score, 0);
    expect(restored.scoredCells, isEmpty);
    expect(restored.elapsedSeconds, 0);
  });
}
