import 'package:alias_pro/utils/extensions/context_extension.dart';
import 'package:flutter/cupertino.dart';

enum AppColorScheme {
  main,
  blue,
  black,
  purple,
  yellow,
  green,
  pink,
  red
  ;

  static AppColorScheme fromString(String? scheme) {
    return switch (scheme) {
      'main' => main,
      'blue' => blue,
      'black' => black,
      'purple' => purple,
      'yellow' => yellow,
      'green' => green,
      'pink' => pink,
      'red' => red,
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
      yellow => l10n.theme_yellow,
      green => l10n.theme_green,
      pink => l10n.theme_pink,
      red => l10n.theme_red,
    };
  }
}
