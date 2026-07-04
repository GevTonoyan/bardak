import 'package:bardak/features/games/alias/game_settings/domain/entities/game_mode.dart';
import 'package:bardak/features/games/alias/game_settings/domain/entities/game_settings_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Persists the Alias game settings in [SharedPreferences].
abstract interface class GameSettingsLocalDataSource {
  /// Retrieves the game settings from shared preferences.
  GameSettingsEntity getGameSettings();

  Future<bool> updateGameMode(GameMode gameMode);

  Future<bool> updateRoundDuration(int roundDuration);

  Future<bool> updatePointsToWin(int pointsToWin);

  Future<bool> updateAllowSkipping({required bool allowSkipping});
}

class GameSettingsLocalDataSourceImpl implements GameSettingsLocalDataSource {
  const GameSettingsLocalDataSourceImpl({required this._preferences});

  static const _gameModeKey = 'game_mode';
  static const _roundDurationKey = 'round_duration';
  static const _pointsToWinKey = 'points_to_win';
  static const _allowSkippingKey = 'allow_skipping';
  static const _wordsPerCardKey = 'words_per_card';

  final SharedPreferences _preferences;

  @override
  GameSettingsEntity getGameSettings() {
    final gameMode = _preferences.getString(_gameModeKey);
    final roundDuration = _preferences.getInt(_roundDurationKey);
    final pointsToWin = _preferences.getInt(_pointsToWinKey);
    final allowSkipping = _preferences.getBool(_allowSkippingKey);
    final wordsPerCard = _preferences.getInt(_wordsPerCardKey);

    return const GameSettingsEntity().copyWith(
      gameMode: GameMode.fromString(gameMode),
      roundDuration: roundDuration,
      pointsToWin: pointsToWin,
      allowSkipping: allowSkipping,
      wordsPerCard: wordsPerCard,
    );
  }

  @override
  Future<bool> updateGameMode(GameMode gameMode) {
    return _preferences.setString(_gameModeKey, gameMode.name);
  }

  @override
  Future<bool> updateRoundDuration(int roundDuration) {
    return _preferences.setInt(_roundDurationKey, roundDuration);
  }

  @override
  Future<bool> updatePointsToWin(int pointsToWin) {
    return _preferences.setInt(_pointsToWinKey, pointsToWin);
  }

  @override
  Future<bool> updateAllowSkipping({required bool allowSkipping}) {
    return _preferences.setBool(_allowSkippingKey, allowSkipping);
  }
}
