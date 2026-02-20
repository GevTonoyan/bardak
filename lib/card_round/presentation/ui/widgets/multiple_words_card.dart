import 'dart:math' as math;
import 'package:boardify/assets/assets.gen.dart';
import 'package:boardify/utils/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';

typedef WordTapCallback =
    void Function({
      required bool selected,
      required String word,
    });

class MultipleWordsCard extends StatelessWidget {
  const MultipleWordsCard({
    required this.words,
    required this.guessed,
    required this.onTap,
    super.key,
  });

  final List<String> words;
  final Set<String> guessed;
  final WordTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        final colors = context.colors;
        final typography = context.typography;

        // final words = state.visible;
        // final guessed = state.guessed;

        return MultipleWordsCardShell(
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: words.length,
            itemBuilder: (context, index) {
              final currentWord = words[index];
              final isSelected = guessed.contains(currentWord);

              final isFirst = index == 0;
              final isLast = index == words.length - 1;

              final itemRadius = BorderRadius.only(
                topLeft: isFirst ? const Radius.circular(12) : Radius.zero,
                topRight: isFirst ? const Radius.circular(12) : Radius.zero,
                bottomLeft: isLast ? const Radius.circular(12) : Radius.zero,
                bottomRight: isLast ? const Radius.circular(12) : Radius.zero,
              );

              return Material(
                color: Colors.transparent,
                child: GestureDetector(
                  behavior: .opaque,
                  onTap: () {
                    onTap(selected: !isSelected, word: currentWord);
                    // context.read<CardRoundBloc>().add(
                    //   ToggleWord(
                    //     isSelected: !isSelected,
                    //     word: currentWord,
                    //   ),
                    // );
                  },
                  child: Container(
                    padding: const .all(16),
                    decoration: BoxDecoration(
                      color: isSelected ? colors.green : Colors.transparent,
                      borderRadius: itemRadius,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            currentWord,
                            style: typography.regular24.copyWith(
                              color: colors.white,
                            ),
                          ),
                        ),
                        if (isSelected) Assets.check.svg(),
                      ],
                    ),
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) => Divider(
              height: 1,
              thickness: 1,
              color: colors.white20,
            ),
          ),
        );
      },
    );
  }
}

class MultipleWordsCardBack extends StatelessWidget {
  const MultipleWordsCardBack({super.key});

  @override
  Widget build(BuildContext context) {
    return MultipleWordsCardShell(
      child: Center(
        child: SizedBox(
          height: 165,
          width: 279,
          child: Assets.logoAm.svg(),
        ),
      ),
    );
  }
}

class MultipleWordsCardShell extends StatelessWidget {
  const MultipleWordsCardShell({required this.child, super.key});

  final Widget child;

  static final _radius = BorderRadius.circular(12);

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Transform.rotate(
      angle: -1.28 * math.pi / 180,
      child: Container(
        decoration: BoxDecoration(
          color: colors.white30,
          borderRadius: _radius,
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
