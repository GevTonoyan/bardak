/// Difficulty levels for a Sudoku puzzle, controlling how many cells are
/// pre-filled.
///
/// Part of the persisted sudoku settings so the last choice is remembered.
enum SudokuDifficulty {
  easy,
  medium,
  hard;

  /// Number of pre-filled cells the generator aims for.
  int get givensCount => switch (this) {
    easy => 42,
    medium => 34,
    hard => 28,
  };

  /// Parses a persisted [SudokuDifficulty] name, defaulting to [medium].
  static SudokuDifficulty fromString(String? value) => values.firstWhere(
    (difficulty) => difficulty.name == value,
    orElse: () => medium,
  );
}
