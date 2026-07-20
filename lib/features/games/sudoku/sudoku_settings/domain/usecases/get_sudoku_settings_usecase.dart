import 'package:bardak/features/games/sudoku/sudoku_settings/domain/entities/sudoku_settings_entity.dart';
import 'package:bardak/features/games/sudoku/sudoku_settings/domain/repositories/sudoku_settings_repository.dart';

/// Gets the persisted sudoku settings.
class GetSudokuSettingsUseCase {
  const GetSudokuSettingsUseCase(this._sudokuSettingsRepository);

  final SudokuSettingsRepository _sudokuSettingsRepository;

  SudokuSettingsEntity call() => _sudokuSettingsRepository.getSudokuSettings();
}
