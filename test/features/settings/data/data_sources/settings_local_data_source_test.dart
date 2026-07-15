import 'package:bardak/core/app_ui/theme/colors/app_color_scheme.dart';
import 'package:bardak/core/localizations/app_locale.dart';
import 'package:bardak/features/settings/data/data_sources/settings_local_data_source.dart';
import 'package:bardak/features/settings/domain/entities/app_settings_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late SettingsLocalDataSourceImpl dataSource;

  setUp(() async {
    SharedPreferences.setMockInitialValues(const {});
    dataSource = SettingsLocalDataSourceImpl(
      preferences: await SharedPreferences.getInstance(),
    );
  });

  test('returns the defaults when nothing is stored', () {
    expect(dataSource.getAppSettings(), AppSettingsEntity.defaultSettings());
  });

  test('updates round-trip through getAppSettings', () async {
    await dataSource.updateLocale(AppLocale.am);
    await dataSource.updateColorScheme(AppColorScheme.purple);
    await dataSource.updateSoundEnabled(soundEnabled: false);

    final settings = dataSource.getAppSettings();
    expect(settings.locale, AppLocale.am);
    expect(settings.colorScheme, AppColorScheme.purple);
    expect(settings.soundEnabled, isFalse);
  });
}
