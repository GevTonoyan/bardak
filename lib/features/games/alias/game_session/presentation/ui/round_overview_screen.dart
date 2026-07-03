import 'dart:async';

import 'package:bardak/core/app_ui/theme/text_styles/app_text_styles.dart';
import 'package:bardak/core/app_ui/widgets/app_button/app_button.dart';
import 'package:bardak/core/app_ui/widgets/app_icon_button.dart';
import 'package:bardak/core/app_ui/widgets/app_notification.dart';
import 'package:bardak/core/app_ui/widgets/highlighted_text.dart';
import 'package:bardak/core/app_ui/widgets/screen_background.dart';
import 'package:bardak/core/app_ui/widgets/show_confirm_sheet.dart';
import 'package:bardak/core/extensions/context_extension.dart';
import 'package:bardak/features/games/alias/game_session/domain/entities/game_session_entity.dart';
import 'package:bardak/features/games/alias/game_session/presentation/bloc/game_session_bloc/game_session_bloc.dart';
import 'package:bardak/features/games/alias/game_session/presentation/ui/countdown_screen.dart';
import 'package:bardak/features/games/alias/game_session/presentation/ui/round_review_screen.dart';
import 'package:bardak/features/games/alias/game_settings/domain/entities/game_mode.dart';
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
    final state = bloc.state;
    final gameState = state.gameState;

    return GradientBackground(
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
            padding: const .all(30),
            child: Align(
              child: Column(
                spacing: 16,
                children: [
                  Text(
                    l10n.next_team,
                    style: typography.regular24,
                  ),
                  HighlightedText(
                    text: gameState.teamStates[gameState.currentTeamIndex].name,
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
                  onPressed: () {
                    if (state.gameState.words.isEmpty) {
                      unawaited(
                        showAppNotification(
                          context,
                          message: l10n.no_words_left_error,
                          icon: Icon(Icons.info, color: colors.white),
                        ),
                      );
                    } else {
                      context.pushReplacementNamed(
                        CountdownScreen.routePath,
                      );
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TeamScores extends StatelessWidget {
  const _TeamScores();

  static const _scoreboardWidth = 83.0;

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
          padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
          child: Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              Text(
                context.l10n.teams,
                style: typography.regular18.copyWith(color: colors.white50),
              ),
              SizedBox(
                width: _scoreboardWidth,
                child: Text(
                  context.l10n.scoreboard,
                  style: typography.regular18.copyWith(color: colors.white50),
                ),
              ),
            ],
          ),
        ),
        Divider(height: 1, color: colors.white50),
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
                SizedBox(
                  width: _scoreboardWidth,
                  child: Material(
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
                              _TickingEditIcon(color: colors.white),
                          ],
                        ),
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
    // TODO(Gevorg): Come up with correct review logic for one word mode
    if (gameState.gameMode == GameMode.singleWord) {
      return false;
    }

    final hasPendingWords = gameState.pendingReviewWords?.isNotEmpty ?? false;

    return hasPendingWords && index == gameState.previousTeamIndex;
  }
}

class _TickingEditIcon extends StatefulWidget {
  const _TickingEditIcon({required this.color});

  final Color color;

  @override
  State<_TickingEditIcon> createState() => _TickingEditIconState();
}

class _TickingEditIconState extends State<_TickingEditIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true); // Loops the animation back and forth

    _scaleAnimation = Tween<double>(begin: 1, end: 1.3).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Icon(Icons.edit, color: widget.color, size: 24),
    );
  }
}
