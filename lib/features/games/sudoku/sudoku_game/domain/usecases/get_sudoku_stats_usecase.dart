import 'package:bardak/features/games/sudoku/sudoku_game/domain/entities/sudoku_stats_entity.dart';
import 'package:bardak/features/games/sudoku/sudoku_game/domain/repositories/sudoku_game_repository.dart';

/// Retrieves the lifetime Sudoku statistics (wins and best time per
/// difficulty).
class GetSudokuStatsUseCase {
  const GetSudokuStatsUseCase(this._sudokuGameRepository);

  final SudokuGameRepository _sudokuGameRepository;

  SudokuStatsEntity call() => _sudokuGameRepository.getStats();
}
