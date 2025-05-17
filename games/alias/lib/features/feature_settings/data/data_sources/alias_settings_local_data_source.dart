import 'package:alias/core/alias_constants.dart';
import 'package:alias/features/feature_settings/domain/entities/alias_settings_entity.dart';
import 'package:alias/features/feature_settings/domain/usecases/update_alias_setting_usecase.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// This is the data source for the alias settings.
/// It uses shared preferences to store and retrieve the settings.
abstract interface class AliasSettingsLocalDataSource {
  /// Retrieves the alias settings from shared preferences.
  Future<AliasSettingsEntity> getAliasSettings();

  /// Updates a specific alias setting in shared preferences.
  /// The [params] parameter contains the key and value to update.
  /// Returns true if the update was successful, false otherwise.
  Future<bool> updateAliasSetting(UpdateAliasSettingParams params);
}

/// Implementation of the [AliasSettingsLocalDataSource] interface.
class AliasSettingsLocalDataSourceImpl implements AliasSettingsLocalDataSource {
  final SharedPreferences preferences;

  const AliasSettingsLocalDataSourceImpl({required this.preferences});

  @override
  Future<AliasSettingsEntity> getAliasSettings() async {
    final gameDuration = preferences.getInt(AliasConstants.roundDurationKey);

    final pointsToWin = preferences.getInt(AliasConstants.pointsToWinKey);

    final isSoundEnabled = preferences.getBool(AliasConstants.isSoundEnabledKey);

    final allowSkipping = preferences.getBool(AliasConstants.allowSkippingKey);

    final penaltyForSkipping = preferences.getBool(AliasConstants.penaltyForSkippingKey);

    final wordsPerCard = preferences.getInt(AliasConstants.wordsPerCardKey);

    return AliasSettingsEntity.fromPreferences(
      roundDuration: gameDuration,
      pointsToWin: pointsToWin,
      soundEnabled: isSoundEnabled,
      allowSkipping: allowSkipping,
      penaltyForSkipping: penaltyForSkipping,
      wordsPerCard: wordsPerCard,
    );
  }

  @override
  Future<bool> updateAliasSetting(UpdateAliasSettingParams params) async {
    final key = params.key;
    final value = params.value;

    late final bool success;

    switch (key) {
      case AliasConstants.roundDurationKey:
        success = await preferences.setInt(key, value as int);
      case AliasConstants.pointsToWinKey:
        success = await preferences.setInt(key, value as int);
      case AliasConstants.isSoundEnabledKey:
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
