import 'package:bardak/app_ui/theme/app_color_scheme.dart';
import 'package:bardak/localizations/common/supported_locales.dart';
import 'package:bardak/settings/data/data_sources/settings_local_data_source.dart';
import 'package:bardak/settings/domain/entities/app_settings_entity.dart';
import 'package:bardak/settings/domain/repositories/settings_repository.dart';

/// This is the implementation of the [SettingsRepository] interface.
class SettingsRepositoryImpl implements SettingsRepository {
  const SettingsRepositoryImpl({required this.dataSource});

  final SettingsLocalDataSource dataSource;

  @override
  AppSettingsEntity getAppSettings() => dataSource.getAppSettings();

  @override
  Future<bool> updateLocale(AppLocales locale) =>
      dataSource.updateLocale(locale);

  @override
  Future<bool> updateColorScheme(AppColorScheme colorScheme) =>
      dataSource.updateColorScheme(colorScheme);

  @override
  Future<bool> updateSoundEnabled({required bool soundEnabled}) =>
      dataSource.updateSoundEnabled(soundEnabled: soundEnabled);
}
