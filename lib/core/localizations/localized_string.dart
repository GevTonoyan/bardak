import 'package:bardak/core/localizations/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

extension AppLocalizationsExtension on AppLocalizations {
  Locale get locale => Locale.fromSubtags(languageCode: localeName);
}
