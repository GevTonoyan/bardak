import 'package:alias_pro/app_ui/theme/colors/app_colors.dart';
import 'package:flutter/material.dart';

class AppBlueColors extends AppColors {
  @override
  LinearGradient get main => const LinearGradient(
    colors: [
      Color(0xFF4068F5),
      Color(0xFF3B5FE2),
    ],
  );

  @override
  Color get secondary => const Color(0xFF21378B);
}
