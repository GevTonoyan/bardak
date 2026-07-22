import 'package:bardak/features/games/sudoku/sudoku_game/domain/entities/sudoku_saved_game_entity.dart';
import 'package:bardak/features/games/sudoku/sudoku_game/domain/entities/sudoku_stats_entity.dart';

/// Persistence for the Sudoku game itself: the resumable in-progress
/// snapshot and lifetime statistics.
abstract interface class SudokuGameRepository {
  /// Retrieves the saved unfinished game, or null when there is none.
  SudokuSavedGameEntity? getSavedGame();

  /// Persists [game] as the unfinished game to resume later.
  Future<bool> updateSavedGame(SudokuSavedGameEntity game);

  /// Removes the saved unfinished game.
  Future<bool> clearSavedGame();

  /// Retrieves the lifetime statistics.
  SudokuStatsEntity getStats();

  /// Persists the lifetime statistics.
  Future<bool> updateStats(SudokuStatsEntity stats);
}
