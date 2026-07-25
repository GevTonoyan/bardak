import 'dart:async';

import 'package:bardak/core/app_ui/widgets/app_button/app_button.dart';
import 'package:bardak/core/app_ui/widgets/app_icon_button.dart';
import 'package:bardak/core/app_ui/widgets/app_spacings.dart';
import 'package:bardak/core/app_ui/widgets/screen_background.dart';
import 'package:bardak/core/app_ui/widgets/text_with_border.dart';
import 'package:bardak/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// One page of a [RulesCarousel]: a game-specific [illustration] above an
/// optional short [title] and a one-line [description].
class RuleStep {
  const RuleStep({
    required this.illustration,
    required this.description,
    this.title,
  });

  final Widget illustration;
  final String? title;
  final String description;
}

/// A full-screen, swipeable "how to play" tutorial. Each [RuleStep] is a page
/// with its own illustration; page dots track progress and the bottom button
/// advances to the next page, then dismisses the screen on the last one.
class RulesCarousel extends StatefulWidget {
  const RulesCarousel({required this.steps, this.header, super.key});

  final List<RuleStep> steps;

  /// Optional widget pinned between the top bar and the pages — e.g. a mode
  /// toggle that swaps the [steps].
  final Widget? header;

  @override
  State<RulesCarousel> createState() => _RulesCarouselState();
}

class _RulesCarouselState extends State<RulesCarousel> {
  final _controller = PageController();
  int _index = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _isLastPage => _index == widget.steps.length - 1;

  void _onButtonPressed() {
    if (_isLastPage) {
      context.pop();
      return;
    }
    unawaited(
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return GradientBackground(
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const .only(left: 20, top: 20, right: 20),
              child: Row(
                children: [
                  AppIconButton.back(onTap: () => context.pop()),
                ],
              ),
            ),
            if (widget.header != null)
              Padding(
                padding: const .fromLTRB(20, 20, 20, 0),
                child: widget.header,
              ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: widget.steps.length,
                onPageChanged: (index) => setState(() => _index = index),
                itemBuilder: (context, index) =>
                    _RulePage(step: widget.steps[index]),
              ),
            ),
            _PageDots(count: widget.steps.length, activeIndex: _index),
            height30,
            Padding(
              padding: .fromLTRB(20, 0, 20, 20 + bottomInset),
              child: AppButton(
                label: _isLastPage ? l10n.rules_got_it : l10n.rules_next,
                color: colors.green,
                onPressed: _onButtonPressed,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RulePage extends StatelessWidget {
  const _RulePage({required this.step});

  final RuleStep step;

  @override
  Widget build(BuildContext context) {
    final typography = context.typography;
    final colors = context.colors;
    final title = step.title;

    return Padding(
      padding: const .symmetric(horizontal: 24),
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: FittedBox(
                fit: .scaleDown,
                child: step.illustration,
              ),
            ),
          ),
          height30,
          if (title != null) ...[
            TextWithBorder(
              title,
              style: typography.regular28,
              borderWidth: 4,
              textAlign: .center,
            ),
            height20,
          ],
          Text(
            step.description,
            textAlign: .center,
            style: typography.regular20.copyWith(color: colors.white50),
          ),
          height40,
        ],
      ),
    );
  }
}

/// Row of dots tracking carousel progress; the active one stretches wider and
/// brighter.
class _PageDots extends StatelessWidget {
  const _PageDots({required this.count, required this.activeIndex});

  final int count;
  final int activeIndex;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Row(
      mainAxisAlignment: .center,
      children: [
        for (var i = 0; i < count; i++)
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
            margin: const .symmetric(horizontal: 4),
            height: 8,
            width: i == activeIndex ? 24 : 8,
            decoration: BoxDecoration(
              color: i == activeIndex ? colors.white : colors.white30,
              borderRadius: .circular(4),
            ),
          ),
      ],
    );
  }
}
