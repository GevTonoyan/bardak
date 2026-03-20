import 'package:alias_pro/utils/extensions/context_extension.dart';
import 'package:flutter/cupertino.dart';

enum AppColorScheme {
  main,
  purple,
  yellow,
  blue,
  green,
  pink,
  red,
  black
  ;

  static AppColorScheme fromString(String? scheme) {
    return switch (scheme) {
      'main' => main,
      'purple' => purple,
      'yellow' => yellow,
      'blue' => blue,
      'green' => green,
      'pink' => pink,
      'red' => red,
      'black' => black,
      _ => main,
    };
  }

  String displayName(BuildContext context) {
    final l10n = context.l10n;

    return switch (this) {
      main => l10n.theme_main,
      purple => l10n.theme_purple,
      yellow => l10n.theme_yellow,
      blue => l10n.theme_blue,
      green => l10n.theme_green,
      pink => l10n.theme_pink,
      red => l10n.theme_red,
      black => l10n.theme_black,
    };
  }
}
