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

  // How far the calm surface pulls the scheme's gradient back from full
  // intensity: most of the neon comes off the saturation, with a moderate
  // drop in lightness so white text stays legible.
  static const _calmSaturation = 0.58;
  static const _calmLightness = 0.68;

  /// A calmer, on-brand surface for long-focus screens (e.g. Sudoku), where
  /// the full-intensity [main] gradient tires the eyes over a long session.
  /// It is the scheme's own gradient, deepened and desaturated — so it still
  /// reads as the player's chosen theme, just in a lower-intensity register.
  LinearGradient get calm => LinearGradient(
    begin: .topCenter,
    end: .bottomCenter,
    colors: [_calmColor(firstGradient), _calmColor(secondGradient)],
  );

  Color _calmColor(Color color) {
    final hsl = HSLColor.fromColor(color);
    return hsl
        .withSaturation((hsl.saturation * _calmSaturation).clamp(0.0, 1.0))
        .withLightness((hsl.lightness * _calmLightness).clamp(0.0, 1.0))
        .toColor();
  }

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
