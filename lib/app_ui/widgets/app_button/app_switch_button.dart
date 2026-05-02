import 'package:bardak/app_ui/widgets/app_button/app_button.dart';
import 'package:bardak/app_ui/widgets/app_spacings.dart';
import 'package:bardak/app_ui/widgets/app_switch.dart';
import 'package:bardak/utils/extensions/context_extension.dart';
import 'package:flutter/material.dart';

class AppSwitchButton extends StatelessWidget {
  const AppSwitchButton({
    required this.label,
    required this.value,
    this.onChanged,
    this.onPressed,
    this.icon,
    super.key,
  });

  final String label;
  final bool value;
  final ValueChanged<bool>? onChanged;
  final VoidCallback? onPressed;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return AppButton(
      label: label,
      animateOnPress: false,
      onPressed: onPressed,
      color: colors.white20,
      child: Row(
        spacing: 14,
        children: [
          width20,
          ?icon,
          Expanded(
            child: Text(
              label,
              style: context.typography.regular24,
            ),
          ),
          Padding(
            padding: const .only(right: 20),
            child: AppSwitch(
              value: value,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}
