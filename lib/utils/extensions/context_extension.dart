import 'package:alias_pro/app_ui/theme/app_theme_provider.dart';
import 'package:alias_pro/app_ui/theme/colors/app_colors.dart';
import 'package:alias_pro/app_ui/theme/text_styles/app_text_styles.dart';
import 'package:alias_pro/localizations/l10n/app_localizations.dart';
import 'package:alias_pro/localizations/localized_string.dart';
import 'package:flutter/material.dart';

extension ContextExtension on BuildContext {
  AppThemeData get appTheme {
    final result = AppThemeProvider.of(this);
    return result;
  }

  AppColors get colors => appTheme.colors;

  AppTextStyles get typography => appTheme.typography;

  AppLocalizations get l10n => AppLocalizations.of(this);

  Locale get locale => l10n.locale;
}
