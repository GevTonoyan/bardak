// core/app_core/theme/light_app_colors.dart

import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppLightColors implements AppColors {
  @override
  Color get primary => const Color(0xFF6750A4);

  @override
  Color get onPrimary => Colors.white;

  @override
  Color get background => const Color(0xFFF9F8FD);

  @override
  Color get onBackground => const Color(0xFF1C1B1F);

  @override
  Color get surface => Colors.white;

  @override
  Color get onSurface => const Color(0xFF1C1B1F);

  @override
  Color get secondary => const Color(0xFF625B71);

  @override
  Color get onSecondary => Colors.white;

  @override
  Color get error => const Color(0xFFB3261E);

  @override
  Color get onError => Colors.white;

  @override
  Color get outline => const Color(0xFF79747E);

  @override
  Color get divider => const Color(0xFFE0E0E0);

  @override
  Color get disabled => const Color(0xFF9E9E9E);

  @override
  Color get success => const Color(0xFF2E7D32);

  @override
  Color get warning => const Color(0xFFFFA000);

  @override
  Color get info => const Color(0xFF0288D1);

  @override
  Color get surfaceVariant => const Color(0xFFF2F2F2);

  @override
  Color get shadow => const Color(0x33000000);
}
