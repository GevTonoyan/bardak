import 'package:equatable/equatable.dart';

/// Lifetime results for one difficulty: wins and best time.
class SudokuDifficultyStats extends Equatable {
  const SudokuDifficultyStats({
    this.gamesWon = 0,
    this.bestTimeSeconds,
  });

  /// Restores stats previously serialized with [toJson].
  factory SudokuDifficultyStats.fromJson(Map<String, dynamic> json) {
    return SudokuDifficultyStats(
      gamesWon: json['gamesWon'] as int? ?? 0,
      bestTimeSeconds: json['bestTimeSeconds'] as int?,
    );
  }

  final int gamesWon;

  /// Fastest solve; null until the first win.
  final int? bestTimeSeconds;

  /// Serializes the stats for persistence; see
  /// [SudokuDifficultyStats.fromJson].
  Map<String, dynamic> toJson() => {
    'gamesWon': gamesWon,
    'bestTimeSeconds': bestTimeSeconds,
  };

  @override
  List<Object?> get props => [gamesWon, bestTimeSeconds];
}

/// Lifetime Sudoku statistics, keyed by a stats key that identifies the game
/// mode (board size and, for the classic board, difficulty). See
/// `SudokuBoardSize.statsKey`.
class SudokuStatsEntity extends Equatable {
  const SudokuStatsEntity({this.byKey = const {}});

  /// Restores stats previously serialized with [toJson]. Keys are opaque
  /// strings, so records written before board sizes existed (keyed by plain
  /// difficulty name) are read unchanged.
  factory SudokuStatsEntity.fromJson(Map<String, dynamic> json) {
    return SudokuStatsEntity(
      byKey: {
        for (final entry in json.entries)
          entry.key: SudokuDifficultyStats.fromJson(
            entry.value as Map<String, dynamic>,
          ),
      },
    );
  }

  final Map<String, SudokuDifficultyStats> byKey;

  /// Stats for the mode [key]; zeroed when none are recorded yet.
  SudokuDifficultyStats statsFor(String key) =>
      byKey[key] ?? const SudokuDifficultyStats();

  /// Returns a copy with [stats] stored under [key].
  SudokuStatsEntity withStats(String key, SudokuDifficultyStats stats) {
    return SudokuStatsEntity(byKey: {...byKey, key: stats});
  }

  /// Serializes the stats for persistence; see [SudokuStatsEntity.fromJson].
  Map<String, dynamic> toJson() => {
    for (final entry in byKey.entries) entry.key: entry.value.toJson(),
  };

  @override
  List<Object?> get props => [byKey];
}
