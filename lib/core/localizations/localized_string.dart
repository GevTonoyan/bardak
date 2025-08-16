import 'package:boardify/core/localizations/global_app_localizations.dart';
import 'package:boardify/core/localizations/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

typedef LocalizedString = String Function(AppLocalizations localizations);

final AppLocalizations appL10n = GlobalAppLocalizations.appLocalizations;

extension AppLocalizationsExtension on AppLocalizations {
  Locale get locale => Locale.fromSubtags(languageCode: localeName);
}
