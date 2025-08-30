import 'package:boardify/core/ui_kit/theme/colors/app_colors.dart';
import 'package:boardify/core/ui_kit/theme/text_styles/app_text_styles.dart';
import 'package:flutter/material.dart';

class AppThemeDataBuilder {

  AppThemeDataBuilder({required this.colors, required this.textStyles});
  final AppColors colors;
  final AppTextStyles textStyles;

  ThemeData build() {
    final colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: colors.primary,
      onPrimary: colors.onPrimary,
      secondary: colors.secondary,
      onSecondary: colors.onSecondary,
      surface: colors.surface,
      onSurface: colors.onSurface,
      error: colors.error,
      onError: colors.onError,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colors.background,
      appBarTheme: AppBarTheme(
        backgroundColor: colors.surface,
        foregroundColor: colors.onSurface,
        elevation: 0,
      ),
      textTheme: TextTheme(
        displayLarge: textStyles.displayLarge,
        displayMedium: textStyles.displayMedium,
        displaySmall: textStyles.displaySmall,
        headlineLarge: textStyles.headlineLarge,
        headlineMedium: textStyles.headlineMedium,
        headlineSmall: textStyles.headlineSmall,
        titleLarge: textStyles.titleLarge,
        titleMedium: textStyles.titleMedium,
        titleSmall: textStyles.titleSmall,
        bodyLarge: textStyles.bodyLarge,
        bodyMedium: textStyles.bodyMedium,
        bodySmall: textStyles.bodySmall,
        labelLarge: textStyles.labelLarge,
        labelMedium: textStyles.labelMedium,
        labelSmall: textStyles.labelSmall,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: colors.onPrimary,
          backgroundColor: colors.primary,
          textStyle: textStyles.titleMedium,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
