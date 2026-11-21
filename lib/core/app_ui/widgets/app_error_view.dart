import 'package:bardak/core/app_ui/widgets/app_button/app_button.dart';
import 'package:bardak/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';

/// What went wrong on a screen that cannot go on without it: an [icon],
/// a [message], and one action such as Retry or Back.
class AppErrorView extends StatelessWidget {
  const AppErrorView({
    required this.icon,
    required this.message,
    required this.actionLabel,
    required this.actionColor,
    required this.onAction,
    super.key,
  });

  final IconData icon;
  final String message;
  final String actionLabel;
  final Color actionColor;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: .min,
      children: [
        Icon(icon, size: 56, color: context.colors.white50),
        const SizedBox(height: 12),
        Text(
          message,
          textAlign: .center,
          style: context.typography.regular20,
        ),
        const SizedBox(height: 24),
        AppButton(
          label: actionLabel,
          color: actionColor,
          size: .medium,
          onPressed: onAction,
        ),
      ],
    );
  }
}
