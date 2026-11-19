import 'package:equatable/equatable.dart';

/// A single cell on the Sea Battle board, zero-based from the top-left.
class BoardCoordinate extends Equatable {
  const BoardCoordinate(this.row, this.column);

  /// Cells along one side of the square board.
  static const boardSize = 10;

  final int row;
  final int column;

  /// Whether this cell lies on the board.
  bool get isOnBoard =>
      row >= 0 && row < boardSize && column >= 0 && column < boardSize;

  /// This cell shifted by [rows] and [columns].
  BoardCoordinate shift({int rows = 0, int columns = 0}) =>
      BoardCoordinate(row + rows, column + columns);

  @override
  List<Object?> get props => [row, column];
}
