import 'package:alias_pro/app_ui/widgets/app_icon_text_button.dart';
import 'package:alias_pro/assets/assets.gen.dart';
import 'package:alias_pro/utils/extensions/context_extension.dart';
import 'package:flutter/material.dart';

class RoundTimer extends StatelessWidget {
  const RoundTimer({required this.seconds, super.key});

  final int seconds;

  static const _timerWidth = 62.0;

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
                style: context.typography.regular28.copyWith(
                  fontFamily: 'Digitalt',
                ),
              ),
            ),
            Assets.icons.clock.svg(width: 20, height: 20),
          ],
        ),
      ),
    );
  }
}
