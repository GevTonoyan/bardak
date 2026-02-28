import 'package:alias_pro/app_ui/theme/colors/app_colors.dart';
import 'package:flutter/material.dart';

class AppMainColors extends AppColors {
  @override
  LinearGradient get main => const LinearGradient(
    begin: .bottomCenter,
    end: .topCenter,
    colors: [
      Color(0xFFFF6C3F),
      Color(0xFFD81E1E),
    ],
  );

  @override
  Color get secondary => const Color(0xFF7E2210);
}
