import 'package:bardak/core/app_ui/widgets/app_spacings.dart';
import 'package:bardak/core/app_ui/widgets/bottom_sheet.dart';
import 'package:bardak/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';

class SudokuRulesScreen extends Page<void> {
  const SudokuRulesScreen({super.key});

  static const routePath = 'sudokuRules';

  @override
  Route<void> createRoute(BuildContext context) {
    return buildAppBottomSheet<void>(
      context: context,
      settings: this,
      child: FullBottomSheet(
        titleBuilder: (context) => context.l10n.game_rules,
        child: const _SudokuRulesScreenBody(),
      ),
    );
  }
}

class _SudokuRulesScreenBody extends StatelessWidget {
  const _SudokuRulesScreenBody();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      children: [
        height30,
        Expanded(
          child: _RuleList(
            rules: [
              l10n.sudokuRule1,
              l10n.sudokuRule2,
              l10n.sudokuRule3,
              l10n.sudokuRule4,
              l10n.sudokuRule5,
              l10n.sudokuRule6,
            ],
          ),
        ),
      ],
    );
  }
}

class _RuleList extends StatelessWidget {
  const _RuleList({required this.rules});

  final List<String> rules;

  @override
  Widget build(BuildContext context) {
    final typography = context.typography;
    final colors = context.colors;

    return ListView(
      children: rules
          .map((rule) {
            return Padding(
              padding: const .only(bottom: 10),
              child: Row(
                spacing: 8,
                crossAxisAlignment: .start,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    margin: const .only(top: 8),
                    decoration: BoxDecoration(
                      shape: .circle,
                      color: colors.white,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      rule,
                      style: typography.regular20,
                    ),
                  ),
                ],
              ),
            );
          })
          .toList(growable: false),
    );
  }
}
