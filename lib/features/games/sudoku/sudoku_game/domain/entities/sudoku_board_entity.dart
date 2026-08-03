import 'dart:math';

import 'package:equatable/equatable.dart';

/// Full in-memory state of one Sudoku puzzle of any square size.
///
/// The grid is [boxSize] boxes wide and tall, so a side is [size] =
/// `boxSize * boxSize` cells (boxSize 3 → 9×9, boxSize 2 → 4×4). Holds the
/// hidden [solution], the player-visible [values] (0 = empty) and which cells
/// were [given] from the start and cannot be edited.
class SudokuBoardEntity extends Equatable {
  const SudokuBoardEntity({
    required this.boxSize,
    required this.solution,
    required this.values,
    required this.given,
    required this.notes,
  });

  /// Generates a fresh puzzle with a unique solution and roughly
  /// [givensCount] pre-filled cells, on a board [boxSize] boxes across.
  ///
  /// A random solved grid is dug out cell by cell; each removal is kept
  /// only while a solver confirms exactly one solution remains, so the
  /// puzzle can never be completed in a way that disagrees with
  /// [solution]. Digging stops at [givensCount] givens, or earlier if no
  /// further cell can be removed without losing uniqueness.
  factory SudokuBoardEntity.generate({
    required int boxSize,
    required int givensCount,
    Random? random,
  }) {
    final rng = random ?? Random();
    final cellCount = _cellCountFor(boxSize);
    final solution = _randomSolution(rng, boxSize);
    final values = [...solution];

    final order = List.generate(cellCount, (i) => i)..shuffle(rng);
    var givens = cellCount;
    for (final index in order) {
      if (givens <= givensCount) break;

      final removed = values[index];
      values[index] = empty;
      if (_countSolutions(values, boxSize, limit: 2) == 1) {
        givens--;
      } else {
        values[index] = removed;
      }
    }

    return SudokuBoardEntity(
      boxSize: boxSize,
      solution: solution,
      values: values,
      given: [
        for (var i = 0; i < cellCount; i++) values[i] != empty,
      ],
      notes: [for (var i = 0; i < cellCount; i++) const <int>{}],
    );
  }

  /// Restores a board previously serialized with [toJson]. Saves written
  /// before board sizes existed default to the classic 9×9 (boxSize 3).
  factory SudokuBoardEntity.fromJson(Map<String, dynamic> json) {
    return SudokuBoardEntity(
      boxSize: json['boxSize'] as int? ?? 3,
      solution: [...(json['solution'] as List).cast<int>()],
      values: [...(json['values'] as List).cast<int>()],
      given: [...(json['given'] as List).cast<bool>()],
      notes: [
        for (final cellNotes in json['notes'] as List)
          {...(cellNotes as List).cast<int>()},
      ],
    );
  }

  /// An unplayable stand-in shown while the real puzzle is generated in
  /// the background: every cell is locked and nothing can be solved.
  factory SudokuBoardEntity.placeholder({required int boxSize}) {
    final cellCount = _cellCountFor(boxSize);
    return SudokuBoardEntity(
      boxSize: boxSize,
      solution: [for (var i = 0; i < cellCount; i++) -1],
      values: [for (var i = 0; i < cellCount; i++) empty],
      given: [for (var i = 0; i < cellCount; i++) true],
      notes: [for (var i = 0; i < cellCount; i++) const <int>{}],
    );
  }

  static const empty = 0;

  /// Number of boxes along one side; a box is [boxSize]×[boxSize] cells.
  final int boxSize;

  /// The completed grid the player is working towards.
  final List<int> solution;

  /// Current cell values in row-major order; [empty] for blank cells.
  final List<int> values;

  /// Whether each cell was pre-filled and is locked.
  final List<bool> given;

  /// Pencil-marked candidates per cell (1..[size]); empty when none.
  final List<Set<int>> notes;

  /// Cells along one side of the board (and the largest digit).
  int get size => boxSize * boxSize;

  /// Total number of cells on the board.
  int get cellCount => size * size;

  static int _cellCountFor(int boxSize) {
    final size = boxSize * boxSize;
    return size * size;
  }

  /// Whether the board is completely and correctly filled in.
  bool get isSolved {
    for (var i = 0; i < cellCount; i++) {
      if (values[i] != solution[i]) return false;
    }
    return true;
  }

  /// Whether every cell is filled, correctly or not.
  bool get isFull => !values.contains(empty);

  /// Whether the (non-empty) cell holds a wrong digit.
  bool isWrong(int index) =>
      values[index] != empty && values[index] != solution[index];

  /// Whether the (non-empty) cell already holds its solution value.
  bool isCorrect(int index) =>
      values[index] != empty && values[index] == solution[index];

  /// Whether the (non-empty) cell clashes with another cell in its row,
  /// column or box — a rule violation visible without knowing the solution.
  bool hasConflict(int index) {
    final value = values[index];
    if (value == empty) return false;

    final row = index ~/ size;
    final col = index % size;
    final boxRow = row - row % boxSize;
    final boxCol = col - col % boxSize;

    for (var i = 0; i < size; i++) {
      final rowIndex = row * size + i;
      final colIndex = i * size + col;
      final boxIndex = (boxRow + i ~/ boxSize) * size + boxCol + i % boxSize;

      if (rowIndex != index && values[rowIndex] == value) return true;
      if (colIndex != index && values[colIndex] == value) return true;
      if (boxIndex != index && values[boxIndex] == value) return true;
    }
    return false;
  }

  /// The row, column and box index groups the cell at [index] belongs to.
  List<List<int>> unitsOf(int index) {
    final row = index ~/ size;
    final col = index % size;
    final boxRow = row - row % boxSize;
    final boxCol = col - col % boxSize;

    return [
      [for (var i = 0; i < size; i++) row * size + i],
      [for (var i = 0; i < size; i++) i * size + col],
      [
        for (var i = 0; i < size; i++)
          (boxRow + i ~/ boxSize) * size + boxCol + i % boxSize,
      ],
    ];
  }

  /// Whether every cell of [unit] holds its solution value.
  bool isUnitSolved(List<int> unit) =>
      unit.every((i) => values[i] == solution[i]);

  /// Returns a copy with [value] placed at [index]; given cells are locked.
  /// Placing (or erasing) a value clears that cell's pencil marks. A
  /// *correct* placement also erases the digit from every peer cell's
  /// notes in the same row, column and box, since it can no longer go
  /// there — a wrong placement leaves peer notes untouched, because the
  /// digit may still be the right guess for those cells.
  SudokuBoardEntity withValue(int index, int value) {
    if (given[index]) return this;

    final newNotes = [
      for (final cellNotes in notes) {...cellNotes},
    ];
    newNotes[index] = <int>{};
    if (value != empty && value == solution[index]) {
      for (final unit in unitsOf(index)) {
        for (final peer in unit) {
          newNotes[peer].remove(value);
        }
      }
    }

    return SudokuBoardEntity(
      boxSize: boxSize,
      solution: solution,
      values: [...values]..[index] = value,
      given: given,
      notes: newNotes,
    );
  }

  /// How many cells currently hold [digit].
  int countOf(int digit) => values.where((v) => v == digit).length;

  /// Returns a copy toggling candidate [digit] in the empty cell at [index].
  /// Given or already-filled cells are left unchanged.
  SudokuBoardEntity withNote(int index, int digit) {
    if (given[index] || values[index] != empty) return this;

    final newNotes = [
      for (final cellNotes in notes) {...cellNotes},
    ];
    final cell = newNotes[index];
    cell.contains(digit) ? cell.remove(digit) : cell.add(digit);

    return SudokuBoardEntity(
      boxSize: boxSize,
      solution: solution,
      values: values,
      given: given,
      notes: newNotes,
    );
  }

  /// Random solved grid: the canonical pattern
  /// value(r, c) = (r * boxSize + r ~/ boxSize + c) % size + 1, randomized by
  /// relabeling digits and shuffling rows/columns within their bands.
  static List<int> _randomSolution(Random rng, int boxSize) {
    final size = boxSize * boxSize;
    final cellCount = size * size;
    final digits = List.generate(size, (i) => i + 1)..shuffle(rng);
    final rows = _shuffledBandOrder(rng, boxSize);
    final cols = _shuffledBandOrder(rng, boxSize);

    return List<int>.generate(cellCount, (index) {
      final r = rows[index ~/ size];
      final c = cols[index % size];
      return digits[(r * boxSize + r ~/ boxSize + c) % size];
    });
  }

  /// Shuffled row (or column) order that keeps each band of [boxSize] lines
  /// intact: bands are reordered, and lines are reordered within their band.
  static List<int> _shuffledBandOrder(Random rng, int boxSize) {
    final bands = [for (var i = 0; i < boxSize; i++) i]..shuffle(rng);
    return [
      for (final band in bands)
        ...([for (var i = 0; i < boxSize; i++) i]..shuffle(rng))
            .map((line) => band * boxSize + line),
    ];
  }

  /// Counts solutions of [grid] by backtracking, stopping at [limit].
  static int _countSolutions(
    List<int> grid,
    int boxSize, {
    required int limit,
  }) {
    final size = boxSize * boxSize;
    final firstEmpty = grid.indexOf(empty);
    if (firstEmpty == -1) return 1;

    var found = 0;
    for (var digit = 1; digit <= size; digit++) {
      if (!_canPlace(grid, firstEmpty, digit, boxSize)) continue;

      grid[firstEmpty] = digit;
      found += _countSolutions(grid, boxSize, limit: limit - found);
      grid[firstEmpty] = empty;

      if (found >= limit) break;
    }
    return found;
  }

  /// Whether [digit] at [index] breaks no row, column or box constraint.
  static bool _canPlace(List<int> grid, int index, int digit, int boxSize) {
    final size = boxSize * boxSize;
    final row = index ~/ size;
    final col = index % size;
    final boxRow = row - row % boxSize;
    final boxCol = col - col % boxSize;

    for (var i = 0; i < size; i++) {
      if (grid[row * size + i] == digit) return false;
      if (grid[i * size + col] == digit) return false;
      final boxIndex = (boxRow + i ~/ boxSize) * size + boxCol + i % boxSize;
      if (grid[boxIndex] == digit) return false;
    }
    return true;
  }

  /// Serializes the board for persistence; see [SudokuBoardEntity.fromJson].
  Map<String, dynamic> toJson() => {
    'boxSize': boxSize,
    'solution': solution,
    'values': values,
    'given': given,
    'notes': [
      for (final cellNotes in notes) [...cellNotes],
    ],
  };

  @override
  List<Object?> get props => [boxSize, solution, values, given, notes];
}
