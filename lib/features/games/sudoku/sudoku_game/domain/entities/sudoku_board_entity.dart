import 'dart:math';

import 'package:equatable/equatable.dart';

/// Full in-memory state of one Sudoku puzzle.
///
/// Holds the hidden [solution], the player-visible [values] (0 = empty) and
/// which cells were [given] from the start and cannot be edited.
class SudokuBoardEntity extends Equatable {
  const SudokuBoardEntity({
    required this.solution,
    required this.values,
    required this.given,
    required this.notes,
  });

  /// Generates a fresh puzzle with a unique solution and roughly
  /// [givensCount] pre-filled cells.
  ///
  /// A random solved grid is dug out cell by cell; each removal is kept
  /// only while a solver confirms exactly one solution remains, so the
  /// puzzle can never be completed in a way that disagrees with
  /// [solution]. Digging stops at [givensCount] givens, or earlier if no
  /// further cell can be removed without losing uniqueness.
  factory SudokuBoardEntity.generate({
    int givensCount = _defaultGivensCount,
    Random? random,
  }) {
    final rng = random ?? Random();
    final solution = _randomSolution(rng);
    final values = [...solution];

    final order = List.generate(cellCount, (i) => i)..shuffle(rng);
    var givens = cellCount;
    for (final index in order) {
      if (givens <= givensCount) break;

      final removed = values[index];
      values[index] = empty;
      if (_countSolutions(values, limit: 2) == 1) {
        givens--;
      } else {
        values[index] = removed;
      }
    }

    return SudokuBoardEntity(
      solution: solution,
      values: values,
      given: [
        for (var i = 0; i < cellCount; i++) values[i] != empty,
      ],
      notes: [for (var i = 0; i < cellCount; i++) const <int>{}],
    );
  }

  /// Restores a board previously serialized with [toJson].
  factory SudokuBoardEntity.fromJson(Map<String, dynamic> json) {
    return SudokuBoardEntity(
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
  factory SudokuBoardEntity.placeholder() {
    return SudokuBoardEntity(
      solution: [for (var i = 0; i < cellCount; i++) -1],
      values: [for (var i = 0; i < cellCount; i++) empty],
      given: [for (var i = 0; i < cellCount; i++) true],
      notes: [for (var i = 0; i < cellCount; i++) const <int>{}],
    );
  }

  static const size = 9;
  static const boxSize = 3;
  static const int cellCount = size * size;
  static const empty = 0;
  static const _defaultGivensCount = 36;

  /// The completed grid the player is working towards.
  final List<int> solution;

  /// Current cell values in row-major order; [empty] for blank cells.
  final List<int> values;

  /// Whether each cell was pre-filled and is locked.
  final List<bool> given;

  /// Pencil-marked candidates per cell (1..9); empty when none.
  final List<Set<int>> notes;

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
  static List<List<int>> unitsOf(int index) {
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
  /// Placing (or erasing) a value clears that cell's pencil marks, and a
  /// placed digit is also erased from the notes of every peer cell in the
  /// same row, column and box — those candidates are no longer possible.
  SudokuBoardEntity withValue(int index, int value) {
    if (given[index]) return this;

    final newNotes = [
      for (final cellNotes in notes) {...cellNotes},
    ];
    newNotes[index] = <int>{};
    if (value != empty) {
      for (final unit in unitsOf(index)) {
        for (final peer in unit) {
          newNotes[peer].remove(value);
        }
      }
    }

    return SudokuBoardEntity(
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
      solution: solution,
      values: values,
      given: given,
      notes: newNotes,
    );
  }

  /// Random solved grid: the canonical pattern
  /// value(r, c) = (r * 3 + r ~/ 3 + c) % 9 + 1, randomized by relabeling
  /// digits and shuffling rows/columns within their bands.
  static List<int> _randomSolution(Random rng) {
    final digits = List.generate(size, (i) => i + 1)..shuffle(rng);
    final rows = _shuffledBandOrder(rng);
    final cols = _shuffledBandOrder(rng);

    return List<int>.generate(cellCount, (index) {
      final r = rows[index ~/ size];
      final c = cols[index % size];
      return digits[(r * 3 + r ~/ 3 + c) % size];
    });
  }

  /// Shuffled row (or column) order that keeps each 3-line band intact:
  /// bands are reordered, and lines are reordered within their band.
  static List<int> _shuffledBandOrder(Random rng) {
    final bands = [0, 1, 2]..shuffle(rng);
    return [
      for (final band in bands)
        ...([0, 1, 2]..shuffle(rng)).map((line) => band * boxSize + line),
    ];
  }

  /// Counts solutions of [grid] by backtracking, stopping at [limit].
  static int _countSolutions(List<int> grid, {required int limit}) {
    final firstEmpty = grid.indexOf(empty);
    if (firstEmpty == -1) return 1;

    var found = 0;
    for (var digit = 1; digit <= size; digit++) {
      if (!_canPlace(grid, firstEmpty, digit)) continue;

      grid[firstEmpty] = digit;
      found += _countSolutions(grid, limit: limit - found);
      grid[firstEmpty] = empty;

      if (found >= limit) break;
    }
    return found;
  }

  /// Whether [digit] at [index] breaks no row, column or box constraint.
  static bool _canPlace(List<int> grid, int index, int digit) {
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
    'solution': solution,
    'values': values,
    'given': given,
    'notes': [
      for (final cellNotes in notes) [...cellNotes],
    ],
  };

  @override
  List<Object?> get props => [solution, values, given, notes];
}
