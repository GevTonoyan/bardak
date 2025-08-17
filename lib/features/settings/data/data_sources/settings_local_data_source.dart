import 'package:boardify/alias_constants.dart';
import 'package:boardify/core/constants.dart';
import 'package:boardify/features/settings/domain/entities/app_settings_entity.dart';
import 'package:boardify/features/settings/domain/entities/game_settings_entity.dart';
import 'package:boardify/features/settings/domain/usecases/update_app_settings_usecase.dart';
import 'package:boardify/features/settings/domain/usecases/update_game_settings_usecase.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// This is the data source for the alias settings.
/// It uses shared preferences to store and retrieve the settings.
abstract interface class SettingsLocalDataSource {
  AppSettingsEntity getAppSettings();

  /// Updates a setting with the given [key] and [value].
  Future<bool> updateAppSettings(UpdateAppSettingsParams params);

  /// Retrieves the alias settings from shared preferences.
  GameSettingsEntity getAliasSettings();

  /// Updates a specific alias setting in shared preferences.
  /// The [params] parameter contains the key and value to update.
  /// Returns true if the update was successful, false otherwise.
  Future<bool> updateAliasSetting(UpdateGameSettingsParams params);
}

/// Implementation of the [SettingsLocalDataSource] interface.
class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  final SharedPreferences preferences;

  const SettingsLocalDataSourceImpl({required this.preferences});

  @override
  AppSettingsEntity getAppSettings() {
    final darkMode = preferences.getBool(AppConstants.appThemeKey) ?? false;
    final locale = preferences.getString(AppConstants.appLocaleKey);

    return AppSettingsEntity.fromPreferences(
      isDarkMode: darkMode,
      locale: locale,
    );
  }

  @override
  Future<bool> updateAppSettings(UpdateAppSettingsParams params) async {
    late final bool success;

    switch (params.key) {
      case AppConstants.appThemeKey:
        success = await preferences.setBool(params.key, params.value as bool);
      case AppConstants.appLocaleKey:
        success = await preferences.setString(
          params.key,
          params.value as String,
        );
      default:
        success = false;
    }

    return success;
  }

  @override
  GameSettingsEntity getAliasSettings() {
    final gameDuration = preferences.getInt(AliasConstants.roundDurationKey);

    final pointsToWin = preferences.getInt(AliasConstants.pointsToWinKey);

    final isSoundEnabled = preferences.getBool(AliasConstants.soundEnabledKey);

    final allowSkipping = preferences.getBool(AliasConstants.allowSkippingKey);

    final penaltyForSkipping = preferences.getBool(
      AliasConstants.penaltyForSkippingKey,
    );

    final wordsPerCard = preferences.getInt(AliasConstants.wordsPerCardKey);

    return GameSettingsEntity.fromPreferences(
      roundDuration: gameDuration,
      pointsToWin: pointsToWin,
      soundEnabled: isSoundEnabled,
      allowSkipping: allowSkipping,
      penaltyForSkipping: penaltyForSkipping,
      wordsPerCard: wordsPerCard,
    );
  }

  @override
  Future<bool> updateAliasSetting(UpdateGameSettingsParams params) async {
    final key = params.key;
    final value = params.value;

    late final bool success;

    switch (key) {
      case AliasConstants.roundDurationKey:
        success = await preferences.setInt(key, value as int);
      case AliasConstants.pointsToWinKey:
        success = await preferences.setInt(key, value as int);
      case AliasConstants.soundEnabledKey:
        success = await preferences.setBool(key, value as bool);
      case AliasConstants.allowSkippingKey:
        success = await preferences.setBool(key, value as bool);
      case AliasConstants.penaltyForSkippingKey:
        success = await preferences.setBool(key, value as bool);
      case AliasConstants.wordsPerCardKey:
        success = await preferences.setInt(key, value as int);
      default:
        success = false;
    }

    return success;
  }
}
