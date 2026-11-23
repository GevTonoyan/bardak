import 'package:bardak/core/app_ui/widgets/app_icon_button.dart';
import 'package:bardak/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';

/// A screen's top bar: back on the left and [title] centered on the
/// screen, shrinking to fit when it is long.
class AppScreenHeader extends StatelessWidget {
  const AppScreenHeader({
    required this.title,
    required this.onBack,
    super.key,
  });

  final String title;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 10,
      children: [
        AppIconButton.back(onTap: onBack),
        Expanded(
          child: FittedBox(
            fit: .scaleDown,
            child: Text(title, style: context.typography.regular24),
          ),
        ),
        // Matches the back button, so the title stays truly centered.
        const SizedBox(width: AppIconButton.size),
      ],
    );
  }
}
