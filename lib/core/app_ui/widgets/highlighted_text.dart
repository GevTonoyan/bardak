import 'package:bardak/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';

class HighlightedText extends StatelessWidget {
  const HighlightedText({required this.text, super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;

    return Container(
      padding: const .all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: colors.secondary,
      ),
      child: Text(
        text,
        style: typography.regular28,
      ),
    );
  }
}
