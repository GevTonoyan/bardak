import 'package:bardak/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';

/// Rule 1 — most players share one secret word; the spy's card is blank.
class SpyWordIllustration extends StatelessWidget {
  const SpyWordIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;

    return Row(
      mainAxisSize: .min,
      spacing: 18,
      children: [
        _RoleCard(
          child: Column(
            mainAxisAlignment: .center,
            spacing: 12,
            children: [
              Icon(Icons.visibility_rounded, size: 34, color: colors.white),
              const _WordBars(),
            ],
          ),
        ),
        _RoleCard(
          isSpy: true,
          child: Center(
            child: Text('?', style: typography.regular38.copyWith(height: 1)),
          ),
        ),
      ],
    );
  }
}

/// Rule 2 — players take turns asking each other questions.
class SpyQuestionsIllustration extends StatelessWidget {
  const SpyQuestionsIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisSize: .min,
      spacing: 16,
      children: [
        _Bubble(child: Icon(Icons.question_mark_rounded, size: 30)),
        _Bubble(flip: true, child: Icon(Icons.chat_bubble_rounded, size: 26)),
      ],
    );
  }
}

/// Rule 3 — alternatively, drop a one-word clue related to the secret word.
class SpyHintIllustration extends StatelessWidget {
  const SpyHintIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return _Bubble(
      child: Container(
        width: 60,
        height: 12,
        decoration: BoxDecoration(
          color: colors.white,
          borderRadius: .circular(6),
        ),
      ),
    );
  }
}

/// Rule 4 — keep clues vague: enough to prove innocence, not reveal the word.
class SpyVagueIllustration extends StatelessWidget {
  const SpyVagueIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return const _Bubble(
      child: Row(
        mainAxisSize: .min,
        spacing: 10,
        children: [
          _WordBars(width: 46),
          Icon(Icons.lock_rounded, size: 26),
        ],
      ),
    );
  }
}

/// Rule 5 — the spy blends in and tries to work out the word.
class SpyBlendIllustration extends StatelessWidget {
  const SpyBlendIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisSize: .min,
      spacing: 12,
      children: [
        _Bubble(child: Icon(Icons.question_mark_rounded, size: 28)),
        _Avatar(icon: Icons.visibility_off_rounded, isSpy: true),
      ],
    );
  }
}

/// Rule 6 — everyone votes on who the spy is.
class SpyVoteIllustration extends StatelessWidget {
  const SpyVoteIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Column(
      mainAxisSize: .min,
      spacing: 10,
      children: [
        Container(
          padding: const .symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: colors.orange,
            borderRadius: .circular(30),
          ),
          child: Icon(Icons.how_to_vote_rounded, size: 30, color: colors.white),
        ),
        Icon(Icons.keyboard_arrow_down_rounded, size: 26, color: colors.white),
        const _Avatar(icon: Icons.visibility_off_rounded, isSpy: true),
      ],
    );
  }
}

/// A circular player token; the spy variant is tinted red.
class _Avatar extends StatelessWidget {
  const _Avatar({required this.icon, this.isSpy = false});

  final IconData icon;
  final bool isSpy;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: isSpy ? colors.red : colors.secondary,
        shape: .circle,
        border: Border.all(color: colors.white, width: 3),
      ),
      child: Icon(icon, size: 30, color: colors.white),
    );
  }
}

/// A small role card mirroring the game-card look.
class _RoleCard extends StatelessWidget {
  const _RoleCard({required this.child, this.isSpy = false});

  final Widget child;
  final bool isSpy;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      width: 120,
      height: 150,
      padding: const .all(12),
      decoration: BoxDecoration(
        borderRadius: .circular(16),
        gradient: LinearGradient(
          begin: .topCenter,
          end: .bottomCenter,
          colors: isSpy
              ? [colors.red, colors.secondary]
              : [
                  Color.alphaBlend(colors.white20, colors.firstGradient),
                  Color.alphaBlend(colors.white20, colors.secondGradient),
                ],
        ),
        border: Border.all(color: colors.white30, width: 2),
      ),
      child: child,
    );
  }
}

/// A rounded speech bubble in the secondary colour.
class _Bubble extends StatelessWidget {
  const _Bubble({required this.child, this.flip = false});

  final Widget child;
  final bool flip;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      constraints: const BoxConstraints(minWidth: 80, minHeight: 64),
      padding: const .symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: colors.secondary,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(20),
          topRight: const Radius.circular(20),
          bottomLeft: Radius.circular(flip ? 20 : 4),
          bottomRight: Radius.circular(flip ? 4 : 20),
        ),
        border: Border.all(color: colors.white30, width: 2),
      ),
      child: IconTheme.merge(
        data: IconThemeData(color: colors.white),
        child: child,
      ),
    );
  }
}

/// Stacked rounded bars standing in for the (language-neutral) secret word.
class _WordBars extends StatelessWidget {
  const _WordBars({this.width = 56});

  final double width;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Column(
      mainAxisSize: .min,
      spacing: 6,
      children: [
        for (var i = 0; i < 2; i++)
          Container(
            width: i.isEven ? width : width * 0.7,
            height: 8,
            decoration: BoxDecoration(
              color: colors.white50,
              borderRadius: .circular(4),
            ),
          ),
      ],
    );
  }
}
