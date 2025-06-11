import 'package:alias/core/alias_route.dart';
import 'package:alias/features/feature_gameplay/domain/entities/alias_game_state_entity.dart';
import 'package:alias/features/feature_gameplay/presentation/bloc/blocs/alias_gameplay_bloc/alias_gameplay_bloc.dart';
import 'package:app_core/ui_kit/widgets/app_loader.dart';
import 'package:app_core/ui_kit/widgets/game_popup_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:app_core/extensions/context_extension.dart';

class AliasRoundOverviewScreen extends StatelessWidget {
  const AliasRoundOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appTheme.colors;
    final text = context.appTheme.typography;

    final bloc = context.watch<AliasGameplayBloc>();
    if (bloc.state is! AliasPlayLoaded) {
      return const AppLoader();
    }

    final gameState = (bloc.state as AliasPlayLoaded).gameState;

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: colors.background,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        context.localizations.alias_roundOverview_teamTurn(
                          gameState.teamStates[gameState.currentTeamIndex].name,
                        ),
                        style: text.titleLarge.copyWith(
                          color: colors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      color: colors.onBackground,
                      onPressed: () {
                        showGamePopupDialog(
                          context: context,
                          title: context.localizations.alias_roundOverview_confirmExit_title,
                          message: context.localizations.alias_roundOverview_confirmExit_message,
                          confirmText: context.localizations.general_yes,
                          cancelText: context.localizations.general_no,
                          onConfirm: () => context.pop(),
                        );
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Team Score Cards
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(child: _TeamScoreCard(team: gameState.teamStates[0])),
                            const SizedBox(width: 12),
                            Expanded(child: _TeamScoreCard(team: gameState.teamStates[1])),
                          ],
                        ),
                      ),
                      if (gameState.teamStates.length > 2) ...[
                        const SizedBox(height: 12),
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(child: _TeamScoreCard(team: gameState.teamStates[2])),
                              const SizedBox(width: 12),
                              if (gameState.teamStates.length == 4) ...[
                                Expanded(child: _TeamScoreCard(team: gameState.teamStates[3])),
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
                    onPressed: () => context.pushNamed(AliasRouteNames.countdown),
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

class _TeamScoreCard extends StatefulWidget {
  final AliasTeamStateEntity team;

  const _TeamScoreCard({required this.team});

  @override
  State<_TeamScoreCard> createState() => _TeamScoreCardState();
}

class _TeamScoreCardState extends State<_TeamScoreCard> {
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
    final colors = context.appTheme.colors;
    final text = context.appTheme.typography;

    final team = widget.team;

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
            team.name,
            style: text.titleMedium.copyWith(fontWeight: FontWeight.w600, color: colors.primary),
          ),
          const SizedBox(height: 4),
          Text(
            context.localizations.alias_roundOverview_point(team.totalScore),
            style: text.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(context.localizations.alias_roundOverview_roundScores, style: text.labelMedium),
          const SizedBox(height: 4),
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              itemCount: team.roundScores.length,
              itemBuilder: (_, roundIndex) {
                final roundScore = team.roundScores[roundIndex];
                final isLast = roundIndex == team.roundScores.length - 1;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: Text(
                    '• ${context.localizations.alias_round} ${roundIndex + 1}: '
                    '${context.localizations.alias_roundOverview_point(roundScore)}',
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
