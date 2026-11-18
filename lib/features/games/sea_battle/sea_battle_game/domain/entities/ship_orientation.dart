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
