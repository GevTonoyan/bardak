import 'package:flutter/material.dart';
import 'text_styles/app_text_styles.dart';
import 'colors/app_colors.dart';

class AppThemeData {
  final AppColors colors;
  final AppTextStyles typography;
  final ThemeData themeData;

  const AppThemeData({required this.colors, required this.typography, required this.themeData});
}

class AppThemeProvider extends InheritedWidget {
  final AppThemeData data;

  const AppThemeProvider({super.key, required this.data, required super.child});

  static AppThemeData of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<AppThemeProvider>();
    assert(result != null, 'No AppThemeProvider found in context');
    return result!.data;
  }

  @override
  bool updateShouldNotify(AppThemeProvider oldWidget) => data != oldWidget.data;
}
