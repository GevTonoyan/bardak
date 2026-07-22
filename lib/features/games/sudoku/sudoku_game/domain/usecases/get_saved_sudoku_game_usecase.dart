import 'package:bardak/features/games/sudoku/sudoku_game/domain/entities/sudoku_saved_game_entity.dart';
import 'package:bardak/features/games/sudoku/sudoku_game/domain/repositories/sudoku_game_repository.dart';

/// Retrieves the saved unfinished game, or null when there is none.
class GetSavedSudokuGameUseCase {
  const GetSavedSudokuGameUseCase(this._sudokuGameRepository);

  final SudokuGameRepository _sudokuGameRepository;

  SudokuSavedGameEntity? call() => _sudokuGameRepository.getSavedGame();
}
