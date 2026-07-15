import 'package:bardak/core/app_ui/theme/colors/app_color_scheme.dart';
import 'package:bardak/core/localizations/app_locale.dart';
import 'package:bardak/features/settings/domain/entities/app_settings_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppSettingsEntity.defaultSettings', () {
    test('is English, main scheme, sound on', () {
      final settings = AppSettingsEntity.defaultSettings();

      expect(settings.locale, AppLocale.en);
      expect(settings.colorScheme, AppColorScheme.main);
      expect(settings.soundEnabled, isTrue);
    });
  });

  group('copyWith', () {
    test('replaces only the given fields', () {
      final settings = AppSettingsEntity.defaultSettings();

      final updated = settings.copyWith(soundEnabled: false);

      expect(updated.soundEnabled, isFalse);
      expect(updated.locale, settings.locale);
      expect(updated.colorScheme, settings.colorScheme);
    });
  });

  group('AppLocale.fromString', () {
    test('parses supported codes', () {
      expect(AppLocale.fromString('en'), AppLocale.en);
      expect(AppLocale.fromString('ru'), AppLocale.ru);
      expect(AppLocale.fromString('am'), AppLocale.am);
    });

    test('defaults to English for null or unknown codes', () {
      expect(AppLocale.fromString(null), AppLocale.en);
      expect(AppLocale.fromString('fr'), AppLocale.en);
    });
  });

  group('AppLocale.supportedLocales', () {
    test('exposes every enum value as a Locale', () {
      expect(
        AppLocale.supportedLocales.map((l) => l.languageCode),
        ['en', 'ru', 'am'],
      );
    });
  });
}
