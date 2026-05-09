import 'package:bardak/app_ui/widgets/app_button/app_button.dart';
import 'package:bardak/app_ui/widgets/app_spacings.dart';
import 'package:bardak/app_ui/widgets/bottom_sheet.dart';
import 'package:bardak/pre_game/domain/entities/pre_game_entity.dart';
import 'package:bardak/utils/extensions/context_extension.dart';
import 'package:bardak/utils/extensions/state_extension.dart';
import 'package:flutter/material.dart';

class RulesScreen extends Page<void> {
  const RulesScreen({super.key});

  static const routePath = 'rules';

  @override
  Route<void> createRoute(BuildContext context) {
    return buildAppBottomSheet<void>(
      context: context,
      settings: this,
      child: FullBottomSheet(
        titleBuilder: (context) => context.l10n.game_rules,
        child: const _RulesScreenBody(),
      ),
    );
  }
}

class _RulesScreenBody extends StatefulWidget {
  const _RulesScreenBody();

  @override
  State<_RulesScreenBody> createState() => _RulesScreenBodyState();
}

class _RulesScreenBodyState extends State<_RulesScreenBody> {
  GameMode gameMode = .card;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.8,
      child: Column(
        children: [
          height30,
          Row(
            spacing: 10,
            children: [
              Expanded(
                child: AppButton(
                  label: context.l10n.classicMode,
                  color: colors.white20,
                  isPressed: gameMode == GameMode.card,
                  pressedColor: colors.white,
                  pressedTextColor: colors.secondary,
                  onPressed: () {
                    setState(() {
                      gameMode = GameMode.card;
                    });
                  },
                ),
              ),
              Expanded(
                child: AppButton(
                  label: context.l10n.oneWordMode,
                  color: colors.white20,
                  isPressed: gameMode == GameMode.singleWord,
                  pressedColor: colors.white,
                  pressedTextColor: colors.secondary,
                  onPressed: () {
                    setState(() {
                      gameMode = GameMode.singleWord;
                    });
                  },
                ),
              ),
            ],
          ),
          height20,
          Expanded(
            child: _RuleList(
              rules: switch (gameMode) {
                .card => [
                  l10n.cardModeRule1,
                  l10n.cardModeRule2,
                  l10n.cardModeRule3,
                  l10n.generalRule1,
                  l10n.generalRule2,
                  l10n.generalRule3,
                ],
                .singleWord => [
                  l10n.singleModeRule1,
                  l10n.singleModeRule2,
                  l10n.singleModeRule3,
                  l10n.generalRule1,
                  l10n.generalRule2,
                  l10n.generalRule3,
                ],
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _RuleList extends StatelessWidget {
  const _RuleList({required this.rules});

  final List<String> rules;

  @override
  Widget build(BuildContext context) {
    final typography = context.appTheme.typography;
    final colors = context.appTheme.colors;

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
