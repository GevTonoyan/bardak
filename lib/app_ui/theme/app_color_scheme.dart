import 'package:bardak/utils/extensions/context_extension.dart';
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
  grey
  ;

  static AppColorScheme fromString(String? scheme) =>
      AppColorScheme.values.firstWhere(
        (element) => element.name == scheme,
        orElse: () => main,
      );

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
