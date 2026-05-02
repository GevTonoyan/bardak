import 'package:bardak/app_ui/theme/colors/app_colors.dart';
import 'package:flutter/material.dart';

class AppNavyColors extends AppColors {
  @override
  Color get firstGradient => const Color(0xFF1B3A7A);

  @override
  Color get secondGradient => const Color(0xFF0F244F);

  @override
  LinearGradient get main => LinearGradient(
    begin: .topCenter,
    end: .bottomCenter,
    colors: [firstGradient, secondGradient],
  );

  @override
  Color get secondary => const Color(0xFF081833);
}
