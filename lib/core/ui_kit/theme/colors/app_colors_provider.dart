import 'package:flutter/material.dart';

import 'app_colors.dart' show AppColors;


class AppColorsProvider extends InheritedWidget {
  final AppColors colors;

  const AppColorsProvider({
    super.key,
    required this.colors,
    required super.child,
  });

  static AppColors of(BuildContext context) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<AppColorsProvider>();
    assert(provider != null, 'AppThemeProvider not found in context');
    return provider!.colors;
  }

  @override
  bool updateShouldNotify(AppColorsProvider oldWidget) =>
      oldWidget.colors != colors;
}
