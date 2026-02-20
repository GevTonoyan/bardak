import 'package:boardify/assets/assets.gen.dart';
import 'package:boardify/game_session/domain/entities/round_result.dart';
import 'package:boardify/utils/extensions/context_extension.dart';
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
        final isGuessed = reviewedWord.isGuessed;

        return GestureDetector(
          onTap: () => onToggle(index),
          child: Container(
            padding: const .symmetric(
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
                if (isGuessed) Assets.check.svg(width: 24, height: 24),
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
