import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:app_core/extensions/context_extension.dart';

class AliasRoundOverviewScreen extends StatelessWidget {
  const AliasRoundOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appTheme.colors;
    final text = context.appTheme.typography;

    final teams = [
      {
        'name': 'Team Alpha',
        'score': 24,
        'rounds': [4, 7, 3, 7, 23, 23, 123, 123, 23, 3, 23, 23, 23, 3, 23, 32, 32, 23, 23, 2],
      },
      {
        'name': 'Team Beta',
        'score': 21,
        'rounds': [4, 7, 3, 7, 23, 23, 123, 123, 23, 3, 23, 23, 23, 3, 23, 32, 32, 23, 23, 2],
      },
      {
        'name': 'Team Beta',
        'score': 21,
        'rounds': [4, 7, 3, 7, 23, 23, 123, 123, 23, 3, 23, 23, 23, 3, 23, 32, 32, 23, 23, 2],
      },
      {
        'name': 'Team Beta',
        'score': 21,
        'rounds': [4, 7, 3, 7, 23, 23, 123, 123, 23, 3, 23, 23, 23, 3, 23, 32, 32, 23, 23, 2],
      },
    ];

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: colors.background,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Column(
              children: [
                Text(
                  context.localizations.alias_roundOverview_teamTurn(teams[0]['name'] as String),
                  style: text.titleLarge.copyWith(
                    color: colors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),

                // Team Score Cards
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(child: TeamScoreCard()),
                            const SizedBox(width: 12),
                            Expanded(child: TeamScoreCard()),
                          ],
                        ),
                      ),
                      if (teams.length > 2) ...[
                        const SizedBox(height: 12),
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(child: TeamScoreCard()),
                              const SizedBox(width: 12),
                              if (teams.length == 4) ...[
                                Expanded(child: TeamScoreCard()),
                              ] else ...[
                                Expanded(child: Container()),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => context.goNamed('alias_gameplay'),
                    icon: const Icon(Icons.play_arrow),
                    label: Text(context.localizations.general_startGame),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TeamScoreCard extends StatefulWidget {
  const TeamScoreCard({super.key});

  @override
  State<TeamScoreCard> createState() => _TeamScoreCardState();
}

class _TeamScoreCardState extends State<TeamScoreCard> {
  final scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    });
  }

  @override
  Widget build(BuildContext context) {
    final team = {
      'name': 'Team Alpha',
      'score': 24,
      'rounds': [4, 7, 3, 7, 1, 1, 12, 32, 21, 42, 21, 234, 314, 1],
    };

    final colors = context.appTheme.colors;
    final text = context.appTheme.typography;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: colors.shadow, blurRadius: 6, offset: const Offset(0, 3))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'team 1',
            style: text.titleMedium.copyWith(fontWeight: FontWeight.w600, color: colors.primary),
          ),
          const SizedBox(height: 4),
          Text(context.localizations.alias_roundOverview_point(21), style: text.titleLarge),
          const SizedBox(height: 8),
          Text(
            context.localizations.alias_roundOverview_roundScores,
            style: text.bodySmall.copyWith(color: colors.onSurface),
          ),
          const SizedBox(height: 4),
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              itemCount: (team['rounds'] as List).length,
              itemBuilder: (_, roundIndex) {
                final roundScore = (team['rounds'] as List)[roundIndex];
                final isLast = roundIndex == (team['rounds'] as List).length - 1;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: Text(
                    '• ${context.localizations.alias_round} ${roundIndex + 1}: ${context.localizations.alias_roundOverview_point(roundScore)}',
                    style:
                        isLast
                            ? text.bodySmall.copyWith(
                              color: colors.primary,
                              fontWeight: FontWeight.w600,
                            )
                            : text.bodySmall.copyWith(
                              color: colors.onSurface.withValues(alpha: 0.7),
                            ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
