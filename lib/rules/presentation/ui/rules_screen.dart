import 'package:alias_pro/app_ui/widgets/app_button/app_button.dart';
import 'package:alias_pro/app_ui/widgets/app_spacings.dart';
import 'package:alias_pro/app_ui/widgets/bottom_sheet.dart';
import 'package:alias_pro/pre_game/domain/entities/pre_game_entity.dart';
import 'package:alias_pro/utils/extensions/context_extension.dart';
import 'package:alias_pro/utils/extensions/state_extension.dart';
import 'package:flutter/material.dart';

class RulesScreen extends Page<void> {
  const RulesScreen({super.key});

  static const routePath = 'rules';

  @override
  Route<void> createRoute(BuildContext context) {
    return buildAppBottomSheetRoute<void>(
      context: context,
      settings: this,
      child: const _RulesScreenBody(),
      titleBuilder: (context) => context.l10n.game_rules,
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
                  l10n.cardModeRule4,
                  l10n.cardModeRule5,
                  l10n.cardModeRule6,
                  l10n.generalRule1,
                ],
                .singleWord => [
                  l10n.singleModeRule1,
                  l10n.singleModeRule2,
                  l10n.singleModeRule3,
                  l10n.singleModeRule4,
                  l10n.singleModeRule5,
                  l10n.singleModeRule6,
                  l10n.generalRule1,
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
