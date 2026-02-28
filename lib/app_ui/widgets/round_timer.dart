import 'package:alias_pro/app_ui/widgets/app_icon_text_button.dart';
import 'package:alias_pro/assets/assets.gen.dart';
import 'package:alias_pro/utils/extensions/context_extension.dart';
import 'package:flutter/material.dart';

class RoundTimer extends StatelessWidget {
  const RoundTimer({required this.seconds, super.key});

  final int seconds;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return AppIconTextButton(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      color: colors.green,
      child: Row(
        spacing: 6,
        children: [
          Text(
            seconds.toString(),
            style: context.typography.regular28.copyWith(
              color: colors.white,
              fontFamily: 'Digitalt',
            ),
          ),
          Assets.clock.svg(width: 18, height: 18),
        ],
      ),
    );
  }
}
