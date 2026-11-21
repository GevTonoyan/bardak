/// Why a room action failed.
class SeaBattleRoomException implements Exception {
  const SeaBattleRoomException(this.reason, {this.cause});

  final SeaBattleRoomFailure reason;

  /// The error underneath, kept for logging.
  final Object? cause;

  @override
  String toString() => 'SeaBattleRoomException(${reason.name}, $cause)';
}

enum SeaBattleRoomFailure {
  /// No connection, or the server refused or could not be reached.
  connection,

  /// No room has this code, or it expired.
  notFound,

  /// Someone else joined first, or the game already started.
  full,
}
