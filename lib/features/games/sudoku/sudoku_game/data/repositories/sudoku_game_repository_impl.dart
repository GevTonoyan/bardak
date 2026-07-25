import 'package:bardak/features/games/sudoku/sudoku_game/data/data_sources/sudoku_game_local_data_source.dart';
import 'package:bardak/features/games/sudoku/sudoku_game/domain/entities/sudoku_saved_game_entity.dart';
import 'package:bardak/features/games/sudoku/sudoku_game/domain/entities/sudoku_stats_entity.dart';
import 'package:bardak/features/games/sudoku/sudoku_game/domain/repositories/sudoku_game_repository.dart';

class SudokuGameRepositoryImpl implements SudokuGameRepository {
  const SudokuGameRepositoryImpl({required this._dataSource});

  final SudokuGameLocalDataSource _dataSource;

  @override
  SudokuSavedGameEntity? getSavedGame() => _dataSource.getSavedGame();

  @override
  Future<bool> updateSavedGame(SudokuSavedGameEntity game) =>
      _dataSource.updateSavedGame(game);

  @override
  Future<bool> clearSavedGame() => _dataSource.clearSavedGame();

  @override
  SudokuStatsEntity getStats() => _dataSource.getStats();

  @override
  Future<bool> updateStats(SudokuStatsEntity stats) =>
      _dataSource.updateStats(stats);
}
