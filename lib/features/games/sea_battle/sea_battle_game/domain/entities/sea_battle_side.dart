/// One of the two players in a battle.
enum SeaBattleSide {
  /// The person holding the phone.
  player,

  /// The bot, or the remote player online.
  opponent;

  /// The other side.
  SeaBattleSide get other => switch (this) {
    player => opponent,
    opponent => player,
  };
}
