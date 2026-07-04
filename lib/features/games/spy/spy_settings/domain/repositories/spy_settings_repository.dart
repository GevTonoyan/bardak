import 'package:bardak/features/games/spy/spy_settings/domain/entities/spy_settings_entity.dart';

/// Contract for reading and persisting the Spy game settings.
abstract interface class SpySettingsRepository {
  /// Retrieves the currently stored spy settings.
  SpySettingsEntity getSpySettings();

  /// Persists the number of players.
  Future<bool> updatePlayerCount(int playerCount);

  /// Persists the number of spies.
  Future<bool> updateSpyCount(int spyCount);

  /// Persists the round duration in seconds.
  Future<bool> updateRoundDuration(int roundDuration);
}
