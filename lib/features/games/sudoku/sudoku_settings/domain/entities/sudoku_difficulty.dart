/// Difficulty levels for a Sudoku puzzle, controlling how many cells are
/// pre-filled.
///
/// Part of the persisted sudoku settings so the last choice is remembered.
enum SudokuDifficulty {
  easy,
  medium,
  hard,
  expert,
  extreme;

  /// Number of pre-filled cells the generator aims for.
  int get givensCount => switch (this) {
    easy => 42,
    medium => 34,
    hard => 28,
    expert => 25,
    extreme => 22,
  };

  /// Score awarded for each correctly placed digit.
  int get pointsPerCell => switch (this) {
    easy => 50,
    medium => 75,
    hard => 100,
    expert => 150,
    extreme => 250,
  };

  /// Whether generating this puzzle is slow enough to run off the main
  /// thread (with a loading state). Easy/medium/hard finish in well under
  /// a frame, so they are generated synchronously; expert and extreme can
  /// take hundreds of milliseconds to over a second and must not block UI.
  bool get needsBackgroundGeneration => switch (this) {
    easy || medium || hard => false,
    expert || extreme => true,
  };

  /// Parses a persisted [SudokuDifficulty] name, defaulting to [medium].
  static SudokuDifficulty fromString(String? value) => values.firstWhere(
    (difficulty) => difficulty.name == value,
    orElse: () => medium,
  );
}
