import 'package:alias_pro/app_ui/theme/colors/app_colors.dart';
import 'package:flutter/material.dart';

class AppGreyColors extends AppColors {
  @override
  Color get firstGradient => const Color(0xFF8C8C8C);

  @override
  Color get secondGradient => const Color(0xFF3D3D3D);

  @override
  LinearGradient get main => LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [firstGradient, secondGradient],
  );

  @override
  Color get secondary => const Color(0xFF5A5A5A);
}

