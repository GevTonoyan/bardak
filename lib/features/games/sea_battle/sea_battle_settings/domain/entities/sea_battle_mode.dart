import 'package:bardak/features/games/sea_battle/sea_battle_settings/domain/entities/sea_battle_bot_difficulty.dart';

/// Who the player battles against in Sea Battle.
///
/// Part of the persisted sea battle settings so the last choice is
/// remembered.
enum SeaBattleMode {
  /// Single player against the computer.
  solo,

  /// Two players on separate devices, connected in real time.
  online;

  /// Whether this mode uses [SeaBattleBotDifficulty].
  bool get usesBotDifficulty => switch (this) {
    solo => true,
    online => false,
  };

  /// Parses a persisted [SeaBattleMode] name, defaulting to [solo].
  static SeaBattleMode fromString(String? value) => values.firstWhere(
    (mode) => mode.name == value,
    orElse: () => solo,
  );
}
