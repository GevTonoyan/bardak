import 'package:boardify/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';

class AliasRulesScreen extends StatelessWidget {
  const AliasRulesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    final colors = theme.colors;
    final typography = theme.typography;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            context.l10n.alias_rulesTitle,
            style: typography.titleLarge,
          ),
          bottom: TabBar(
            indicatorColor: colors.primary,
            labelColor: colors.primary,
            unselectedLabelColor: colors.onSurface.withValues(alpha: 0.6),
            tabs: [
              Tab(text: context.l10n.alias_mode1),
              Tab(text: context.l10n.alias_mode2),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _RuleList(
              rules: [
                context.l10n.alias_singleModeRule1,
                context.l10n.alias_singleModeRule2,
                context.l10n.alias_singleModeRule3,
                context.l10n.alias_singleModeRule4,
                context.l10n.alias_singleModeRule5,
                context.l10n.alias_singleModeRule6,
              ],
            ),
            _RuleList(
              rules: [
                context.l10n.alias_cardModeRule1,
                context.l10n.alias_cardModeRule2,
                context.l10n.alias_cardModeRule3,
                context.l10n.alias_cardModeRule4,
                context.l10n.alias_cardModeRule5,
                context.l10n.alias_cardModeRule6,
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _RuleList extends StatelessWidget {
  const _RuleList({required this.rules});

  final List<String> rules;

  @override
  Widget build(BuildContext context) {
    final text = context.appTheme.typography;
    final colors = context.appTheme.colors;

    return ListView.separated(
      padding: const EdgeInsets.all(24),
      itemCount: rules.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return Container(
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: colors.shadow.withValues(alpha: 0.08),
                offset: const Offset(0, 2),
                blurRadius: 6,
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(_emojiBullet(index), style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  rules[index],
                  style: text.bodyMedium.copyWith(color: colors.onSurface),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _emojiBullet(int index) {
    const bullets = ['🎯', '⏱', '🚫', '🎤', '✅', '⚠️'];
    return index < bullets.length ? bullets[index] : '👉';
  }
}
