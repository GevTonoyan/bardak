import 'package:bardak/core/extensions/context_extension.dart';
import 'package:bardak/core/generated/assets/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';

/// The shared game card look: gradient fill, gradient border and shadow.
class GameCardShell extends StatelessWidget {
  const GameCardShell({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return SizedBox(
      height: 380,
      width: 300,
      child: Container(
        padding: const .symmetric(horizontal: 10),
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

/// The hidden face of a game card, showing only the app logo.
class GameCardBack extends StatelessWidget {
  const GameCardBack({this.onTap, super.key});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: GameCardShell(
        child: Center(
          child: Assets.images.logo.image(height: 130, fit: .contain),
        ),
      ),
    );
  }
}
