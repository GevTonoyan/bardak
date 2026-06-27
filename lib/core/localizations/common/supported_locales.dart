import 'package:bardak/core/generated/assets/assets.gen.dart';
import 'package:bardak/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';

enum AppLocales {
  en,
  ru,
  am;

  Locale get locale => switch (this) {
    en => const Locale('en'),
    ru => const Locale('ru'),
    am => const Locale('am'),
  };

  static AppLocales fromString(String? locale) {
    switch (locale) {
      case 'en':
        return AppLocales.en;
      case 'ru':
        return AppLocales.ru;
      case 'am':
        return AppLocales.am;
      default:
        return AppLocales.en;
    }
  }

  String jsonValue() {
    switch (this) {
      case AppLocales.en:
        return 'en';
      case AppLocales.ru:
        return 'ru';
      case AppLocales.am:
        return 'am';
    }
  }

  static List<Locale> get supportedLocales {
    return AppLocales.values.map((locale) => locale.locale).toList();
  }

  String name(BuildContext context) {
    final l10n = context.l10n;
    return switch (this) {
      en => l10n.settings_localeEnglish,
      ru => l10n.settings_localeRussian,
      am => l10n.settings_localeArmenian,
    };
  }

  String get flagAssetPath => switch (this) {
    en => Assets.icons.flags.uk.path,
    ru => Assets.icons.flags.ru.path,
    am => Assets.icons.flags.am.path,
  };
}
