import 'package:bardak/core/extensions/context_extension.dart';
import 'package:bardak/core/generated/assets/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';

const _cardBorderRadius = 12.0;
const _cardBorderWidth = 3.0;

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

              const radius = _cardBorderRadius - _cardBorderWidth;

              final itemRadius = BorderRadius.only(
                topLeft: isFirst ? const .circular(radius) : .zero,
                topRight: isFirst ? const .circular(radius) : .zero,
                bottomLeft: isLast ? const .circular(radius) : .zero,
                bottomRight: isLast ? const .circular(radius) : .zero,
              );

              return Material(
                color: Colors.transparent,
                child: GestureDetector(
                  behavior: .opaque,
                  onTap: () {
                    onTap(selected: !isSelected, word: currentWord);
                  },
                  child: Container(
                    padding: const .symmetric(vertical: 14, horizontal: 10),
                    decoration: BoxDecoration(
                      color: isSelected ? colors.green : Colors.transparent,
                      borderRadius: itemRadius,
                    ),
                    child: Text(
                      currentWord,
                      style: typography.regular20.copyWith(fontWeight: .w400),
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
  const MultipleWordsCardBack({this.onTap, super.key});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return MultipleWordsCardShell(
      child: GestureDetector(
        onTap: onTap,
        child: Center(
          child: Assets.images.logo.image(
            height: 165,
            width: 279,
            fit: .contain,
          ),
        ),
      ),
    );
  }
}

class MultipleWordsCardShell extends StatelessWidget {
  const MultipleWordsCardShell({required this.child, super.key});

  final Widget child;

  static final _radius = BorderRadius.circular(_cardBorderRadius);

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      decoration: BoxDecoration(
        borderRadius: _radius,
        border: GradientBoxBorder(
          width: _cardBorderWidth,
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
        gradient: LinearGradient(
          begin: .topCenter,
          end: .bottomCenter,
          colors: [
            Color.alphaBlend(colors.white20, colors.firstGradient),
            Color.alphaBlend(colors.white20, colors.secondGradient),
          ],
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
    );
  }
}
