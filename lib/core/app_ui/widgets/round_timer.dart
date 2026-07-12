import 'package:bardak/core/app_ui/theme/text_styles/app_text_styles.dart';
import 'package:bardak/core/app_ui/widgets/app_icon_text_button.dart';
import 'package:bardak/core/extensions/context_extension.dart';
import 'package:bardak/core/generated/assets/assets.gen.dart';
import 'package:flutter/material.dart';

class RoundTimer extends StatelessWidget {
  const RoundTimer({
    required this.seconds,
    this.formatAsMinutes = false,
    this.orangeBelow = 10,
    this.redBelow = 5,
    super.key,
  });

  final int seconds;

  /// Shows `m:ss` instead of raw seconds — for rounds lasting minutes.
  final bool formatAsMinutes;

  /// The pill turns orange at or below this many remaining seconds.
  final int orangeBelow;

  /// The pill turns red at or below this many remaining seconds.
  final int redBelow;

  static const _secondsWidth = 65.0;
  static const _minutesWidth = 95.0;

  String get _label {
    if (!formatAsMinutes) return seconds.toString();
    final minutes = seconds ~/ 60;
    final remainder = seconds % 60;
    return '$minutes:${remainder.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    final bgColor = switch (seconds) {
      _ when seconds <= redBelow => colors.red,
      _ when seconds <= orangeBelow => colors.orange,
      _ => colors.green,
    };

    return AppIconTextButton(
      padding: const .symmetric(horizontal: 14, vertical: 10),
      color: bgColor,
      child: SizedBox(
        width: formatAsMinutes ? _minutesWidth : _secondsWidth,
        child: Row(
          children: [
            Expanded(
              child: Text(
                _label,
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
