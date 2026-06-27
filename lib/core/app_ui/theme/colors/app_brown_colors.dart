import 'package:bardak/core/app_ui/theme/colors/app_colors.dart';
import 'package:flutter/material.dart';

class AppBrownColors extends AppColors {
  @override
  Color get firstGradient => const Color(0xFF8B5A2B);

  @override
  Color get secondGradient => const Color(0xFF6B3F1D);

  @override
  LinearGradient get main => LinearGradient(
    begin: .topCenter,
    end: .bottomCenter,
    colors: [firstGradient, secondGradient],
  );

  @override
  Color get secondary => const Color(0xFF4A2A11);
}
