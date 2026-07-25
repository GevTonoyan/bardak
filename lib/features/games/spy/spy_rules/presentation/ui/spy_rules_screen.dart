import 'package:bardak/core/app_ui/widgets/rules_carousel.dart';
import 'package:bardak/core/extensions/context_extension.dart';
import 'package:bardak/features/games/spy/spy_rules/presentation/ui/widgets/spy_rule_illustrations.dart';
import 'package:flutter/material.dart';

/// A full-screen, swipeable "how to play" tutorial for Spy.
class SpyRulesScreen extends StatelessWidget {
  const SpyRulesScreen({super.key});

  static const routePath = 'spyRules';

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return RulesCarousel(
      steps: [
        RuleStep(
          illustration: const SpyWordIllustration(),
          title: l10n.spyRule1Title,
          description: l10n.spyRule1,
        ),
        RuleStep(
          illustration: const SpyQuestionsIllustration(),
          title: l10n.spyRule2Title,
          description: l10n.spyRule2,
        ),
        RuleStep(
          illustration: const SpyHintIllustration(),
          title: l10n.spyRule3Title,
          description: l10n.spyRule3,
        ),
        RuleStep(
          illustration: const SpyVagueIllustration(),
          title: l10n.spyRule4Title,
          description: l10n.spyRule4,
        ),
        RuleStep(
          illustration: const SpyBlendIllustration(),
          title: l10n.spyRule5Title,
          description: l10n.spyRule5,
        ),
        RuleStep(
          illustration: const SpyVoteIllustration(),
          title: l10n.spyRule6Title,
          description: l10n.spyRule6,
        ),
      ],
    );
  }
}
