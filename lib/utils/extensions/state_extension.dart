import 'package:alias_pro/utils/extensions/context_extension.dart';
import 'package:alias_pro/app_ui/theme/colors/app_colors.dart';
import 'package:alias_pro/app_ui/theme/text_styles/app_text_styles.dart';
import 'package:flutter/material.dart';

extension StateThemeExtension<T extends StatefulWidget> on State<T> {
  AppColors get colors => context.appTheme.colors;

  AppTextStyles get typography => context.appTheme.typography;
}
