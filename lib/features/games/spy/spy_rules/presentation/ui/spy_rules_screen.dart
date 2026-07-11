import 'package:bardak/core/app_ui/widgets/app_spacings.dart';
import 'package:bardak/core/app_ui/widgets/bottom_sheet.dart';
import 'package:bardak/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';

class SpyRulesScreen extends Page<void> {
  const SpyRulesScreen({super.key});

  static const routePath = 'spyRules';

  @override
  Route<void> createRoute(BuildContext context) {
    return buildAppBottomSheet<void>(
      context: context,
      settings: this,
      child: FullBottomSheet(
        titleBuilder: (context) => context.l10n.game_rules,
        child: const _SpyRulesScreenBody(),
      ),
    );
  }
}

class _SpyRulesScreenBody extends StatelessWidget {
  const _SpyRulesScreenBody();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.8,
      child: Column(
        children: [
          height30,
          Expanded(
            child: _RuleList(
              rules: [
                l10n.spyRule1,
                l10n.spyRule2,
                l10n.spyRule3,
                l10n.spyRule4,
                l10n.spyRule5,
                l10n.spyRule6,
              ],
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
