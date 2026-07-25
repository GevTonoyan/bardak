import 'package:bardak/features/games/sudoku/sudoku_game/domain/entities/sudoku_saved_game_entity.dart';
import 'package:bardak/features/games/sudoku/sudoku_game/domain/repositories/sudoku_game_repository.dart';

/// Persists the unfinished game so it can be resumed later.
class UpdateSavedSudokuGameUseCase {
  const UpdateSavedSudokuGameUseCase(this._sudokuGameRepository);

  final SudokuGameRepository _sudokuGameRepository;

  Future<bool> call(SudokuSavedGameEntity game) =>
      _sudokuGameRepository.updateSavedGame(game);
}
