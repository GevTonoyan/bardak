import 'package:alias_pro/app_ui/theme/text_styles/app_text_styles.dart';
import 'package:flutter/material.dart';

/// Text widget that splits numbers into separate spans.
/// Useful for displaying numbers with different fonts.
class SmartNumberText extends StatelessWidget {
  const SmartNumberText(
    this.text, {
    required this.style,
    this.textAlign = TextAlign.start,
    super.key,
  });

  final String text;
  final TextStyle style;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(children: _buildSpans()),
      textAlign: textAlign,
    );
  }

  List<InlineSpan> _buildSpans() {
    final spans = <InlineSpan>[];
    final regex = RegExp(r'\d+');
    final matches = regex.allMatches(text);

    var lastMatchEnd = 0;

    for (final match in matches) {
      if (match.start > lastMatchEnd) {
        spans.add(
          TextSpan(
            text: text.substring(lastMatchEnd, match.start),
            style: style,
          ),
        );
      }

      spans.add(
        TextSpan(
          text: match.group(0),
          style: style.withNumericFont,
        ),
      );

      lastMatchEnd = match.end;
    }

    if (lastMatchEnd < text.length) {
      spans.add(
        TextSpan(
          text: text.substring(lastMatchEnd),
          style: style,
        ),
      );
    }

    return spans;
  }
}
