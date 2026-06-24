import 'package:bardak/game_settings/domain/entities/game_settings_entity.dart';
import 'package:bardak/game_settings/domain/usecases/update_game_settings_usecase.dart';
import 'package:bardak/utils/constants/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Persists the Alias game settings in [SharedPreferences].
///
/// Uses the same preference keys as the legacy settings feature so existing
/// user data carries over without migration.
abstract interface class GameSettingsLocalDataSource {
  /// Retrieves the game settings from shared preferences.
  GameSettingsEntity getGameSettings();

  /// Updates a single game setting. Returns true if the write succeeded.
  Future<bool> updateGameSettings(UpdateGameSettingsParams params);
}

class GameSettingsLocalDataSourceImpl implements GameSettingsLocalDataSource {
  const GameSettingsLocalDataSourceImpl({required this.preferences});

  final SharedPreferences preferences;

  @override
  GameSettingsEntity getGameSettings() {
    final roundDuration = preferences.getInt(AppConstants.roundDurationKey);
    final pointsToWin = preferences.getInt(AppConstants.pointsToWinKey);
    final allowSkipping = preferences.getBool(AppConstants.allowSkippingKey);
    final penaltyForSkipping = preferences.getBool(
      AppConstants.penaltyForSkippingKey,
    );
    final wordsPerCard = preferences.getInt(AppConstants.wordsPerCardKey);

    return GameSettingsEntity.fromPreferences(
      roundDuration: roundDuration,
      pointsToWin: pointsToWin,
      allowSkipping: allowSkipping,
      penaltyForSkipping: penaltyForSkipping,
      wordsPerCard: wordsPerCard,
    );
  }

  @override
  Future<bool> updateGameSettings(UpdateGameSettingsParams params) async {
    final key = params.key;
    final value = params.value;

    late final bool success;

    switch (key) {
      case AppConstants.roundDurationKey:
        success = await preferences.setInt(key, value as int);
      case AppConstants.pointsToWinKey:
        success = await preferences.setInt(key, value as int);
      case AppConstants.allowSkippingKey:
        success = await preferences.setBool(key, value as bool);
      default:
        success = false;
    }

    return success;
  }
}
