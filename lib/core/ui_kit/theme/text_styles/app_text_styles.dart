import 'package:flutter/material.dart';

class AppTextStyles {
  static final AppTextStyles _instance = AppTextStyles._internal();

  factory AppTextStyles() => _instance;

  AppTextStyles._internal();

  final TextStyle displayLarge = const TextStyle(
    fontSize: 57,
    fontWeight: FontWeight.bold,
    height: 64 / 57,
    letterSpacing: -0.25,
  );

  final TextStyle displayMedium = const TextStyle(
    fontSize: 45,
    fontWeight: FontWeight.bold,
    height: 52 / 45,
  );

  final TextStyle displaySmall = const TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.w600,
    height: 44 / 36,
  );

  final TextStyle headlineLarge = const TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    height: 40 / 32,
  );

  final TextStyle headlineMedium = const TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    height: 36 / 28,
  );

  final TextStyle headlineSmall = const TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w500,
    height: 32 / 24,
  );

  final TextStyle titleLarge = const TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    height: 28 / 22,
  );

  final TextStyle titleMedium = const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    height: 24 / 16,
  );

  final TextStyle titleSmall = const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 20 / 14,
  );

  final TextStyle bodyLarge = const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    height: 24 / 16,
  );

  final TextStyle bodyMedium = const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    height: 20 / 14,
  );

  final TextStyle bodySmall = const TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    height: 16 / 12,
  );

  final TextStyle labelLarge = const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 20 / 14,
    letterSpacing: 0.1,
  );

  final TextStyle labelMedium = const TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 16 / 12,
    letterSpacing: 0.5,
  );

  final TextStyle labelSmall = const TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    height: 16 / 11,
    letterSpacing: 0.5,
  );
}
