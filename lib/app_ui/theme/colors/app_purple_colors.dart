import 'package:alias_pro/app_ui/theme/colors/app_colors.dart';
import 'package:flutter/material.dart';

class AppPurpleColors extends AppColors {
  @override
  Color get firstGradient => const Color(0xFF9C59FE);

  @override
  Color get secondGradient => const Color(0xFF6F53FD);

  @override
  LinearGradient get main => LinearGradient(
    begin: .topCenter,
    end: .bottomCenter,
    colors: [firstGradient, secondGradient],
  );

  @override
  Color get secondary => const Color(0xFF723FBC);
}
