import 'package:boardify/utils/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

Future<void> showGamePopupDialog({
  required BuildContext context,
  required String title,
  required VoidCallback onConfirm,
  String? message,
  String? confirmText,
  String? cancelText,
  VoidCallback? onCancel,
}) {
  final localizations = context.l10n;

  return showDialog(
    context: context,
    barrierDismissible: false,
    builder:
        (_) => GamePopupDialog(
          title: title,
          message: message,
          confirmText: confirmText ?? localizations.general_yes,
          cancelText: cancelText ?? localizations.general_no,
          onConfirm: onConfirm,
          onCancel: onCancel,
        ),
  );
}

class GamePopupDialog extends StatelessWidget {
  const GamePopupDialog({
    required this.title,
    required this.confirmText,
    required this.cancelText,
    required this.onConfirm,
    super.key,
    this.message,
    this.onCancel,
  });

  final String title;
  final String? message;
  final String confirmText;
  final String cancelText;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;

  @override
  Widget build(BuildContext context) {
    final colors = context.appTheme.colors;
    final text = context.appTheme.typography;

    return Dialog(
      backgroundColor: colors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 32),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: text.titleLarge.copyWith(
                fontWeight: FontWeight.bold,
                color: colors.onSurface,
              ),
            ),
            if (message != null && message!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                message!,
                style: text.bodyMedium.copyWith(color: colors.onSurface),
                textAlign: TextAlign.center,
              ),
            ],
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      context.pop();
                      onCancel?.call();
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: colors.onSurface,
                      side: BorderSide(color: colors.outline),
                      textStyle: text.titleSmall,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(cancelText),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      context.pop();
                      onConfirm.call();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colors.primary,
                      foregroundColor: colors.onPrimary,
                      textStyle: text.titleSmall,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(confirmText),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
