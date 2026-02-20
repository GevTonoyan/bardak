import 'dart:async';

import 'package:boardify/app_ui/widgets/app_button.dart';
import 'package:boardify/app_ui/widgets/app_icon_button.dart';
import 'package:boardify/app_ui/widgets/app_spacings.dart';
import 'package:boardify/app_ui/widgets/highlighted_text.dart';
import 'package:boardify/app_ui/widgets/screen_background.dart';
import 'package:boardify/app_ui/widgets/show_confirm_sheet.dart';
import 'package:boardify/game_session/presentation/bloc/game_session_bloc/game_session_bloc.dart';
import 'package:boardify/game_session/presentation/ui/countdown_screen.dart';
import 'package:boardify/game_session/presentation/ui/round_review_screen.dart';
import 'package:boardify/utils/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class RoundOverviewScreen extends StatelessWidget {
  const RoundOverviewScreen({super.key});

  static const routePath = 'roundOverview';

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;
    final bloc = context.watch<GameSessionBloc>();
    final gameState = bloc.state.gameState;

    return BlocBuilder<GameSessionBloc, GameSessionState>(
      builder: (context, state) {
        return PopScope(
          canPop: false,
          child: ScreenBackground(
            shadowHeight: 300,
            child: SafeArea(
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Padding(
                    padding: const EdgeInsetsGeometry.only(left: 20, top: 20),
                    child: AppIconButton.close(
                      onTap: () async {
                        await showConfirmSheet(
                          context: context,
                          title: 'Լքե՞լ խաղը',
                          description: 'Վստա՞հ եք որ ցանկանում եք ավարտել խաղը',
                          confirmText: 'Այո,լքել խաղը',
                          cancelText: 'Չեղարկել',
                          confirmColor: colors.red,
                          cancelColor: colors.green,
                          onConfirm: () => context.pop(),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsGeometry.all(40),
                    child: Align(
                      child: Column(
                        spacing: 16,
                        children: [
                          Text(
                            'Հաջորդ թիմը՝',
                            style: typography.regular24.copyWith(
                              color: colors.white,
                            ),
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
                  height40,
                  const Expanded(child: _TeamScores()),
                  if (state.gameState.pendingReviewWords?.isNotEmpty ??
                      false) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: AppButton(
                        label: 'Վերանայել',
                        color: colors.white20,
                        onPressed: () => context.pushReplacementNamed(
                          RoundReviewScreen.routePath,
                        ),
                      ),
                    ),
                    height20,
                  ],
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: AppButton(
                      label: 'Շարունակել',
                      color: colors.green,
                      onPressed: () => _navigateToRoundScreen(context),
                    ),
                  ),
                  height40,
                ],
              ),
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
            'Ստատիստիկա՝',
            style: typography.regular24.copyWith(color: colors.white),
          ),
        ),
        ...List.generate(teams.length, (index) {
          final teamState = teams[index];
          final bgColor = index.isEven ? colors.white20 : Colors.transparent;
          return Container(
            padding: const EdgeInsets.all(20),
            color: bgColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  teamState.name,
                  style: typography.regular24.copyWith(color: colors.white),
                ),
                Text(
                  teamState.totalScore.toString(),
                  style: typography.regular24.copyWith(
                    color: colors.white,
                    fontFamily: 'Digitalt',
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
