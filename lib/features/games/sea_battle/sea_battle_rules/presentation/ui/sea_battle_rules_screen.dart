import 'package:bardak/core/app_ui/widgets/rules_carousel.dart';
import 'package:bardak/core/extensions/context_extension.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_rules/presentation/ui/widgets/sea_battle_rule_illustrations.dart';
import 'package:flutter/material.dart';

/// A full-screen, swipeable "how to play" tutorial for Sea Battle.
class SeaBattleRulesScreen extends StatelessWidget {
  const SeaBattleRulesScreen({super.key});

  static const routePath = 'seaBattleRules';

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return RulesCarousel(
      steps: [
        RuleStep(
          illustration: const SeaBattleFleetIllustration(),
          title: l10n.sea_battle_rule_1_title,
          description: l10n.sea_battle_rule_1,
        ),
        RuleStep(
          illustration: const SeaBattleNoTouchIllustration(),
          title: l10n.sea_battle_rule_2_title,
          description: l10n.sea_battle_rule_2,
        ),
        RuleStep(
          illustration: const SeaBattleShootIllustration(),
          title: l10n.sea_battle_rule_3_title,
          description: l10n.sea_battle_rule_3,
        ),
        RuleStep(
          illustration: const SeaBattleHitAgainIllustration(),
          title: l10n.sea_battle_rule_4_title,
          description: l10n.sea_battle_rule_4,
        ),
        RuleStep(
          illustration: const SeaBattleSinkIllustration(),
          title: l10n.sea_battle_rule_5_title,
          description: l10n.sea_battle_rule_5,
        ),
        RuleStep(
          illustration: const SeaBattleWinIllustration(),
          title: l10n.sea_battle_rule_6_title,
          description: l10n.sea_battle_rule_6,
        ),
      ],
    );
  }
}
