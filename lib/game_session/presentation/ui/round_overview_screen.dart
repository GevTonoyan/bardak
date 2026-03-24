import 'dart:async';

import 'package:alias_pro/app_ui/theme/text_styles/app_text_styles.dart';
import 'package:alias_pro/app_ui/widgets/app_button/app_button.dart';
import 'package:alias_pro/app_ui/widgets/app_icon_button.dart';
import 'package:alias_pro/app_ui/widgets/highlighted_text.dart';
import 'package:alias_pro/app_ui/widgets/screen_background.dart';
import 'package:alias_pro/app_ui/widgets/show_confirm_sheet.dart';
import 'package:alias_pro/game_session/domain/entities/game_session_entity.dart';
import 'package:alias_pro/game_session/presentation/bloc/game_session_bloc/game_session_bloc.dart';
import 'package:alias_pro/game_session/presentation/ui/countdown_screen.dart';
import 'package:alias_pro/game_session/presentation/ui/round_review_screen.dart';
import 'package:alias_pro/utils/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class RoundOverviewScreen extends StatelessWidget {
  const RoundOverviewScreen({super.key});

  static const routePath = 'roundOverview';

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;
    final typography = context.typography;
    final bloc = context.watch<GameSessionBloc>();
    final gameState = bloc.state.gameState;

    return BlocBuilder<GameSessionBloc, GameSessionState>(
      builder: (context, state) {
        return PopScope(
          canPop: false,
          child: GradientBackground(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const .only(left: 20, top: 20),
                    child: AppIconButton.close(
                      onTap: () async {
                        await showConfirmSheet(
                          context: context,
                          title: l10n.exit_game_title,
                          description: l10n.exit_game_description,
                          confirmText: l10n.exit_game_confirm,
                          cancelText: l10n.cancel,
                          confirmColor: colors.red,
                          cancelColor: colors.green,
                          onConfirm: () => context.pop(),
                        );
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsGeometry.all(30),
                  child: Align(
                    child: Column(
                      spacing: 16,
                      children: [
                        Text(
                          l10n.next_team,
                          style: typography.regular24,
                        ),
                        HighlightedText(
                          text: gameState
                              .teamStates[gameState.currentTeamIndex]
                              .name,
                        ),
                      ],
                    ),
                  ),
                ),
                const Expanded(child: _TeamScores()),
                SizedBox(
                  height: 200,
                  child: ShadowBackground(
                    child: Padding(
                      padding: const .all(20),
                      child: AppButton(
                        label: l10n.proceed,
                        color: colors.green,
                        onPressed: () => _navigateToRoundScreen(context),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _navigateToRoundScreen(BuildContext context) async {
    context.pushReplacementNamed(CountdownScreen.routePath);
  }
}

class _TeamScores extends StatelessWidget {
  const _TeamScores();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;

    final gameState = context.watch<GameSessionBloc>().state.gameState;
    final teams = gameState.teamStates;

    return Column(
      crossAxisAlignment: .start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20, bottom: 20),
          child: Text(
            context.l10n.scoreboard,
            style: typography.regular24,
          ),
        ),
        ...List.generate(teams.length, (index) {
          final teamState = teams[index];
          final bgColor = index == gameState.currentTeamIndex
              ? colors.white20
              : Colors.transparent;

          final showEditIcon = _showEditIcon(gameState, index);

          return Container(
            height: 65,
            padding: const .symmetric(horizontal: 20),
            color: bgColor,
            child: Row(
              mainAxisAlignment: .spaceBetween,
              children: [
                Text(
                  teamState.name,
                  style: typography.regular24,
                ),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: showEditIcon
                        ? () {
                            context.pushReplacementNamed(
                              RoundReviewScreen.routePath,
                            );
                          }
                        : null,
                    child: SizedBox(
                      height: 48,
                      child: Row(
                        spacing: 10,
                        children: [
                          Text(
                            teamState.totalScore.toString(),
                            style: typography.regular24.withNumericFont,
                          ),
                          if (_showEditIcon(gameState, index))
                            Icon(Icons.edit, color: colors.white, size: 24),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  bool _showEditIcon(GameSessionEntity gameState, int index) {
    final hasPendingWords = gameState.pendingReviewWords?.isNotEmpty ?? false;

    return hasPendingWords && index == gameState.previousTeamIndex;
  }
}
