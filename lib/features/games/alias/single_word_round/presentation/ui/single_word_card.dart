import 'package:bardak/core/app_ui/theme/text_styles/app_text_styles.dart';
import 'package:bardak/core/extensions/context_extension.dart';
import 'package:bardak/core/generated/assets/assets.gen.dart';
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
            style: getDynamicTextStyle(context.typography, word),
          ),
        ),
      ),
    );
  }

  /// Calculates the font size based on the length of individual words.
  /// Returns 20.0 if ANY single word has more than 15 characters.
  /// Returns 28.0 if ALL words have 15 characters or fewer.
  TextStyle getDynamicTextStyle(AppTextStyles typography, String text) {
    // Split the text by any whitespace (spaces, tabs, newlines)
    final words = text.split(RegExp(r'\s+'));

    // Check if there is at least one word longer than 15 characters
    final hasLongWord = words.any((word) => word.length > 15);

    return hasLongWord ? typography.regular20 : typography.regular28;
  }
}

class SingleWordCardBack extends StatelessWidget {
  const SingleWordCardBack({this.onTap, super.key});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SingleWordCardShell(
        child: Center(
          child: Assets.images.logo.image(height: 130, fit: .contain),
        ),
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
