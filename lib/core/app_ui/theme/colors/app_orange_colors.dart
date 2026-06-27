import 'package:bardak/core/app_ui/theme/colors/app_colors.dart';
import 'package:flutter/material.dart';

class AppOrangeColors extends AppColors {
  @override
  Color get firstGradient => const Color(0xFFFF9A3E);

  @override
  Color get secondGradient => const Color(0xFFF07F1C);

  @override
  LinearGradient get main => LinearGradient(
    begin: .topCenter,
    end: .bottomCenter,
    colors: [firstGradient, secondGradient],
  );

  @override
  Color get secondary => const Color(0xFFB8570E);
}
