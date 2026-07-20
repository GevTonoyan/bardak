import 'package:bardak/features/games/sudoku/sudoku_settings/domain/entities/sudoku_difficulty.dart';
import 'package:bardak/features/games/sudoku/sudoku_settings/domain/entities/sudoku_mistakes_mode.dart';
import 'package:bardak/features/games/sudoku/sudoku_settings/domain/entities/sudoku_settings_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Persists the Sudoku game settings in [SharedPreferences].
abstract interface class SudokuSettingsLocalDataSource {
  /// Retrieves the sudoku settings from shared preferences.
  SudokuSettingsEntity getSudokuSettings();

  Future<bool> updateDifficulty(SudokuDifficulty difficulty);

  Future<bool> updateMistakesMode(SudokuMistakesMode mistakesMode);

  Future<bool> updateShowTimer({required bool showTimer});
}

class SudokuSettingsLocalDataSourceImpl
    implements SudokuSettingsLocalDataSource {
  const SudokuSettingsLocalDataSourceImpl({required this._preferences});

  static const _difficultyKey = 'sudoku_difficulty';
  static const _mistakesModeKey = 'sudoku_mistakes_mode';
  static const _showTimerKey = 'sudoku_show_timer';

  final SharedPreferences _preferences;

  @override
  SudokuSettingsEntity getSudokuSettings() {
    // Missing keys fall back to the entity's constructor defaults.
    const defaults = SudokuSettingsEntity();

    return SudokuSettingsEntity(
      difficulty: SudokuDifficulty.fromString(
        _preferences.getString(_difficultyKey) ?? defaults.difficulty.name,
      ),
      mistakesMode: SudokuMistakesMode.fromString(
        _preferences.getString(_mistakesModeKey) ?? defaults.mistakesMode.name,
      ),
      showTimer: _preferences.getBool(_showTimerKey) ?? defaults.showTimer,
    );
  }

  @override
  Future<bool> updateDifficulty(SudokuDifficulty difficulty) {
    return _preferences.setString(_difficultyKey, difficulty.name);
  }

  @override
  Future<bool> updateMistakesMode(SudokuMistakesMode mistakesMode) {
    return _preferences.setString(_mistakesModeKey, mistakesMode.name);
  }

  @override
  Future<bool> updateShowTimer({required bool showTimer}) {
    return _preferences.setBool(_showTimerKey, showTimer);
  }
}
