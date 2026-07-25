import 'package:bardak/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';

class TextWithBorder extends StatelessWidget {
  const TextWithBorder(
    this.text, {
    required this.style,
    this.borderWidth = 5.0,
    this.borderColor,
    this.textColor,
    this.textAlign = .start,
    super.key,
  });

  final String text;
  final TextStyle style;
  final double borderWidth;
  final Color? borderColor;
  final Color? textColor;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Stack(
      children: [
        // 1. THE BORDER (Background layer)
        Text(
          text,
          textAlign: textAlign,
          style: style.copyWith(
            foreground: Paint()
              ..style = .stroke
              ..strokeWidth = borderWidth
              ..strokeCap = StrokeCap.round
              ..strokeJoin = StrokeJoin.round
              ..color = borderColor ?? colors.black,
          ),
        ),
        // 2. THE FILL (Foreground layer)
        Text(
          text,
          textAlign: textAlign,
          style: style.copyWith(
            color: textColor ?? colors.white,
          ),
        ),
      ],
    );
  }
}
