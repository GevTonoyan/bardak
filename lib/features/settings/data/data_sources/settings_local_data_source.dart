import 'package:bardak/core/app_ui/theme/app_color_scheme.dart';
import 'package:bardak/core/localizations/common/supported_locales.dart';
import 'package:bardak/features/settings/domain/entities/app_settings_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// This is the data source for the app settings.
/// It uses shared preferences to store and retrieve the settings.
abstract interface class SettingsLocalDataSource {
  AppSettingsEntity getAppSettings();

  Future<bool> updateLocale(AppLocales locale);

  Future<bool> updateColorScheme(AppColorScheme colorScheme);

  Future<bool> updateSoundEnabled({required bool soundEnabled});
}

/// Implementation of the [SettingsLocalDataSource] interface.
class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  const SettingsLocalDataSourceImpl({required this.preferences});

  static const _localeKey = 'app_locale_key';
  static const _colorSchemeKey = 'app_color_scheme_key';
  static const _soundEnabledKey = 'is_sound_enabled';

  final SharedPreferences preferences;

  @override
  AppSettingsEntity getAppSettings() {
    final locale = preferences.getString(_localeKey);
    final colorScheme = preferences.getString(_colorSchemeKey);
    final soundEnabled = preferences.getBool(_soundEnabledKey);

    return AppSettingsEntity.fromPreferences(
      locale: locale,
      colorScheme: colorScheme,
      soundEnabled: soundEnabled,
    );
  }

  @override
  Future<bool> updateLocale(AppLocales locale) {
    return preferences.setString(_localeKey, locale.jsonValue());
  }

  @override
  Future<bool> updateColorScheme(AppColorScheme colorScheme) {
    return preferences.setString(_colorSchemeKey, colorScheme.name);
  }

  @override
  Future<bool> updateSoundEnabled({required bool soundEnabled}) {
    return preferences.setBool(_soundEnabledKey, soundEnabled);
  }
}
