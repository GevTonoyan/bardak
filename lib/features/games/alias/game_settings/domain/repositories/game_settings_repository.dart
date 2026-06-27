import 'package:bardak/features/games/alias/game_settings/domain/entities/game_settings_entity.dart';

/// Contract for reading and persisting the Alias game settings.
abstract interface class GameSettingsRepository {
  /// Retrieves the currently stored game settings.
  GameSettingsEntity getGameSettings();

  /// Persists the round duration in seconds.
  Future<bool> updateRoundDuration(int roundDuration);

  /// Persists the points required to win.
  Future<bool> updatePointsToWin(int pointsToWin);

  /// Persists whether skipping words is allowed.
  Future<bool> updateAllowSkipping({required bool allowSkipping});
}
