/// How cleverly the bot picks its shots in the vs-bot mode.
///
/// Part of the persisted sea battle settings so the last choice is
/// remembered.
enum SeaBattleBotDifficulty {
  /// Fires at random cells.
  easy,

  /// Fires at random until it hits, then finishes off that ship.
  medium,

  /// Aims at the cells most likely to hold a ship.
  hard;

  /// Parses a persisted [SeaBattleBotDifficulty] name, defaulting to
  /// [medium].
  static SeaBattleBotDifficulty fromString(String? value) => values.firstWhere(
    (difficulty) => difficulty.name == value,
    orElse: () => medium,
  );
}
