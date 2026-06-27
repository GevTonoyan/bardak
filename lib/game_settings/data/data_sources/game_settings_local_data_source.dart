import 'package:bardak/game_settings/domain/entities/game_settings_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Persists the Alias game settings in [SharedPreferences].
abstract interface class GameSettingsLocalDataSource {
  /// Retrieves the game settings from shared preferences.
  GameSettingsEntity getGameSettings();

  Future<bool> updateRoundDuration(int roundDuration);

  Future<bool> updatePointsToWin(int pointsToWin);

  Future<bool> updateAllowSkipping({required bool allowSkipping});
}

class GameSettingsLocalDataSourceImpl implements GameSettingsLocalDataSource {
  const GameSettingsLocalDataSourceImpl({required this.preferences});

  static const _roundDurationKey = 'round_duration';
  static const _pointsToWinKey = 'points_to_win';
  static const _allowSkippingKey = 'allow_skipping';
  static const _wordsPerCardKey = 'words_per_card';

  final SharedPreferences preferences;

  @override
  GameSettingsEntity getGameSettings() {
    final roundDuration = preferences.getInt(_roundDurationKey);
    final pointsToWin = preferences.getInt(_pointsToWinKey);
    final allowSkipping = preferences.getBool(_allowSkippingKey);
    final wordsPerCard = preferences.getInt(_wordsPerCardKey);

    return GameSettingsEntity.fromPreferences(
      roundDuration: roundDuration,
      pointsToWin: pointsToWin,
      allowSkipping: allowSkipping,
      wordsPerCard: wordsPerCard,
    );
  }

  @override
  Future<bool> updateRoundDuration(int roundDuration) {
    return preferences.setInt(_roundDurationKey, roundDuration);
  }

  @override
  Future<bool> updatePointsToWin(int pointsToWin) {
    return preferences.setInt(_pointsToWinKey, pointsToWin);
  }

  @override
  Future<bool> updateAllowSkipping({required bool allowSkipping}) {
    return preferences.setBool(_allowSkippingKey, allowSkipping);
  }
}
