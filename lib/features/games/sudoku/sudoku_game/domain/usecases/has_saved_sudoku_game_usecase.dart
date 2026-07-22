import 'package:bardak/features/games/sudoku/sudoku_game/domain/repositories/sudoku_game_repository.dart';

/// Whether an unfinished game is saved and can be resumed.
class HasSavedSudokuGameUseCase {
  const HasSavedSudokuGameUseCase(this._sudokuGameRepository);

  final SudokuGameRepository _sudokuGameRepository;

  bool call() => _sudokuGameRepository.getSavedGame() != null;
}
