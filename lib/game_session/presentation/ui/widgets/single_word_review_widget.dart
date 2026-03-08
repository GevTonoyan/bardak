import 'package:alias_pro/assets/assets.gen.dart';
import 'package:alias_pro/game_session/domain/entities/round_result.dart';
import 'package:alias_pro/utils/extensions/context_extension.dart';
import 'package:flutter/material.dart';

class SingleWordReviewWidget extends StatelessWidget {
  const SingleWordReviewWidget({
    required this.reviewedWords,
    required this.onToggle,
    super.key,
  });

  final List<ReviewedWord> reviewedWords;
  final void Function(int index) onToggle;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;

    return ListView.separated(
      padding: .zero,
      itemBuilder: (context, index) {
        final reviewedWord = reviewedWords[index];
        final word = reviewedWord.word;
        final isGuessed = reviewedWord.status.isGuessed;

        return GestureDetector(
          onTap: () => onToggle(index),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 16,
            ),
            color: isGuessed ? colors.green : colors.red,
            child: Row(
              mainAxisAlignment: .spaceBetween,
              spacing: 10,
              children: [
                Text(
                  word,
                  style: typography.regular24.copyWith(
                    color: colors.white,
                  ),
                ),
                if (isGuessed) Assets.icons.check.svg(width: 24, height: 24),
              ],
            ),
          ),
        );
      },
      separatorBuilder: (_, _) => Divider(
        height: 1,
        color: colors.white20,
        thickness: 1,
      ),
      itemCount: reviewedWords.length,
    );
  }
}
