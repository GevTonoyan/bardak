import 'package:flutter/material.dart';

abstract class AppColors {
  LinearGradient get main;

  Color get firstGradient;

  Color get secondGradient;

  Color get secondary;

  Color green = const Color(0xFF59CA42);

  Color red = const Color(0xFFD42B2B);

  Color orange = const Color(0xFFE38417);

  Color blue = const Color(0xFF4068F5);

  Color purple = const Color(0xFFA473E9);

  Color shadow = const Color(0xFFB9B9B9);

  Color black = const Color(0xFF000000);

  Color white = const Color(0xFFFFFFFF);

  Color white10 = const Color(0xFFFFFFFF).withValues(alpha: 0.1);

  Color white20 = const Color(0xFFFFFFFF).withValues(alpha: 0.2);

  Color white30 = const Color(0xFFFFFFFF).withValues(alpha: 0.3);

  Color white50 = const Color(0xFFFFFFFF).withValues(alpha: 0.5);
}
