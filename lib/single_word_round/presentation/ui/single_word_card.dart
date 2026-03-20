import 'package:alias_pro/assets/assets.gen.dart';
import 'package:alias_pro/utils/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';

class SingleWordCard extends StatelessWidget {
  const SingleWordCard({
    required this.word,
    required this.angle,
    super.key,
  });

  final String word;
  final double angle;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: angle,
      child: SingleWordCardShell(
        child: Center(
          child: Text(
            word,
            textAlign: .center,
            style: context.typography.regular38,
          ),
        ),
      ),
    );
  }
}

class SingleWordCardBack extends StatelessWidget {
  const SingleWordCardBack({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleWordCardShell(
      child: Center(
        child: Assets.logo.am.image(height: 130, fit: .contain),
      ),
    );
  }
}

class SingleWordCardShell extends StatelessWidget {
  const SingleWordCardShell({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return SizedBox(
      height: 340,
      width: 262,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: .circular(12),
          gradient: LinearGradient(
            begin: .topCenter,
            end: .bottomCenter,
            colors: [
              Color.alphaBlend(colors.white20, colors.firstGradient),
              Color.alphaBlend(colors.white20, colors.secondGradient),
            ],
          ),
          border: GradientBoxBorder(
            width: 3,
            gradient: LinearGradient(
              begin: .topCenter,
              end: .bottomCenter,
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
              blurStyle: BlurStyle.outer,
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}
