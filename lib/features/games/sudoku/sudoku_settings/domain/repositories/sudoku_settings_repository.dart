import 'package:bardak/features/games/sudoku/sudoku_settings/domain/entities/sudoku_difficulty.dart';
import 'package:bardak/features/games/sudoku/sudoku_settings/domain/entities/sudoku_settings_entity.dart';

abstract interface class SudokuSettingsRepository {
  /// Retrieves the currently stored sudoku settings.
  SudokuSettingsEntity getSudokuSettings();

  /// Persists the selected difficulty.
  Future<bool> updateDifficulty(SudokuDifficulty difficulty);

  /// Persists whether the timer is shown.
  Future<bool> updateShowTimer({required bool showTimer});
}
