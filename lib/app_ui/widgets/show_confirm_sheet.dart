import 'dart:async';
import 'package:bardak/app_ui/widgets/app_button/app_button.dart';
import 'package:bardak/app_ui/widgets/app_spacings.dart';
import 'package:bardak/app_ui/widgets/bottom_sheet.dart';
import 'package:bardak/utils/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

Future<void> showConfirmSheet({
  required BuildContext context,
  required String title,
  required String description,
  required String confirmText,
  required String cancelText,
  required Color confirmColor,
  required Color cancelColor,
  required VoidCallback onConfirm,
}) async {
  final typography = context.typography.regular24;

  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: context.colors.secondary,
    builder: (context) {
      return PartialBottomSheet(
        titleBuilder: (context) => title,
        child: Column(
          mainAxisSize: .min,
          children: [
            height40,
            Text(description, textAlign: .center, style: typography),
            height40,
            AppButton(
              color: confirmColor,
              label: confirmText,
              onPressed: () {
                context.pop();
                onConfirm.call();
              },
            ),
            height20,
            AppButton(
              color: cancelColor,
              label: cancelText,
              onPressed: () {
                context.pop();
              },
            ),
          ],
        ),
      );
    },
  );
}
