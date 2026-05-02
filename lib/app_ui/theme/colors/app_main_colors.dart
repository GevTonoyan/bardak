import 'package:bardak/app_ui/theme/colors/app_colors.dart';
import 'package:flutter/material.dart';

class AppMainColors extends AppColors {
  @override
  Color get firstGradient => const Color(0xFFFF6C3F);

  @override
  Color get secondGradient => const Color(0xFFD81E1E);

  @override
  LinearGradient get main => LinearGradient(
    begin: .topCenter,
    end: .bottomCenter,
    colors: [firstGradient, secondGradient],
  );

  @override
  Color get secondary => const Color(0xFF7E2210);
}
