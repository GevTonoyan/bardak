import 'package:flutter/material.dart';

class AppTextStyles {
  factory AppTextStyles() => _instance;

  AppTextStyles._internal();

  static final AppTextStyles _instance = AppTextStyles._internal();

  final TextStyle regular38 = const TextStyle(
    fontSize: 38,
    fontWeight: .w500,
    fontFamily: 'NishikiTeki',
    height: 1,
    letterSpacing: 38 * 0.04,
    color: Colors.white,
  );

  final TextStyle regular28 = const TextStyle(
    fontSize: 28,
    fontWeight: .w500,
    fontFamily: 'NishikiTeki',
    height: 1,
    letterSpacing: 28 * 0.02,
    color: Colors.white,
  );

  final TextStyle regular24 = const TextStyle(
    fontSize: 24,
    fontWeight: .w500,
    fontFamily: 'NishikiTeki',
    height: 28 / 24,
    letterSpacing: 24 * 0.02,
    color: Colors.white,
  );

  final TextStyle regular20 = const TextStyle(
    fontSize: 20,
    fontWeight: .w500,
    fontFamily: 'NishikiTeki',
    height: 24 / 20,
    letterSpacing: 20 * 0.02,
    color: Colors.white,
  );

  final TextStyle regular18 = const TextStyle(
    fontSize: 18,
    fontWeight: .w500,
    fontFamily: 'NishikiTeki',
    height: 20 / 18,
    letterSpacing: 18 * 0.02,
    color: Colors.white,
  );

  final TextStyle medium = const TextStyle(
    fontSize: 18,
    fontWeight: .w500,
    height: 1,
    letterSpacing: 18 * 0.03,
    color: Colors.white,
  );

  final TextStyle displayLarge = const TextStyle(
    fontSize: 57,
    fontWeight: FontWeight.bold,
    height: 64 / 57,
    letterSpacing: -0.25,
    color: Colors.white,
  );

  final TextStyle displayMedium = const TextStyle(
    fontSize: 45,
    fontWeight: FontWeight.bold,
    height: 52 / 45,
    color: Colors.white,
  );

  final TextStyle displaySmall = const TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.w600,
    height: 44 / 36,
    color: Colors.white,
  );

  final TextStyle headlineLarge = const TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    height: 40 / 32,
    color: Colors.white,
  );

  final TextStyle headlineMedium = const TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    height: 36 / 28,
    color: Colors.white,
  );

  final TextStyle headlineSmall = const TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w500,
    height: 32 / 24,
    color: Colors.white,
  );

  final TextStyle titleLarge = const TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    height: 28 / 22,
    color: Colors.white,
  );

  final TextStyle titleMedium = const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 24 / 16,
    color: Colors.white,
  );

  final TextStyle titleSmall = const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 20 / 14,
    color: Colors.white,
  );

  final TextStyle bodyLarge = const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    height: 24 / 16,
    color: Colors.white,
  );

  final TextStyle bodyMedium = const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    height: 20 / 14,
    color: Colors.white,
  );

  final TextStyle bodySmall = const TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    height: 16 / 12,
    color: Colors.white,
  );

  final TextStyle labelLarge = const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 20 / 14,
    letterSpacing: 0.1,
    color: Colors.white,
  );

  final TextStyle labelMedium = const TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 16 / 12,
    letterSpacing: 0.5,
    color: Colors.white,
  );

  final TextStyle labelSmall = const TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    height: 16 / 11,
    letterSpacing: 0.5,
    color: Colors.white,
  );
}
