import 'package:alias_pro/app_ui/theme/colors/app_colors.dart';
import 'package:flutter/material.dart';

class AppTurquoiseColors extends AppColors {
  @override
  Color get firstGradient => const Color(0XFF2CA5B3);

  @override
  Color get secondGradient => const Color(0xFF196770);

  @override
  LinearGradient get main => LinearGradient(
    begin: .topCenter,
    end: .bottomCenter,
    colors: [firstGradient, secondGradient],
  );

  @override
  Color get secondary => const Color(0xFF14565D);
}
