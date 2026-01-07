import 'dart:async';

import 'package:boardify/app_ui/widgets/app_button.dart';
import 'package:boardify/app_ui/widgets/app_icon_button.dart';
import 'package:boardify/app_ui/widgets/app_spacings.dart';
import 'package:boardify/utils/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

Future<void> showConfirmSheet({
  required BuildContext context,
  required String title,
  required String description,
  required String confirmText,
  required String cancelText,
  required VoidCallback onConfirm,
}) async {
  await showModalBottomSheet<void>(
    context: context,
    backgroundColor: context.colors.secondary,
    builder: (BuildContext context) {
      final colors = context.colors;
      final textStyle = context.typography.regular24.copyWith(
        color: colors.white,
      );

      return Material(
        color: colors.secondary,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: .min,
              children: [
                SizedBox(
                  height: 40,
                  child: Stack(
                    children: [
                      Center(
                        child: Text(title, style: textStyle),
                      ),
                      AppIconButton.back(onTap: () => context.pop()),
                    ],
                  ),
                ),
                height40,
                Text(description, textAlign: .center, style: textStyle),
                height40,
                AppButton(
                  color: colors.red,
                  label: cancelText,
                  onPressed: () => context.pop(),
                ),
                height20,
                AppButton(
                  color: colors.green,
                  label: confirmText,
                  onPressed: onConfirm,
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
