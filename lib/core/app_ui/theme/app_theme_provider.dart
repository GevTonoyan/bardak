import 'package:bardak/core/app_ui/theme/colors/app_colors.dart';
import 'package:bardak/core/app_ui/theme/text_styles/app_text_styles.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class AppThemeData extends Equatable {
  const AppThemeData({
    required this.colors,
    required this.typography,
    required this.themeData,
  });

  final AppColors colors;
  final AppTextStyles typography;
  final ThemeData themeData;

  @override
  List<Object?> get props => [colors, typography, themeData];
}

class AppThemeProvider extends InheritedWidget {
  const AppThemeProvider({required this.data, required super.child, super.key});

  final AppThemeData data;

  static AppThemeData of(BuildContext context) {
    final result = context
        .dependOnInheritedWidgetOfExactType<AppThemeProvider>();
    assert(result != null, 'No AppThemeProvider found in context');
    return result!.data;
  }

  @override
  bool updateShouldNotify(AppThemeProvider oldWidget) => data != oldWidget.data;
}
