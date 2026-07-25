import 'package:bardak/core/app_ui/widgets/rules_carousel.dart';
import 'package:bardak/core/extensions/context_extension.dart';
import 'package:bardak/features/games/sudoku/sudoku_rules/presentation/ui/widgets/sudoku_rule_illustrations.dart';
import 'package:flutter/material.dart';

/// A full-screen, swipeable "how to play" tutorial for Sudoku.
class SudokuRulesScreen extends StatelessWidget {
  const SudokuRulesScreen({super.key});

  static const routePath = 'sudokuRules';

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return RulesCarousel(
      steps: [
        RuleStep(
          illustration: const SudokuGoalIllustration(),
          title: l10n.sudokuRule1Title,
          description: l10n.sudokuRule1,
        ),
        RuleStep(
          illustration: const SudokuHighlightIllustration(),
          title: l10n.sudokuRule2Title,
          description: l10n.sudokuRule2,
        ),
        RuleStep(
          illustration: const SudokuMistakesIllustration(),
          title: l10n.sudokuRule3Title,
          description: l10n.sudokuRule3,
        ),
        RuleStep(
          illustration: const SudokuNotesIllustration(),
          title: l10n.sudokuRule4Title,
          description: l10n.sudokuRule4,
        ),
        RuleStep(
          illustration: const SudokuControlsIllustration(),
          title: l10n.sudokuRule5Title,
          description: l10n.sudokuRule5,
        ),
        RuleStep(
          illustration: const SudokuDifficultyIllustration(),
          title: l10n.sudokuRule6Title,
          description: l10n.sudokuRule6,
        ),
      ],
    );
  }
}
