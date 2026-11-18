/// The fixed Sea Battle rules shared by every mode.
///
/// Ships may never touch (not even diagonally), a hit earns another shot,
/// and cells around a sunk ship are marked automatically.
abstract final class SeaBattleRules {
  /// Cells along one side of the square board.
  static const boardSize = 10;

  /// Length of every ship in the fleet, largest first. A ship's index in
  /// this list is its id.
  static const fleetShipLengths = [4, 3, 3, 2, 2, 2, 1, 1, 1, 1];

  /// Number of ships in a full fleet.
  static int get fleetSize => fleetShipLengths.length;
}
