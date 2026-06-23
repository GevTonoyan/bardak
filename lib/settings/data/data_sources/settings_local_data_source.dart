import 'package:bardak/settings/domain/entities/app_settings_entity.dart';
import 'package:bardak/settings/domain/usecases/update_app_settings_usecase.dart';
import 'package:bardak/utils/constants/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// This is the data source for the app settings.
/// It uses shared preferences to store and retrieve the settings.
abstract interface class SettingsLocalDataSource {
  AppSettingsEntity getAppSettings();

  /// Updates a single app setting identified by its preference key.
  Future<bool> updateAppSettings(UpdateAppSettingsParams params);
}

/// Implementation of the [SettingsLocalDataSource] interface.
class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  const SettingsLocalDataSourceImpl({required this.preferences});

  final SharedPreferences preferences;

  @override
  AppSettingsEntity getAppSettings() {
    final locale = preferences.getString(AppConstants.appLocaleKey);
    final colorScheme = preferences.getString(AppConstants.appColorSchemeKey);
    final soundEnabled = preferences.getBool(AppConstants.soundEnabledKey);

    return AppSettingsEntity.fromPreferences(
      locale: locale,
      colorScheme: colorScheme,
      soundEnabled: soundEnabled,
    );
  }

  @override
  Future<bool> updateAppSettings(UpdateAppSettingsParams params) async {
    late final bool success;

    switch (params.key) {
      case AppConstants.appLocaleKey:
        success = await preferences.setString(
          params.key,
          params.value as String,
        );
      case AppConstants.appColorSchemeKey:
        success = await preferences.setString(
          params.key,
          params.value as String,
        );
      case AppConstants.soundEnabledKey:
        success = await preferences.setBool(params.key, params.value as bool);
      default:
        success = false;
    }

    return success;
  }
}
