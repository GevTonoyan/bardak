import 'package:boardify/app_ui/theme/colors/app_colors.dart'
    show AppColors;
import 'package:flutter/material.dart';

class AppColorsProvider extends InheritedWidget {
  const AppColorsProvider({
    required this.colors,
    required super.child,
    super.key,
  });

  final AppColors colors;

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
