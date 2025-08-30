import 'package:boardify/core/ui_kit/theme/colors/app_colors.dart';
import 'package:boardify/core/ui_kit/theme/text_styles/app_text_styles.dart';
import 'package:flutter/material.dart';

class AppThemeData {
  const AppThemeData({
    required this.colors,
    required this.typography,
    required this.themeData,
  });

  final AppColors colors;
  final AppTextStyles typography;
  final ThemeData themeData;
}

class AppThemeProvider extends InheritedWidget {
  const AppThemeProvider({required this.data, required super.child, super.key});

  final AppThemeData data;

  static AppThemeData of(BuildContext context) {
    final result =
        context.dependOnInheritedWidgetOfExactType<AppThemeProvider>();
    assert(result != null, 'No AppThemeProvider found in context');
    return result!.data;
  }

  @override
  bool updateShouldNotify(AppThemeProvider oldWidget) => data != oldWidget.data;
}
