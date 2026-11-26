/// Why the battle with the opponent cannot go on.
class SeaBattleOpponentException implements Exception {
  const SeaBattleOpponentException(this.reason, {this.cause});

  final SeaBattleOpponentFailure reason;

  /// The error underneath, kept for logging.
  final Object? cause;

  @override
  String toString() => 'SeaBattleOpponentException(${reason.name}, $cause)';
}

enum SeaBattleOpponentFailure {
  /// The opponent left the battle, or has been gone too long to wait for.
  left,

  /// This player lost the connection, or the server refused a move.
  connection,
}
