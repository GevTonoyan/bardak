import 'package:bardak/core/extensions/context_extension.dart';
import 'package:bardak/core/generated/assets/assets.gen.dart';
import 'package:flutter/material.dart';

enum AppLocale {
  en,
  ru,
  am;

  Locale get locale => Locale(name);

  /// Localized display name, e.g. "English".
  String displayName(BuildContext context) {
    final l10n = context.l10n;
    return switch (this) {
      en => l10n.settings_localeEnglish,
      ru => l10n.settings_localeRussian,
      am => l10n.settings_localeArmenian,
    };
  }

  /// Flag icon asset for this locale.
  SvgGenImage get flag => switch (this) {
    en => Assets.icons.flags.uk,
    ru => Assets.icons.flags.ru,
    am => Assets.icons.flags.am,
  };

  static AppLocale fromString(String? code) =>
      AppLocale.values.firstWhere((l) => l.name == code, orElse: () => en);

  static List<Locale> get supportedLocales =>
      AppLocale.values.map((l) => l.locale).toList();
}
