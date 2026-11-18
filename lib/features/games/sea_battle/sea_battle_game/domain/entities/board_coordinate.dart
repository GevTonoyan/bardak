import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/sea_battle_rules.dart';
import 'package:equatable/equatable.dart';

/// A single cell on the Sea Battle board, zero-based from the top-left.
class BoardCoordinate extends Equatable {
  const BoardCoordinate(this.row, this.column);

  final int row;
  final int column;

  /// Whether this cell lies on the board.
  bool get isOnBoard =>
      row >= 0 &&
      row < SeaBattleRules.boardSize &&
      column >= 0 &&
      column < SeaBattleRules.boardSize;

  /// This cell shifted by [rows] and [columns].
  BoardCoordinate shift({int rows = 0, int columns = 0}) =>
      BoardCoordinate(row + rows, column + columns);

  @override
  List<Object?> get props => [row, column];
}
