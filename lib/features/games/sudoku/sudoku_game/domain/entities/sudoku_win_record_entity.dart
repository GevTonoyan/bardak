import 'package:bardak/features/games/sudoku/sudoku_game/domain/entities/sudoku_stats_entity.dart';
import 'package:equatable/equatable.dart';

/// The outcome of recording a win: the updated lifetime stats for the
/// played difficulty and whether this game set new records.
class SudokuWinRecordEntity extends Equatable {
  const SudokuWinRecordEntity({
    required this.stats,
    required this.isNewBestScore,
    required this.isNewBestTime,
  });

  /// Lifetime stats for the difficulty after this win was recorded.
  final SudokuDifficultyStats stats;

  final bool isNewBestScore;
  final bool isNewBestTime;

  @override
  List<Object?> get props => [stats, isNewBestScore, isNewBestTime];
}
