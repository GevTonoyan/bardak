import 'package:bardak/core/app_ui/theme/text_styles/app_text_styles.dart';
import 'package:bardak/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';

// ----- Classic (card) mode -----

/// Classic rule 1 — a card holds a list of words to explain in any order.
class AliasCardIllustration extends StatelessWidget {
  const AliasCardIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return const _MiniCard(
      child: Column(
        mainAxisAlignment: .center,
        spacing: 12,
        children: [
          _Bar(),
          _Bar(width: 70),
          _Bar(),
          _Bar(width: 60),
          _Bar(),
          _Bar(width: 74),
        ],
      ),
    );
  }
}

/// Classic rule 2 — clear every word on the card before the next one.
class AliasClearCardIllustration extends StatelessWidget {
  const AliasClearCardIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Row(
      mainAxisSize: .min,
      spacing: 12,
      children: [
        const _MiniCard(
          width: 130,
          child: Column(
            mainAxisAlignment: .center,
            spacing: 12,
            children: [
              _CheckedBar(),
              _CheckedBar(),
              _CheckedBar(),
            ],
          ),
        ),
        Icon(Icons.arrow_forward_rounded, size: 30, color: colors.white),
        const _MiniCard(width: 96, child: SizedBox.shrink()),
      ],
    );
  }
}

// ----- One-word mode -----

/// One-word rule 1 — a single word shows on screen for the team to guess.
class AliasFocusWordIllustration extends StatelessWidget {
  const AliasFocusWordIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return const _MiniCard(
      width: 220,
      child: Center(child: _Bar(width: 120)),
    );
  }
}

/// One-word rule 2 — skipping a word costs a point.
class AliasSkipIllustration extends StatelessWidget {
  const AliasSkipIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisSize: .min,
      spacing: 14,
      children: [
        _WordPill(trailing: Icon(Icons.skip_next_rounded, size: 24)),
        _PointsBadge('-1'),
      ],
    );
  }
}

// ----- General -----

/// General rule 1 — every correct word earns a point.
class AliasPointsIllustration extends StatelessWidget {
  const AliasPointsIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Row(
      mainAxisSize: .min,
      spacing: 14,
      children: [
        const _WordPill(trailing: _CheckIcon()),
        _PointsBadge('+1', color: colors.green),
      ],
    );
  }
}

/// General rule 2 — explain with synonyms, antonyms and descriptions.
class AliasExplainIllustration extends StatelessWidget {
  const AliasExplainIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      constraints: const BoxConstraints(minWidth: 150),
      padding: const .symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: colors.secondary,
        borderRadius: const .only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
          bottomRight: Radius.circular(20),
          bottomLeft: Radius.circular(4),
        ),
        border: Border.all(color: colors.white30, width: 2),
      ),
      child: Row(
        mainAxisSize: .min,
        spacing: 14,
        children: [
          Icon(Icons.lightbulb_rounded, size: 34, color: colors.white),
          const Column(
            mainAxisSize: .min,
            crossAxisAlignment: .start,
            spacing: 8,
            children: [
              _Bar(width: 70),
              _Bar(width: 54),
              _Bar(width: 62),
            ],
          ),
        ],
      ),
    );
  }
}

/// General rule 3 — translations, root words, spelling and pointing are banned.
class AliasNoCheatingIllustration extends StatelessWidget {
  const AliasNoCheatingIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Stack(
      alignment: .center,
      children: [
        const _WordPill(width: 120),
        Icon(Icons.block_rounded, size: 72, color: colors.red),
      ],
    );
  }
}

// ----- Shared primitives -----

/// A card mirroring the game-card gradient look.
class _MiniCard extends StatelessWidget {
  const _MiniCard({required this.child, this.width = 160});

  final Widget child;
  final double width;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      width: width,
      height: 200,
      padding: const .symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        borderRadius: .circular(16),
        gradient: LinearGradient(
          begin: .topCenter,
          end: .bottomCenter,
          colors: [
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

/// A rounded bar standing in for a (language-neutral) word.
class _Bar extends StatelessWidget {
  const _Bar({this.width = 90});

  final double width;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      width: width,
      height: 10,
      decoration: BoxDecoration(
        color: colors.white50,
        borderRadius: .circular(5),
      ),
    );
  }
}

/// A word bar with a green tick, marking a guessed word.
class _CheckedBar extends StatelessWidget {
  const _CheckedBar();

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisSize: .min,
      spacing: 8,
      children: [
        _Bar(width: 56),
        _CheckIcon(),
      ],
    );
  }
}

/// A pill standing in for a single word, with an optional trailing marker.
class _WordPill extends StatelessWidget {
  const _WordPill({this.trailing, this.width});

  final Widget? trailing;
  final double? width;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      width: width,
      padding: const .symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: colors.secondary,
        borderRadius: .circular(14),
        border: Border.all(color: colors.white30, width: 2),
      ),
      child: IconTheme.merge(
        data: IconThemeData(color: colors.white),
        child: Row(
          mainAxisSize: .min,
          spacing: 8,
          children: [const _Bar(width: 44), ?trailing],
        ),
      ),
    );
  }
}

class _CheckIcon extends StatelessWidget {
  const _CheckIcon();

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.check_circle_rounded,
      size: 22,
      color: context.colors.green,
    );
  }
}

/// A small points badge; red for a penalty, green for a gain.
class _PointsBadge extends StatelessWidget {
  const _PointsBadge(this.text, {this.color});

  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: const .symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color ?? colors.red,
        borderRadius: .circular(20),
      ),
      child: Text(
        text,
        style: context.typography.regular24.withNumericFont.copyWith(
          color: colors.white,
        ),
      ),
    );
  }
}
