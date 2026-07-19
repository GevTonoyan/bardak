import 'package:bardak/core/app_ui/theme/text_styles/app_text_styles.dart';
import 'package:bardak/core/app_ui/widgets/game_card.dart';
import 'package:bardak/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';

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
      child: GameCardShell(
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
    return GameCardBack(onTap: onTap);
  }
}
