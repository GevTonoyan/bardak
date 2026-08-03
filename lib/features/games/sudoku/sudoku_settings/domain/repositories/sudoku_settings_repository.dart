import 'package:bardak/features/games/sudoku/sudoku_settings/domain/entities/sudoku_board_size.dart';
import 'package:bardak/features/games/sudoku/sudoku_settings/domain/entities/sudoku_difficulty.dart';
import 'package:bardak/features/games/sudoku/sudoku_settings/domain/entities/sudoku_settings_entity.dart';

abstract interface class SudokuSettingsRepository {
  /// Retrieves the currently stored sudoku settings.
  SudokuSettingsEntity getSudokuSettings();

  /// Persists the selected board size.
  Future<bool> updateBoardSize(SudokuBoardSize boardSize);

  /// Persists the selected difficulty.
  Future<bool> updateDifficulty(SudokuDifficulty difficulty);
}
