import 'dart:math';

import 'package:bardak/features/games/sudoku/sudoku_game/data/data_sources/sudoku_game_local_data_source.dart';
import 'package:bardak/features/games/sudoku/sudoku_game/domain/entities/sudoku_board_entity.dart';
import 'package:bardak/features/games/sudoku/sudoku_game/domain/entities/sudoku_saved_game_entity.dart';
import 'package:bardak/features/games/sudoku/sudoku_game/domain/entities/sudoku_stats_entity.dart';
import 'package:bardak/features/games/sudoku/sudoku_settings/domain/entities/sudoku_difficulty.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late SudokuGameLocalDataSourceImpl dataSource;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    dataSource = SudokuGameLocalDataSourceImpl(
      preferences: await SharedPreferences.getInstance(),
    );
  });

  SudokuSavedGameEntity buildGame() => SudokuSavedGameEntity(
    board: SudokuBoardEntity.generate(random: Random(5)),
    difficulty: SudokuDifficulty.expert,
    mistakes: 1,
    score: 300,
    scoredCells: const {3, 14},
    elapsedSeconds: 77,
  );

  test('a saved game is stored, retrieved and cleared', () async {
    expect(dataSource.getSavedGame(), isNull);

    final game = buildGame();
    await dataSource.updateSavedGame(game);
    expect(dataSource.getSavedGame(), game);

    await dataSource.clearSavedGame();
    expect(dataSource.getSavedGame(), isNull);
  });

  test('stats are stored and retrieved per difficulty', () async {
    expect(dataSource.getStats(), const SudokuStatsEntity());

    const stats = SudokuStatsEntity(
      byDifficulty: {
        SudokuDifficulty.easy: SudokuDifficultyStats(
          gamesWon: 2,
          bestScore: 400,
          bestTimeSeconds: 250,
        ),
        SudokuDifficulty.extreme: SudokuDifficultyStats(
          gamesWon: 1,
          bestScore: 2000,
        ),
      },
    );
    await dataSource.updateStats(stats);

    expect(dataSource.getStats(), stats);
  });
}
