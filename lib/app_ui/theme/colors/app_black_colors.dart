import 'package:alias_pro/app_ui/theme/colors/app_colors.dart';
import 'package:flutter/material.dart';

class AppBlackColors extends AppColors {
  @override
  Color get firstGradient => const Color(0xFF595959);

  @override
  Color get secondGradient => const Color(0xFF171717);

  @override
  LinearGradient get main => LinearGradient(
    begin: .topCenter,
    end: .bottomCenter,
    colors: [firstGradient, secondGradient],
  );

  @override
  Color get secondary => const Color(0xFF000000);
}
