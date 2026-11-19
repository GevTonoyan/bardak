/// What a shot did.
enum ShotResult {
  /// Only water; the turn passes to the other side.
  miss,

  /// Struck a ship that is still afloat; the shooter fires again.
  hit,

  /// Struck the last cell of a ship; the shooter fires again.
  sunk;

  /// Whether the shot struck a ship, so the shooter keeps the turn.
  bool get isHit => this != miss;
}
