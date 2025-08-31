import 'package:boardify/core/extensions/context_extension.dart';
import 'package:boardify/core/ui_kit/theme/colors/app_colors.dart';
import 'package:boardify/core/ui_kit/theme/text_styles/app_text_styles.dart';
import 'package:flutter/material.dart';

extension StateThemeExtension<T extends StatefulWidget> on State<T> {
  AppColors get colors => context.appTheme.colors;

  AppTextStyles get typography => context.appTheme.typography;
}
