import 'package:bardak/core/app_ui/theme/app_theme_provider.dart';
import 'package:bardak/core/app_ui/theme/colors/app_colors.dart';
import 'package:bardak/core/app_ui/theme/text_styles/app_text_styles.dart';
import 'package:bardak/core/localizations/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

extension ContextExtension on BuildContext {
  AppThemeData get appTheme {
    final result = AppThemeProvider.of(this);
    return result;
  }

  AppColors get colors => appTheme.colors;

  AppTextStyles get typography => appTheme.typography;

  AppLocalizations get l10n => AppLocalizations.of(this);

  Locale get locale => Locale.fromSubtags(languageCode: l10n.localeName);
}
