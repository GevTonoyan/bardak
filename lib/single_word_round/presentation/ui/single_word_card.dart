import 'dart:math' as math;

import 'package:boardify/utils/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';

class SingleWordCard extends StatelessWidget {
  const SingleWordCard({required this.word, super.key});

  final String word;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return SizedBox(
      height: 340,
      width: 262,
      child: Transform.rotate(
        angle: 2.25 * math.pi / 180,
        child: Container(
          decoration: BoxDecoration(
            color: colors.white30,
            borderRadius: BorderRadius.circular(12),
            border: GradientBoxBorder(
              width: 3,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  colors.white.withValues(alpha: 0.3),
                  colors.white.withValues(alpha: 0.05),
                  colors.white.withValues(alpha: 0.05),
                  colors.white.withValues(alpha: 0.3),
                ],
              ),
            ),
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, 10),
                color: colors.black.withValues(alpha: 0.2),
              ),
            ],
          ),
          child: Center(
            child: Text(
              word,
              style: context.typography.regular38.copyWith(color: colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
