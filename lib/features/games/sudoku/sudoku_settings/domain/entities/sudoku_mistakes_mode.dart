/// How mistakes are flagged during a Sudoku game.
///
/// Part of the persisted sudoku settings.
enum SudokuMistakesMode {
  /// Nothing is flagged.
  off,

  /// Only rule violations visible on the board (a digit repeated in a row,
  /// column or box) — what a player could spot without knowing the solution.
  conflicts,

  /// Entries are checked against the hidden solution.
  errors;

  /// Parses a persisted [SudokuMistakesMode] name, defaulting to [errors].
  static SudokuMistakesMode fromString(String? value) => values.firstWhere(
    (mode) => mode.name == value,
    orElse: () => errors,
  );
}
