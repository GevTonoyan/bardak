import 'package:alias_pro/app_ui/theme/colors/app_colors.dart';
import 'package:flutter/material.dart';

class AppGreenColors extends AppColors {
  @override
  Color get firstGradient => const Color(0xFF75B435);

  @override
  Color get secondGradient => const Color(0xFF4E741F);

  @override
  LinearGradient get main => LinearGradient(
    begin: .topCenter,
    end: .bottomCenter,
    colors: [firstGradient, secondGradient],
  );

  @override
  Color get secondary => const Color(0xFF3C5D17);
}
