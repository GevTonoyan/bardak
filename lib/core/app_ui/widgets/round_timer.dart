import 'package:bardak/core/app_ui/theme/text_styles/app_text_styles.dart';
import 'package:bardak/core/app_ui/widgets/app_icon_text_button.dart';
import 'package:bardak/core/generated/assets/assets.gen.dart';
import 'package:bardak/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';

class RoundTimer extends StatelessWidget {
  const RoundTimer({required this.seconds, super.key});

  final int seconds;

  static const _timerWidth = 65.0;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    final bgColor = switch (seconds) {
      <= 5 => colors.red,
      <= 10 => colors.orange,
      _ => colors.green,
    };

    return AppIconTextButton(
      padding: const .symmetric(horizontal: 14, vertical: 10),
      color: bgColor,
      child: SizedBox(
        width: _timerWidth,
        child: Row(
          children: [
            Expanded(
              child: Text(
                seconds.toString(),
                textAlign: .center,
                style: context.typography.regular28.withNumericFont,
              ),
            ),
            Assets.icons.clock.svg(width: 20, height: 20),
          ],
        ),
      ),
    );
  }
}
