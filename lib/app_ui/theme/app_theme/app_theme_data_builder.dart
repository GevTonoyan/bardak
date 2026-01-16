import 'package:boardify/app_ui/theme/colors/app_colors.dart';
import 'package:boardify/app_ui/theme/text_styles/app_text_styles.dart';
import 'package:flutter/material.dart';

class AppThemeDataBuilder {
  AppThemeDataBuilder({required this.colors, required this.textStyles});

  final AppColors colors;
  final AppTextStyles textStyles;

  ThemeData build() {
    return ThemeData(
      useMaterial3: true,

      appBarTheme: const AppBarTheme(elevation: 0),
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
          textStyle: textStyles.titleMedium,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
