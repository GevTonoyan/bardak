import 'package:boardify/core/localizations/l10n/app_localizations.dart';
import 'package:boardify/core/localizations/localized_string.dart';
import 'package:boardify/core/ui_kit/theme/app_theme_provider.dart';
import 'package:flutter/cupertino.dart';

extension ContextExtension on BuildContext {
  AppThemeData get appTheme {
    final result = AppThemeProvider.of(this);
    return result;
  }

  AppLocalizations get l10n => AppLocalizations.of(this);

  Locale get locale => l10n.locale;
}
