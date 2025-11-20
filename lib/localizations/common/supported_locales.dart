import 'package:boardify/utils/extensions/context_extension.dart';
import 'package:flutter/material.dart';

enum AppLocales {
  en,
  ru,
  am;

  Locale get locale {
    switch (this) {
      case AppLocales.en:
        return const Locale('en');
      case AppLocales.ru:
        return const Locale('ru');
      case AppLocales.am:
        return const Locale('am');
    }
  }

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
    switch (this) {
      case AppLocales.en:
        return context.l10n.settings_localeEnglish;
      case AppLocales.ru:
        return context.l10n.settings_localeRussian;
      case AppLocales.am:
        return context.l10n.settings_localeArmenian;
    }
  }

  String get flagAssetPath {
    switch (this) {
      case AppLocales.en:
        return 'assets/icons/flags/uk.svg';
      case AppLocales.ru:
        return 'assets/icons/flags/ru.svg';
      case AppLocales.am:
        return 'assets/icons/flags/am.svg';
    }
  }
}
