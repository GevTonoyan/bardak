import 'package:boardify/app_ui/theme/colors/app_colors.dart';
import 'package:flutter/material.dart';

class AppDarkColors implements AppColors {
  @override
  Color get primary => const Color(0xFF6750A4);

  @override
  Color get onPrimary => Colors.white;

  @override
  Color get background => const Color(0xFF1C1B1F);

  @override
  Color get onBackground => const Color(0xFFF4EFF4);

  @override
  Color get surface => const Color(0xFF2C2C2E);

  @override
  Color get onSurface => const Color(0xFFF4EFF4);

  @override
  Color get secondary => const Color(0xFFCCC2DC);

  @override
  Color get onSecondary => const Color(0xFF332D41);

  @override
  Color get error => const Color(0xFFD32F2F);

  @override
  Color get onError => const Color(0xFF601410);

  @override
  Color get outline => const Color(0xFF938F99);

  @override
  Color get divider => const Color(0xFF444444);

  @override
  Color get disabled => const Color(0xFF666666);

  @override
  Color get success => const Color(0xFF81C784);

  @override
  Color get warning => const Color(0xFFFFB74D);

  @override
  Color get info => const Color(0xFF4FC3F7);

  @override
  Color get surfaceVariant => const Color(0xFF2A2A2A);

  @override
  Color get shadow => const Color(0x66000000);
}
