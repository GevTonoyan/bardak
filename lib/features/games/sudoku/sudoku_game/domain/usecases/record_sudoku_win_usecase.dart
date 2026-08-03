import 'package:bardak/features/games/sudoku/sudoku_game/domain/entities/sudoku_stats_entity.dart';
import 'package:bardak/features/games/sudoku/sudoku_game/domain/entities/sudoku_win_record_entity.dart';
import 'package:bardak/features/games/sudoku/sudoku_game/domain/repositories/sudoku_game_repository.dart';

/// Records a solved puzzle in the lifetime statistics and reports
/// whether the game set a new best time.
class RecordSudokuWinUseCase {
  const RecordSudokuWinUseCase(this._sudokuGameRepository);

  final SudokuGameRepository _sudokuGameRepository;

  Future<SudokuWinRecordEntity> call(RecordSudokuWinParams params) async {
    final stats = _sudokuGameRepository.getStats();
    final current = stats.statsFor(params.statsKey);

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
      stats.withStats(params.statsKey, updated),
    );

    return SudokuWinRecordEntity(stats: updated, isNewBestTime: isNewBestTime);
  }
}

class RecordSudokuWinParams {
  const RecordSudokuWinParams({
    required this.statsKey,
    required this.timeSeconds,
  });

  /// Identifies the game mode the win belongs to (see
  /// `SudokuBoardSize.statsKey`).
  final String statsKey;
  final int timeSeconds;
}
