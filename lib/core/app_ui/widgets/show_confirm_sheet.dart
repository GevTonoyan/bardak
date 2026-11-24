import 'dart:async';

import 'package:bardak/core/app_ui/widgets/app_button/app_button.dart';
import 'package:bardak/core/app_ui/widgets/app_spacings.dart';
import 'package:bardak/core/app_ui/widgets/bottom_sheet.dart';
import 'package:bardak/core/extensions/context_extension.dart';
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
    useRootNavigator: true,
    backgroundColor: context.colors.secondary,
    constraints: const BoxConstraints(maxWidth: double.maxFinite),
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

/// Asks before leaving a game in progress, the same way in every game:
/// red to leave, green to stay. [onConfirm] does the leaving.
Future<void> showExitGameSheet({
  required BuildContext context,
  required VoidCallback onConfirm,
}) {
  final l10n = context.l10n;
  final colors = context.colors;

  return showConfirmSheet(
    context: context,
    title: l10n.exit_game_title,
    description: l10n.exit_game_description,
    confirmText: l10n.exit_game_confirm,
    cancelText: l10n.cancel,
    confirmColor: colors.red,
    cancelColor: colors.green,
    onConfirm: onConfirm,
  );
}
