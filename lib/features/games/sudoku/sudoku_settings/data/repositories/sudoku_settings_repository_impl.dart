import 'package:bardak/features/games/sudoku/sudoku_settings/data/data_sources/sudoku_settings_local_data_source.dart';
import 'package:bardak/features/games/sudoku/sudoku_settings/domain/entities/sudoku_difficulty.dart';
import 'package:bardak/features/games/sudoku/sudoku_settings/domain/entities/sudoku_mistakes_mode.dart';
import 'package:bardak/features/games/sudoku/sudoku_settings/domain/entities/sudoku_settings_entity.dart';
import 'package:bardak/features/games/sudoku/sudoku_settings/domain/repositories/sudoku_settings_repository.dart';

class SudokuSettingsRepositoryImpl implements SudokuSettingsRepository {
  const SudokuSettingsRepositoryImpl({required this._dataSource});

  final SudokuSettingsLocalDataSource _dataSource;

  @override
  SudokuSettingsEntity getSudokuSettings() => _dataSource.getSudokuSettings();

  @override
  Future<bool> updateDifficulty(SudokuDifficulty difficulty) =>
      _dataSource.updateDifficulty(difficulty);

  @override
  Future<bool> updateMistakesMode(SudokuMistakesMode mistakesMode) =>
      _dataSource.updateMistakesMode(mistakesMode);

  @override
  Future<bool> updateShowTimer({required bool showTimer}) =>
      _dataSource.updateShowTimer(showTimer: showTimer);
}
