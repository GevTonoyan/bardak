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
    return switch (this) {
      main => 'Հիմնական',
      purple => 'Մանուշակագույն',
      yellow => 'Դեղին',
      blue => 'Կապույտ',
      green => 'Կանաչ',
      pink => 'Վարդագույն',
      red => 'Կարմիր',
      black => 'Սև',
    };
  }
}
