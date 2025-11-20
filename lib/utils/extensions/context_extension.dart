import 'package:boardify/localizations/l10n/app_localizations.dart';
import 'package:boardify/localizations/localized_string.dart';
import 'package:boardify/app_ui/theme/app_theme_provider.dart';
import 'package:flutter/material.dart';

extension ContextExtension on BuildContext {
  AppThemeData get appTheme {
    final result = AppThemeProvider.of(this);
    return result;
  }

  AppLocalizations get l10n => AppLocalizations.of(this);

  Locale get locale => l10n.locale;
}
