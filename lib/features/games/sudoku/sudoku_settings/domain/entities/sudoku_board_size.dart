import 'package:bardak/features/games/sudoku/sudoku_settings/domain/entities/sudoku_difficulty.dart';

/// The size of a Sudoku board.
///
/// The classic [standard] 9×9 board uses [SudokuDifficulty] to decide how many
/// cells are pre-filled; the [small] 4×4 "kids" board is a fixed, gentle
/// puzzle with no difficulty. A board is [boxSize] boxes across, so a side is
/// [size] = `boxSize * boxSize` cells.
enum SudokuBoardSize {
  /// 4×4, made of 2×2 boxes — a light version for children.
  small,

  /// 9×9, made of 3×3 boxes — the classic board.
  standard;

  /// Boxes along one side; a box is [boxSize]×[boxSize] cells.
  int get boxSize => switch (this) {
    small => 2,
    standard => 3,
  };

  /// Cells along one side of the board (and the largest digit).
  int get size => boxSize * boxSize;

  /// Total number of cells on the board.
  int get cellCount => size * size;

  /// Whether the number of pre-filled cells is chosen by [SudokuDifficulty].
  bool get usesDifficulty => switch (this) {
    small => false,
    standard => true,
  };

  /// Pre-filled cells to aim for on sizes that ignore difficulty (the kids
  /// 4×4). Six of the sixteen cells leaves a real but gentle puzzle (a 4×4
  /// needs at least four givens for a unique solution).
  int get _fixedGivensCount => switch (this) {
    small => 6,
    standard => 0,
  };

  /// Pre-filled cells to generate for this size at [difficulty].
  int givensCountFor(SudokuDifficulty difficulty) =>
      usesDifficulty ? difficulty.givensCount : _fixedGivensCount;

  /// Whether generating this puzzle should run off the main thread. The tiny
  /// 4×4 board is always instant; the 9×9 defers to the difficulty.
  bool needsBackgroundGeneration(SudokuDifficulty difficulty) =>
      usesDifficulty && difficulty.needsBackgroundGeneration;

  /// Key under which best-time/win stats for this size are recorded. The
  /// classic board keeps using the plain difficulty name (so existing records
  /// are preserved); sizes without difficulty use their own name.
  String statsKey(SudokuDifficulty difficulty) =>
      usesDifficulty ? difficulty.name : name;

  /// Parses a persisted [SudokuBoardSize] name, defaulting to [standard].
  static SudokuBoardSize fromString(String? value) => values.firstWhere(
    (boardSize) => boardSize.name == value,
    orElse: () => standard,
  );
}
