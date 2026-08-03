import 'package:bardak/features/games/sudoku/sudoku_settings/domain/entities/sudoku_board_size.dart';
import 'package:bardak/features/games/sudoku/sudoku_settings/domain/repositories/sudoku_settings_repository.dart';

/// Persists the selected sudoku board size.
class UpdateSudokuBoardSizeUseCase {
  const UpdateSudokuBoardSizeUseCase(this._sudokuSettingsRepository);

  final SudokuSettingsRepository _sudokuSettingsRepository;

  Future<bool> call(SudokuBoardSize boardSize) =>
      _sudokuSettingsRepository.updateBoardSize(boardSize);
}
