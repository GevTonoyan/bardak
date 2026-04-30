import 'package:alias_pro/app_ui/theme/colors/app_colors.dart';
import 'package:flutter/material.dart';

class AppPlumColors extends AppColors {
  @override
  Color get firstGradient => const Color(0xFF6B2D8E);

  @override
  Color get secondGradient => const Color(0xFF4A1B66);

  @override
  LinearGradient get main => LinearGradient(
    begin: .topCenter,
    end: .bottomCenter,
    colors: [firstGradient, secondGradient],
  );

  @override
  Color get secondary => const Color(0xFF2E0F42);
}
