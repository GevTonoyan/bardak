import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/board_coordinate.dart';
import 'package:equatable/equatable.dart';

/// A ship placed on the board.
///
/// [origin] is its top-left cell; the ship extends [length] cells to the
/// right or downwards, depending on [orientation].
class ShipEntity extends Equatable {
  const ShipEntity({
    required this.id,
    required this.length,
    required this.origin,
    this.orientation = ShipOrientation.horizontal,
  });

  /// Index of this ship in the fleet; stable while it is moved or rotated.
  final int id;
  final int length;
  final BoardCoordinate origin;
  final ShipOrientation orientation;

  /// The cells the ship occupies.
  List<BoardCoordinate> get cells => [
    for (var i = 0; i < length; i++)
      switch (orientation) {
        ShipOrientation.horizontal => origin.shift(columns: i),
        ShipOrientation.vertical => origin.shift(rows: i),
      },
  ];

  /// Whether every cell of the ship lies on the board.
  bool get isOnBoard => cells.every((cell) => cell.isOnBoard);

  /// The ship's cells plus every cell touching them (diagonals included),
  /// limited to the board. No other ship may enter this area.
  Set<BoardCoordinate> get area => {
    for (final cell in cells)
      for (var rows = -1; rows <= 1; rows++)
        for (var columns = -1; columns <= 1; columns++)
          cell.shift(rows: rows, columns: columns),
  }.where((cell) => cell.isOnBoard).toSet();

  /// The cells around the ship (its [area] without the ship itself).
  Set<BoardCoordinate> get surroundingCells => area.difference(cells.toSet());

  /// The ship turned to the other orientation, in every position that
  /// still crosses one of its cells, most natural first: pivoting on its
  /// first cell (down or right of it, then up or left of it, then centred
  /// on it), then on each next cell the same way. The first one that fits
  /// is the one to use.
  List<ShipEntity> get rotations {
    final orientation = this.orientation.rotated;
    final offsets = [
      0,
      if (length > 1) length - 1,
      for (var k = 1; k < length - 1; k++) k,
    ];
    return {
      for (final pivot in cells)
        for (final offset in offsets)
          copyWith(
            orientation: orientation,
            origin: switch (orientation) {
              ShipOrientation.horizontal => pivot.shift(columns: -offset),
              ShipOrientation.vertical => pivot.shift(rows: -offset),
            },
          ),
    }.toList();
  }

  /// Whether the ship occupies [cell].
  bool occupies(BoardCoordinate cell) => cells.contains(cell);

  ShipEntity copyWith({BoardCoordinate? origin, ShipOrientation? orientation}) {
    return ShipEntity(
      id: id,
      length: length,
      origin: origin ?? this.origin,
      orientation: orientation ?? this.orientation,
    );
  }

  @override
  List<Object?> get props => [id, length, origin, orientation];
}

/// The direction a ship extends from its origin cell.
enum ShipOrientation {
  /// Extends to the right.
  horizontal,

  /// Extends downwards.
  vertical;

  /// The other orientation.
  ShipOrientation get rotated => switch (this) {
    horizontal => vertical,
    vertical => horizontal,
  };
}
