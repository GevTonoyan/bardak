import 'package:bardak/features/games/sudoku/sudoku_settings/domain/entities/sudoku_difficulty.dart';
import 'package:equatable/equatable.dart';

/// Lifetime results for one difficulty: wins, best score and best time.
class SudokuDifficultyStats extends Equatable {
  const SudokuDifficultyStats({
    this.gamesWon = 0,
    this.bestScore = 0,
    this.bestTimeSeconds,
  });

  /// Restores stats previously serialized with [toJson].
  factory SudokuDifficultyStats.fromJson(Map<String, dynamic> json) {
    return SudokuDifficultyStats(
      gamesWon: json['gamesWon'] as int? ?? 0,
      bestScore: json['bestScore'] as int? ?? 0,
      bestTimeSeconds: json['bestTimeSeconds'] as int?,
    );
  }

  final int gamesWon;
  final int bestScore;

  /// Fastest solve; null until the first win.
  final int? bestTimeSeconds;

  /// Serializes the stats for persistence; see
  /// [SudokuDifficultyStats.fromJson].
  Map<String, dynamic> toJson() => {
    'gamesWon': gamesWon,
    'bestScore': bestScore,
    'bestTimeSeconds': bestTimeSeconds,
  };

  @override
  List<Object?> get props => [gamesWon, bestScore, bestTimeSeconds];
}

/// Per-difficulty lifetime Sudoku statistics.
class SudokuStatsEntity extends Equatable {
  const SudokuStatsEntity({this.byDifficulty = const {}});

  /// Restores stats previously serialized with [toJson].
  factory SudokuStatsEntity.fromJson(Map<String, dynamic> json) {
    return SudokuStatsEntity(
      byDifficulty: {
        for (final entry in json.entries)
          SudokuDifficulty.fromString(
            entry.key,
          ): SudokuDifficultyStats.fromJson(
            entry.value as Map<String, dynamic>,
          ),
      },
    );
  }

  final Map<SudokuDifficulty, SudokuDifficultyStats> byDifficulty;

  /// Stats for [difficulty]; zeroed when none are recorded yet.
  SudokuDifficultyStats statsFor(SudokuDifficulty difficulty) =>
      byDifficulty[difficulty] ?? const SudokuDifficultyStats();

  /// Returns a copy with [stats] stored for [difficulty].
  SudokuStatsEntity withStats(
    SudokuDifficulty difficulty,
    SudokuDifficultyStats stats,
  ) {
    return SudokuStatsEntity(
      byDifficulty: {...byDifficulty, difficulty: stats},
    );
  }

  /// Serializes the stats for persistence; see [SudokuStatsEntity.fromJson].
  Map<String, dynamic> toJson() => {
    for (final entry in byDifficulty.entries)
      entry.key.name: entry.value.toJson(),
  };

  @override
  List<Object?> get props => [byDifficulty];
}
