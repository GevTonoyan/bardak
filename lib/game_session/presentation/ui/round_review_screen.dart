import 'package:boardify/app_ui/widgets/app_button.dart';
import 'package:boardify/app_ui/widgets/app_icon_button.dart';
import 'package:boardify/app_ui/widgets/app_spacings.dart';
import 'package:boardify/app_ui/widgets/screen_background.dart';
import 'package:boardify/assets/assets.gen.dart';
import 'package:boardify/game_session/domain/entities/round_result.dart';
import 'package:boardify/utils/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RoundReviewScreen extends StatefulWidget {
  const RoundReviewScreen({required this.reviewedWords, super.key});

  final List<ReviewedWord> reviewedWords;

  static const routePath = 'round_review';

  @override
  State<RoundReviewScreen> createState() => _RoundReviewScreenState();
}

class _RoundReviewScreenState extends State<RoundReviewScreen> {
  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;

    return ScreenBackground(
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: .start,
          children: [
            Padding(
              padding: const .all(20),
              child: AppIconButton.close(onTap: () {}),
            ),
            Padding(
              padding: const .symmetric(horizontal: 20),
              child: Text(
                'Ժամանակն ավարտվեց Ստատիստիկա՝',
                textAlign: .center,
                style: typography.regular24.copyWith(color: colors.white),
              ),
            ),
            height20,
            Expanded(
              child: ListView.separated(
                padding: .zero,
                itemBuilder: (context, index) {
                  final reviewedWord = widget.reviewedWords[index];
                  final word = reviewedWord.word;
                  final isGuessed = reviewedWord.isGuessed;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        widget.reviewedWords[index] = (
                          word: word,
                          isGuessed: !isGuessed,
                        );
                      });
                    },
                    child: Container(
                      padding: const .symmetric(horizontal: 20, vertical: 16),
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
                          if (isGuessed)
                            Assets.check.svg(width: 24, height: 24),
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
                itemCount: widget.reviewedWords.length,
              ),
            ),
            Container(
              padding: const .symmetric(horizontal: 20, vertical: 44),
              color: colors.secondary,
              child: AppButton(
                label: 'Շարունակել',
                color: colors.green,
                onPressed: () {
                  context.pop();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
