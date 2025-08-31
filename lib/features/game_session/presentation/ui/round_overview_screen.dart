import 'package:boardify/core/extensions/context_extension.dart';
import 'package:boardify/core/extensions/state_extension.dart';
import 'package:boardify/core/ui_kit/widgets/game_popup_dialog.dart';
import 'package:boardify/features/card_round/domain/card_round_entity.dart';
import 'package:boardify/features/card_round/presentation/ui/card_round_screen.dart';
import 'package:boardify/features/game_session/domain/entities/game_session_entity.dart';
import 'package:boardify/features/game_session/presentation/bloc/game_session_bloc/game_session_bloc.dart';
import 'package:boardify/features/pre_game/domain/entities/pre_game_entity.dart';
import 'package:boardify/features/single_word_round/domain/single_word_round_entity.dart';
import 'package:boardify/features/single_word_round/presentation/ui/single_word_round_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class RoundOverviewScreen extends StatelessWidget {
  const RoundOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appTheme.colors;
    final text = context.appTheme.typography;

    final gameState = context.watch<GameSessionBloc>().state.gameState;

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
                        context.l10n.roundOverview_teamTurn(
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
                          title: context.l10n.roundOverview_confirmExit_title,
                          message:
                              context.l10n.roundOverview_confirmExit_message,
                          confirmText: context.l10n.general_yes,
                          cancelText: context.l10n.general_no,
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
                            Expanded(
                              child: _TeamScoreCard(
                                team: gameState.teamStates[0],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _TeamScoreCard(
                                team: gameState.teamStates[1],
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (gameState.teamStates.length > 2) ...[
                        const SizedBox(height: 12),
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                child: _TeamScoreCard(
                                  team: gameState.teamStates[2],
                                ),
                              ),
                              const SizedBox(width: 12),
                              if (gameState.teamStates.length == 4) ...[
                                Expanded(
                                  child: _TeamScoreCard(
                                    team: gameState.teamStates[3],
                                  ),
                                ),
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
                    onPressed: () => _navigateToRoundScreen(context),
                    icon: const Icon(Icons.play_arrow),
                    label: Text(context.l10n.general_startGame),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _navigateToRoundScreen(BuildContext context) async {
    final gameSession = context.read<GameSessionBloc>().state.gameState;

    final (routeName, extra) = switch (gameSession.gameMode) {
      GameMode.card => (
        CardRoundScreen.routePath,
        CardRoundEntity(
          roundDuration: gameSession.roundDuration,
          wordsPerCard: gameSession.wordsPerCard,
        ),
      ),
      GameMode.singleWord => (
        SingleWordRoundScreen.routePath,
        SingleWordRoundEntity(
          roundDuration: gameSession.roundDuration,
          penaltyForSkipping: gameSession.penaltyForSkipping,
          allowSkipping: gameSession.allowSkipping,
        ),
      ),
    };

    await context.pushNamed(routeName, extra: extra);
  }
}

class _TeamScoreCard extends StatefulWidget {
  const _TeamScoreCard({required this.team});

  final AliasTeamStateEntity team;

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
    final team = widget.team;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: colors.shadow,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            team.name,
            style: typography.titleMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: colors.primary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            context.l10n.roundOverview_point(team.totalScore),
            style: typography.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            context.l10n.roundOverview_roundScores,
            style: typography.labelMedium,
          ),
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
                    '• ${context.l10n.round} ${roundIndex + 1}: '
                    '${context.l10n.roundOverview_point(roundScore)}',
                    style:
                        isLast
                            ? typography.bodySmall.copyWith(
                              color: colors.primary,
                              fontWeight: FontWeight.w600,
                            )
                            : typography.bodySmall.copyWith(
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
