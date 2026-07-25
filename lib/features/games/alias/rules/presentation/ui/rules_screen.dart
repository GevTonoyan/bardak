import 'package:bardak/core/app_ui/widgets/app_button/app_button.dart';
import 'package:bardak/core/app_ui/widgets/rules_carousel.dart';
import 'package:bardak/core/extensions/context_extension.dart';
import 'package:bardak/features/games/alias/game_settings/domain/entities/game_mode.dart';
import 'package:bardak/features/games/alias/rules/presentation/ui/widgets/alias_rule_illustrations.dart';
import 'package:flutter/material.dart';

/// A full-screen, swipeable "how to play" tutorial for Alias. A mode toggle
/// swaps the mode-specific steps; the general rules follow either way.
class RulesScreen extends StatefulWidget {
  const RulesScreen({super.key});

  static const routePath = 'rules';

  @override
  State<RulesScreen> createState() => _RulesScreenState();
}

class _RulesScreenState extends State<RulesScreen> {
  GameMode _mode = GameMode.card;

  List<RuleStep> _steps(BuildContext context) {
    final l10n = context.l10n;

    final modeSteps = switch (_mode) {
      GameMode.card => [
        RuleStep(
          illustration: const AliasCardIllustration(),
          title: l10n.cardModeRule1Title,
          description: l10n.cardModeRule1,
        ),
        RuleStep(
          illustration: const AliasClearCardIllustration(),
          title: l10n.cardModeRule2Title,
          description: l10n.cardModeRule2,
        ),
      ],
      GameMode.singleWord => [
        RuleStep(
          illustration: const AliasFocusWordIllustration(),
          title: l10n.singleModeRule1Title,
          description: l10n.singleModeRule1,
        ),
        RuleStep(
          illustration: const AliasSkipIllustration(),
          title: l10n.singleModeRule2Title,
          description: l10n.singleModeRule2,
        ),
      ],
    };

    return [
      ...modeSteps,
      RuleStep(
        illustration: const AliasPointsIllustration(),
        title: l10n.generalRule1Title,
        description: l10n.generalRule1,
      ),
      RuleStep(
        illustration: const AliasExplainIllustration(),
        title: l10n.generalRule2Title,
        description: l10n.generalRule2,
      ),
      RuleStep(
        illustration: const AliasNoCheatingIllustration(),
        title: l10n.generalRule3Title,
        description: l10n.generalRule3,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    // A fresh key per mode resets the carousel to the first page on toggle.
    return RulesCarousel(
      key: ValueKey(_mode),
      header: _ModeToggle(
        mode: _mode,
        onChanged: (mode) => setState(() => _mode = mode),
      ),
      steps: _steps(context),
    );
  }
}

class _ModeToggle extends StatelessWidget {
  const _ModeToggle({required this.mode, required this.onChanged});

  final GameMode mode;
  final ValueChanged<GameMode> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    return Row(
      spacing: 10,
      children: [
        Expanded(
          child: AppButton(
            label: l10n.classicModeShort,
            color: colors.white20,
            size: .medium,
            isPressed: mode == GameMode.card,
            pressedColor: colors.white,
            pressedTextColor: colors.secondary,
            onPressed: () => onChanged(GameMode.card),
          ),
        ),
        Expanded(
          child: AppButton(
            label: l10n.oneWordModeShort,
            color: colors.white20,
            size: .medium,
            isPressed: mode == GameMode.singleWord,
            pressedColor: colors.white,
            pressedTextColor: colors.secondary,
            onPressed: () => onChanged(GameMode.singleWord),
          ),
        ),
      ],
    );
  }
}
