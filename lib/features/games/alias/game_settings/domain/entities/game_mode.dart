/// The Alias game modes: classic multi-word cards vs. single-word rounds.
///
/// Part of the persisted game settings so the last-played mode is remembered.
enum GameMode {
  card,
  singleWord;

  /// Parses a persisted [GameMode] name, defaulting to [GameMode.card].
  static GameMode fromString(String? value) => values.firstWhere(
    (mode) => mode.name == value,
    orElse: () => card,
  );
}
