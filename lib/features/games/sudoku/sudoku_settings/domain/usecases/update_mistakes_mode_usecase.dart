import 'package:bardak/features/games/sudoku/sudoku_settings/domain/entities/sudoku_mistakes_mode.dart';
import 'package:bardak/features/games/sudoku/sudoku_settings/domain/repositories/sudoku_settings_repository.dart';

/// Persists how mistakes are flagged during the game.
class UpdateMistakesModeUseCase {
  const UpdateMistakesModeUseCase(this._sudokuSettingsRepository);

  final SudokuSettingsRepository _sudokuSettingsRepository;

  Future<bool> call(SudokuMistakesMode mistakesMode) =>
      _sudokuSettingsRepository.updateMistakesMode(mistakesMode);
}
