import 'package:bardak/core/app_ui/widgets/app_button/app_button.dart';
import 'package:bardak/core/app_ui/widgets/app_icon_button.dart';
import 'package:bardak/core/app_ui/widgets/app_spacings.dart';
import 'package:bardak/core/app_ui/widgets/screen_background.dart';
import 'package:bardak/core/extensions/context_extension.dart';
import 'package:bardak/features/games/alias/game_session/presentation/bloc/game_session_bloc/game_session_bloc.dart';
import 'package:bardak/features/games/alias/game_session/presentation/bloc/game_session_bloc/game_session_event.dart';
import 'package:bardak/features/games/alias/game_session/presentation/bloc/round_review_bloc/round_review_bloc.dart';
import 'package:bardak/features/games/alias/game_session/presentation/bloc/round_review_bloc/round_review_event.dart';
import 'package:bardak/features/games/alias/game_session/presentation/bloc/round_review_bloc/round_review_state.dart';
import 'package:bardak/features/games/alias/game_session/presentation/ui/round_overview_screen.dart';
import 'package:bardak/features/games/alias/game_session/presentation/ui/widgets/card_review_widget.dart';
import 'package:bardak/features/games/alias/game_session/presentation/ui/widgets/single_word_review_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class RoundReviewScreen extends StatelessWidget {
  const RoundReviewScreen({super.key});

  static const routePath = 'roundReview';

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
                    padding: const .all(20),
                    child: SizedBox(
                      height: 40,
                      child: Row(
                        children: [
                          AppIconButton.close(
                            onTap: () {
                              context.pushReplacementNamed(
                                RoundOverviewScreen.routePath,
                              );
                            },
                          ),
                          Expanded(
                            child: Text(
                              context.l10n.review,
                              textAlign: .center,
                              style: context.typography.regular24,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Flexible(
                    child: switch (reviewState.gameMode) {
                      .card => CardReviewWidget(
                        pagedReviewedWords: reviewState.pagedReviewedWords,
                        guessedByPage: reviewState.guessedByPage,
                        onGuessedChanged: (newGuessed) {
                          context.read<RoundReviewBloc>().add(
                            UpdateGuessedWords(guessedWords: newGuessed),
                          );
                        },
                      ),
                      .singleWord => SingleWordReviewWidget(
                        reviewedWords: reviewState.reviewedWords,
                        onToggle: (index) {
                          context.read<RoundReviewBloc>().add(
                            ToggleWord(index: index),
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
                              FinishRoundReview(
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
