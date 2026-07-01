import 'package:bardak/core/app_ui/widgets/app_button/app_button.dart';
import 'package:bardak/core/app_ui/widgets/app_icon.dart';
import 'package:bardak/core/app_ui/widgets/smart_number_text.dart';
import 'package:bardak/core/app_ui/widgets/svg_icon.dart';
import 'package:bardak/core/extensions/context_extension.dart';
import 'package:bardak/core/generated/assets/assets.gen.dart';
import 'package:flutter/material.dart';

class AppStepperButton extends StatelessWidget {
  const AppStepperButton({
    required this.label,
    this.onIncrement,
    this.onDecrement,
    super.key,
  });

  final String label;
  final VoidCallback? onIncrement;
  final VoidCallback? onDecrement;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return AppButton(
      label: label,
      color: colors.white20,
      animateOnPress: false,
      child: Row(
        spacing: 14,
        children: [
          Padding(
            padding: const .only(left: 20),
            child: AppIcon(
              icon: Container(
                height: 4,
                width: 20,
                color: onDecrement == null ? colors.white30 : colors.white,
              ),
              onTap: onDecrement,
            ),
          ),
          Expanded(
            child: SmartNumberText(
              label,
              textAlign: .center,
              style: context.typography.regular24,
            ),
          ),
          Padding(
            padding: const .only(right: 20),
            child: AppIcon(
              icon: IconTheme(
                data: IconThemeData(
                  size: 20,
                  color: onIncrement == null ? colors.white30 : colors.white,
                ),
                child: SvgIcon(asset: Assets.icons.add),
              ),
              onTap: onIncrement,
            ),
          ),
        ],
      ),
    );
  }
}
