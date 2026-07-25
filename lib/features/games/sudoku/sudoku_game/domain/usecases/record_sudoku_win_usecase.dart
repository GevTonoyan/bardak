import 'package:bardak/features/games/sudoku/sudoku_game/domain/entities/sudoku_stats_entity.dart';
import 'package:bardak/features/games/sudoku/sudoku_game/domain/entities/sudoku_win_record_entity.dart';
import 'package:bardak/features/games/sudoku/sudoku_game/domain/repositories/sudoku_game_repository.dart';
import 'package:bardak/features/games/sudoku/sudoku_settings/domain/entities/sudoku_difficulty.dart';

/// Records a solved puzzle in the lifetime statistics and reports
/// whether the game set a new best time.
class RecordSudokuWinUseCase {
  const RecordSudokuWinUseCase(this._sudokuGameRepository);

  final SudokuGameRepository _sudokuGameRepository;

  Future<SudokuWinRecordEntity> call(RecordSudokuWinParams params) async {
    final stats = _sudokuGameRepository.getStats();
    final current = stats.statsFor(params.difficulty);

    final isNewBestTime =
        current.bestTimeSeconds == null ||
        params.timeSeconds < current.bestTimeSeconds!;

    final updated = SudokuDifficultyStats(
      gamesWon: current.gamesWon + 1,
      bestTimeSeconds: isNewBestTime
          ? params.timeSeconds
          : current.bestTimeSeconds,
    );

    await _sudokuGameRepository.updateStats(
      stats.withStats(params.difficulty, updated),
    );

    return SudokuWinRecordEntity(stats: updated, isNewBestTime: isNewBestTime);
  }
}

class RecordSudokuWinParams {
  const RecordSudokuWinParams({
    required this.difficulty,
    required this.timeSeconds,
  });

  final SudokuDifficulty difficulty;
  final int timeSeconds;
}
