import 'package:bardak/features/games/spy/spy_settings/domain/entities/spy_settings_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Persists the Spy game settings in [SharedPreferences].
abstract interface class SpySettingsLocalDataSource {
  /// Retrieves the spy settings from shared preferences.
  SpySettingsEntity getSpySettings();

  Future<bool> updatePlayerCount(int playerCount);

  Future<bool> updateSpyCount(int spyCount);

  Future<bool> updateRoundDuration(int roundDuration);
}

class SpySettingsLocalDataSourceImpl implements SpySettingsLocalDataSource {
  const SpySettingsLocalDataSourceImpl({required this._preferences});

  static const _playerCountKey = 'spy_player_count';
  static const _spyCountKey = 'spy_spy_count';
  static const _roundDurationKey = 'spy_round_duration';

  final SharedPreferences _preferences;

  @override
  SpySettingsEntity getSpySettings() {
    return const SpySettingsEntity().copyWith(
      playerCount: _preferences.getInt(_playerCountKey),
      spyCount: _preferences.getInt(_spyCountKey),
      roundDuration: _preferences.getInt(_roundDurationKey),
    );
  }

  @override
  Future<bool> updatePlayerCount(int playerCount) {
    return _preferences.setInt(_playerCountKey, playerCount);
  }

  @override
  Future<bool> updateSpyCount(int spyCount) {
    return _preferences.setInt(_spyCountKey, spyCount);
  }

  @override
  Future<bool> updateRoundDuration(int roundDuration) {
    return _preferences.setInt(_roundDurationKey, roundDuration);
  }
}
