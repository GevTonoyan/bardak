import 'package:bardak/core/app_ui/theme/colors/app_color_scheme.dart';
import 'package:bardak/core/localizations/app_locale.dart';
import 'package:bardak/features/settings/domain/entities/app_settings_entity.dart';

/// This is the interface for the [SettingsRepository].
abstract interface class SettingsRepository {
  /// Gets the app settings.
  AppSettingsEntity getAppSettings();

  /// Persists the selected app locale.
  Future<bool> updateLocale(AppLocale locale);

  /// Persists the selected color scheme.
  Future<bool> updateColorScheme(AppColorScheme colorScheme);

  /// Persists whether sound effects are enabled.
  Future<bool> updateSoundEnabled({required bool soundEnabled});
}
