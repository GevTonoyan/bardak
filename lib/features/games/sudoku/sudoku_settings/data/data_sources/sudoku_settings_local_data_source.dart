import 'package:bardak/features/games/sudoku/sudoku_settings/domain/entities/sudoku_board_size.dart';
import 'package:bardak/features/games/sudoku/sudoku_settings/domain/entities/sudoku_difficulty.dart';
import 'package:bardak/features/games/sudoku/sudoku_settings/domain/entities/sudoku_settings_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Persists the Sudoku game settings in [SharedPreferences].
abstract interface class SudokuSettingsLocalDataSource {
  /// Retrieves the sudoku settings from shared preferences.
  SudokuSettingsEntity getSudokuSettings();

  Future<bool> updateBoardSize(SudokuBoardSize boardSize);

  Future<bool> updateDifficulty(SudokuDifficulty difficulty);
}

class SudokuSettingsLocalDataSourceImpl
    implements SudokuSettingsLocalDataSource {
  const SudokuSettingsLocalDataSourceImpl({required this._preferences});

  static const _boardSizeKey = 'sudoku_board_size';
  static const _difficultyKey = 'sudoku_difficulty';

  final SharedPreferences _preferences;

  @override
  SudokuSettingsEntity getSudokuSettings() {
    // Missing keys fall back to the entity's constructor defaults.
    const defaults = SudokuSettingsEntity();

    return SudokuSettingsEntity(
      boardSize: SudokuBoardSize.fromString(
        _preferences.getString(_boardSizeKey) ?? defaults.boardSize.name,
      ),
      difficulty: SudokuDifficulty.fromString(
        _preferences.getString(_difficultyKey) ?? defaults.difficulty.name,
      ),
    );
  }

  @override
  Future<bool> updateBoardSize(SudokuBoardSize boardSize) {
    return _preferences.setString(_boardSizeKey, boardSize.name);
  }

  @override
  Future<bool> updateDifficulty(SudokuDifficulty difficulty) {
    return _preferences.setString(_difficultyKey, difficulty.name);
  }
}
