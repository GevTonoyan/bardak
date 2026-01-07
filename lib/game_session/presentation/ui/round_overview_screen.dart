import 'package:boardify/app_ui/widgets/app_button.dart';
import 'package:boardify/app_ui/widgets/app_icon_button.dart';
import 'package:boardify/app_ui/widgets/app_spacings.dart';
import 'package:boardify/app_ui/widgets/screen_background.dart';
import 'package:boardify/app_ui/widgets/show_confirm_sheet.dart';
import 'package:boardify/card_round/domain/card_round_entity.dart';
import 'package:boardify/card_round/presentation/ui/card_round_screen.dart';
import 'package:boardify/game_session/domain/entities/card_round_result.dart';
import 'package:boardify/game_session/domain/entities/game_session_entity.dart';
import 'package:boardify/game_session/presentation/bloc/game_session_bloc/game_session_bloc.dart';
import 'package:boardify/game_session/presentation/ui/game_summary_screen.dart';
import 'package:boardify/pre_game/domain/entities/pre_game_entity.dart';
import 'package:boardify/single_word_round/domain/single_word_round_entity.dart';
import 'package:boardify/single_word_round/presentation/ui/single_word_round_screen.dart';
import 'package:boardify/utils/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class RoundOverviewScreen extends StatelessWidget {
  const RoundOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;
    final gameState = context.watch<GameSessionBloc>().state.gameState;

    return BlocListener<GameSessionBloc, GameSessionState>(
      listener: (BuildContext context, GameSessionState state) {
        if (state.gameState.isGameFinished) {
          context.goNamed(
            GameSummaryScreen.routePath,
            extra: state.gameState.teamStates,
          );
        }
      },
      child: PopScope(
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
                        cancelText: 'Այո,լքել խաղը',
                        confirmText: 'Չեղարկել',
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
                        Container(
                          padding: const .all(16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: colors.secondary,
                          ),
                          child: Text(
                            gameState
                                .teamStates[gameState.currentTeamIndex]
                                .name,
                            style: typography.regular28.copyWith(
                              color: colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                height40,
                const Expanded(child: _TeamScores()),
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
      ),
    );
  }

  Future<void> _navigateToRoundScreen(BuildContext context) async {
    final gameSessionBloc = context.read<GameSessionBloc>();
    final gameState = gameSessionBloc.state.gameState;

    switch (gameState.gameMode) {
      case GameMode.card:
        await _navigateToCardRound(context, gameState);
      case GameMode.singleWord:
        await _navigateToSingleWordRound(context, gameState);
    }
  }

  Future<void> _navigateToCardRound(
    BuildContext context,
    GameSessionEntity gameState,
  ) async {
    final cardRoundEntity = CardRoundEntity(
      roundDuration: gameState.roundDuration,
      wordsPerCard: gameState.wordsPerCard,
      words: gameState.words,
    );

    final roundResult =
        await context.pushNamed(
              CardRoundScreen.routePath,
              extra: cardRoundEntity,
            )
            as RoundResult?;

    if (roundResult != null && context.mounted) {
      context.read<GameSessionBloc>().add(
        RoundEnded(
          guessedCount: roundResult.guessedCount,
          wordsShown: roundResult.seenWordsCount,
        ),
      );
    }
  }

  Future<void> _navigateToSingleWordRound(
    BuildContext context,
    GameSessionEntity gameState,
  ) async {
    final singleWordRoundEntity = SingleWordRoundEntity(
      words: gameState.words,
      roundDuration: gameState.roundDuration,
      penaltyForSkipping: gameState.penaltyForSkipping,
      allowSkipping: gameState.allowSkipping,
    );

    final roundResult =
        await context.pushNamed(
              SingleWordRoundScreen.routePath,
              extra: singleWordRoundEntity,
            )
            as RoundResult?;

    if (roundResult != null && context.mounted) {
      context.read<GameSessionBloc>().add(
        RoundEnded(
          guessedCount: roundResult.guessedCount,
          wordsShown: roundResult.seenWordsCount,
        ),
      );
    }
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
