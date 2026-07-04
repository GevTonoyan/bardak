import 'package:bardak/core/app_ui/theme/colors/app_colors.dart';
import 'package:bardak/core/extensions/context_extension.dart';
import 'package:flutter/cupertino.dart';

enum AppColorScheme {
  main,
  blue,
  dark,
  purple,
  turquoise,
  yellow,
  green,
  pink,
  red,
  orange,
  brown,
  navy,
  mint,
  plum,
  grey;

  static AppColorScheme fromString(String? scheme) =>
      AppColorScheme.values.firstWhere(
        (element) => element.name == scheme,
        orElse: () => main,
      );

  AppColors get colors => switch (this) {
    main => const AppColors(
      firstGradient: Color(0xFFFF6C3F),
      secondGradient: Color(0xFFD81E1E),
      secondary: Color(0xFF7E2210),
    ),
    blue => const AppColors(
      firstGradient: Color(0xFF4068F5),
      secondGradient: Color(0xFF3B5FE2),
      secondary: Color(0xFF21378B),
    ),
    dark => const AppColors(
      firstGradient: Color(0xFF595959),
      secondGradient: Color(0xFF171717),
      secondary: Color(0xFF000000),
    ),
    purple => const AppColors(
      firstGradient: Color(0xFF9C59FE),
      secondGradient: Color(0xFF6F53FD),
      secondary: Color(0xFF723FBC),
    ),
    turquoise => const AppColors(
      firstGradient: Color(0xFF2CA5B3),
      secondGradient: Color(0xFF196770),
      secondary: Color(0xFF14565D),
    ),
    yellow => const AppColors(
      firstGradient: Color(0xFFB5B518),
      secondGradient: Color(0xFF706812),
      secondary: Color(0xFF3D3A0C),
    ),
    green => const AppColors(
      firstGradient: Color(0xFF75B435),
      secondGradient: Color(0xFF4E741F),
      secondary: Color(0xFF3C5D17),
    ),
    pink => const AppColors(
      firstGradient: Color(0xFFED3B97),
      secondGradient: Color(0xFFA61C63),
      secondary: Color(0xFF6E1F48),
    ),
    red => const AppColors(
      firstGradient: Color(0xFFDF393C),
      secondGradient: Color(0xFF932123),
      secondary: Color(0xFF6C2020),
    ),
    orange => const AppColors(
      firstGradient: Color(0xFFFF9A3E),
      secondGradient: Color(0xFFF07F1C),
      secondary: Color(0xFFB8570E),
    ),
    brown => const AppColors(
      firstGradient: Color(0xFF8B5A2B),
      secondGradient: Color(0xFF6B3F1D),
      secondary: Color(0xFF4A2A11),
    ),
    navy => const AppColors(
      firstGradient: Color(0xFF1B3A7A),
      secondGradient: Color(0xFF0F244F),
      secondary: Color(0xFF081833),
    ),
    mint => const AppColors(
      firstGradient: Color(0xFF4FD1B1),
      secondGradient: Color(0xFF2BAE91),
      secondary: Color(0xFF156E5A),
    ),
    plum => const AppColors(
      firstGradient: Color(0xFF6B2D8E),
      secondGradient: Color(0xFF4A1B66),
      secondary: Color(0xFF2E0F42),
    ),
    grey => const AppColors(
      firstGradient: Color(0xFF8C8C8C),
      secondGradient: Color(0xFF3D3D3D),
      secondary: Color(0xFF5A5A5A),
    ),
  };

  String displayName(BuildContext context) {
    final l10n = context.l10n;

    return switch (this) {
      main => l10n.theme_main,
      blue => l10n.theme_blue,
      dark => l10n.theme_dark,
      purple => l10n.theme_purple,
      turquoise => l10n.theme_turquoise,
      yellow => l10n.theme_yellow,
      green => l10n.theme_green,
      pink => l10n.theme_pink,
      red => l10n.theme_red,
      orange => l10n.theme_orange,
      brown => l10n.theme_brown,
      navy => l10n.theme_navy,
      mint => l10n.theme_mint,
      plum => l10n.theme_plum,
      grey => l10n.theme_grey,
    };
  }
}
