import 'package:flutter/material.dart';

class AppColors {
  const AppColors({
    required this.firstGradient,
    required this.secondGradient,
    required this.secondary,
  });

  final Color firstGradient;

  final Color secondGradient;

  final Color secondary;

  LinearGradient get main => LinearGradient(
    begin: .topCenter,
    end: .bottomCenter,
    colors: [firstGradient, secondGradient],
  );

  Color get green => const Color(0xFF59CA42);

  Color get red => const Color(0xFFD42B2B);

  Color get orange => const Color(0xFFE38417);

  Color get blue => const Color(0xFF4068F5);

  Color get purple => const Color(0xFFA473E9);

  Color get shadow => const Color(0xFFB9B9B9);

  Color get black => const Color(0xFF000000);

  Color get white => const Color(0xFFFFFFFF);

  Color get white10 => const Color(0xFFFFFFFF).withValues(alpha: 0.1);

  Color get white20 => const Color(0xFFFFFFFF).withValues(alpha: 0.2);

  Color get white30 => const Color(0xFFFFFFFF).withValues(alpha: 0.3);

  Color get white50 => const Color(0xFFFFFFFF).withValues(alpha: 0.5);
}
