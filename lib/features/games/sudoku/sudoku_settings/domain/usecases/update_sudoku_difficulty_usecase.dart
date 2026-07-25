import 'package:bardak/features/games/sudoku/sudoku_settings/domain/entities/sudoku_difficulty.dart';
import 'package:bardak/features/games/sudoku/sudoku_settings/domain/repositories/sudoku_settings_repository.dart';

/// Persists the selected sudoku difficulty.
class UpdateSudokuDifficultyUseCase {
  const UpdateSudokuDifficultyUseCase(this._sudokuSettingsRepository);

  final SudokuSettingsRepository _sudokuSettingsRepository;

  Future<bool> call(SudokuDifficulty difficulty) =>
      _sudokuSettingsRepository.updateDifficulty(difficulty);
}
