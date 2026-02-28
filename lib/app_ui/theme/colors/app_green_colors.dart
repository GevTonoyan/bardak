import 'package:alias_pro/app_ui/theme/colors/app_colors.dart';
import 'package:flutter/material.dart';

class AppGreenColors extends AppColors {
  @override
  LinearGradient get main => const LinearGradient(
    colors: [
      Color(0xFF75B435),
      Color(0xFF4E741F),
    ],
  );

  @override
  Color get secondary => const Color(0xFF3C5D17);
}
