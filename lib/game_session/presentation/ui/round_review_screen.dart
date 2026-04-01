import 'package:alias_pro/app_ui/widgets/app_button/app_button.dart';
import 'package:alias_pro/app_ui/widgets/app_icon_button.dart';
import 'package:alias_pro/app_ui/widgets/app_spacings.dart';
import 'package:alias_pro/app_ui/widgets/screen_background.dart';
import 'package:alias_pro/game_session/presentation/bloc/game_session_bloc/game_session_bloc.dart';
import 'package:alias_pro/game_session/presentation/bloc/round_review_bloc/round_review_bloc.dart';
import 'package:alias_pro/game_session/presentation/ui/round_overview_screen.dart';
import 'package:alias_pro/game_session/presentation/ui/widgets/card_review_widget.dart';
import 'package:alias_pro/game_session/presentation/ui/widgets/single_word_review_widget.dart';
import 'package:alias_pro/pre_game/domain/entities/pre_game_entity.dart';
import 'package:alias_pro/utils/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class RoundReviewScreen extends StatelessWidget {
  const RoundReviewScreen({super.key});

  static const routePath = 'round_review';

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return PopScope(
      canPop: false,
      child: GradientBackground(
        child: SafeArea(
          bottom: false,
          child: BlocBuilder<RoundReviewBloc, RoundReviewState>(
            builder: (context, reviewState) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: AppIconButton.close(
                      onTap: () {
                        context.pushReplacementNamed(
                          RoundOverviewScreen.routePath,
                        );
                      },
                    ),
                  ),
                  Flexible(
                    child: switch (reviewState.gameMode) {
                      GameMode.card => CardReviewWidget(
                        pagedReviewedWords: reviewState.pagedReviewedWords,
                        guessedByPage: reviewState.guessedByPage,
                        onGuessedChanged: (newGuessed) {
                          context.read<RoundReviewBloc>().add(
                            GuessedWordsUpdated(guessedWords: newGuessed),
                          );
                        },
                      ),
                      GameMode.singleWord => SingleWordReviewWidget(
                        reviewedWords: reviewState.reviewedWords,
                        onToggle: (index) {
                          context.read<RoundReviewBloc>().add(
                            WordToggled(index: index),
                          );
                        },
                      ),
                    },
                  ),
                  height20,
                  SizedBox(
                    height: 200,
                    child: ShadowBackground(
                      child: Padding(
                        padding: const .all(20),
                        child: AppButton(
                          label: context.l10n.proceed,
                          color: colors.green,
                          onPressed: () {
                            context.read<GameSessionBloc>().add(
                              RoundReviewFinished(
                                reviewedWords: reviewState.reviewedWords,
                              ),
                            );
                            context.pushReplacementNamed(
                              RoundOverviewScreen.routePath,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
