import 'package:bardak/features/games/sudoku/sudoku_game/domain/repositories/sudoku_game_repository.dart';

/// Removes the saved unfinished game (after a win, loss or restart).
class ClearSavedSudokuGameUseCase {
  const ClearSavedSudokuGameUseCase(this._sudokuGameRepository);

  final SudokuGameRepository _sudokuGameRepository;

  Future<bool> call() => _sudokuGameRepository.clearSavedGame();
}
