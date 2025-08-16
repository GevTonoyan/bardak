import 'package:boardify/core/localizations/l10n/app_localizations.dart';
import 'package:boardify/core/localizations/l10n/app_localizations_en.dart';
import 'package:flutter/widgets.dart';

enum Locales {
  en(Locale('en')),
  ru(Locale('ru')),
  am(Locale('am'));

  const Locales(this.locale);

  final Locale locale;
}

final l10n = GlobalAppLocalizations.appLocalizations;

abstract class GlobalAppLocalizations {
  const GlobalAppLocalizations();

  static AppLocalizations appLocalizations = _defaultAppLocalizations;
  static List<Locale> supportedLocales = AppLocalizations.supportedLocales;

  static final _defaultAppLocalizations = AppLocalizationsEn();
  static final _defaultFallbackLocale = Locales.en.locale;

  /// Load locale without [BuildContext]
  static Future<void> _loadLocale(Locale? locale) async {
    final appLocalizations = await AppLocalizations.delegate.load(
      _setLocale(locale),
    );
    GlobalAppLocalizations.appLocalizations = appLocalizations;
  }

  /// Set [locale] or [_defaultFallbackLocale] if locale is null.
  static Locale _setLocale(Locale? locale) =>
      locale != null && AppLocalizations.supportedLocales.contains(locale)
          ? locale
          : _defaultFallbackLocale;

  static Locale localeResolutionCallback(
    Locale? locale,
    Iterable<Locale> supportedLocales,
  ) {
    _loadLocale(locale);
    return _setLocale(locale);
  }
}
