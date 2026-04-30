import 'package:alias_pro/utils/extensions/context_extension.dart';
import 'package:flutter/cupertino.dart';

enum AppColorScheme {
  main,
  blue,
  black,
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
  dark,
  grey
  ;

  static AppColorScheme fromString(String? scheme) {
    return switch (scheme) {
      'main' => main,
      'blue' => blue,
      'black' => black,
      'purple' => purple,
      'turquoise' => turquoise,
      'yellow' => yellow,
      'green' => green,
      'pink' => pink,
      'red' => red,
      'orange' => orange,
      'brown' => brown,
      'navy' => navy,
      'mint' => mint,
      'plum' => plum,
      _ => main,
    };
  }

  String displayName(BuildContext context) {
    final l10n = context.l10n;

    return switch (this) {
      main => l10n.theme_main,
      blue => l10n.theme_blue,
      black => l10n.theme_black,
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
      dark => l10n.theme_dark,
      grey => l10n.theme_grey,
    };
  }
}
