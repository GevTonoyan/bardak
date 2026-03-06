import 'package:alias_pro/app_ui/theme/colors/app_colors.dart';
import 'package:flutter/material.dart';

class AppDarkColors extends AppColors {
  @override
  LinearGradient get main => const LinearGradient(
    begin: .topCenter,
    end: .bottomCenter,
    colors: [
      Color(0xFF9C59FE),
      Color(0xFF6F53FD),
    ],
  );

  @override
  Color get secondary => const Color(0xFF723FBC);
}
