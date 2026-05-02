import 'package:bardak/app_ui/theme/colors/app_colors.dart';
import 'package:flutter/material.dart';

class AppMintColors extends AppColors {
  @override
  Color get firstGradient => const Color(0xFF4FD1B1);

  @override
  Color get secondGradient => const Color(0xFF2BAE91);

  @override
  LinearGradient get main => LinearGradient(
    begin: .topCenter,
    end: .bottomCenter,
    colors: [firstGradient, secondGradient],
  );

  @override
  Color get secondary => const Color(0xFF156E5A);
}
