import 'package:boardify/app_ui/widgets/round_header.dart';
import 'package:boardify/app_ui/widgets/screen_background.dart';
import 'package:boardify/card_round/presentation/bloc/card_round_bloc/card_round_bloc.dart';
import 'package:boardify/card_round/presentation/ui/widgets/multiple_words_card.dart';
import 'package:boardify/game_session/presentation/bloc/game_session_bloc/game_session_bloc.dart';
import 'package:boardify/game_session/presentation/ui/round_overview_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CardRoundScreen extends StatelessWidget {
  const CardRoundScreen({required this.initialRoundDuration, super.key});

  static const routePath = 'card_round';

  final int initialRoundDuration;

  @override
  Widget build(BuildContext context) {
    return BlocListener<CardRoundBloc, CardRoundState>(
      listener: (context, state) {
        if (state.completed) {
          final reviewedWords = state.wordsToReview();
          context.read<GameSessionBloc>().add(
            RoundFinished(reviewedWords: reviewedWords),
          );

          context.pushReplacementNamed(RoundOverviewScreen.routePath);
        }
      },
      child: PopScope(
        canPop: false,
        child: ScreenBackground(
          shadowHeight: 200,
          child: SafeArea(
            child: Column(
              children: [
                RoundHeader(
                  initialRoundDuration: initialRoundDuration,
                  onRoundComplete: () {
                    context.read<CardRoundBloc>().add(
                      const CompleteRoundRequested(),
                    );
                  },
                ),

                const Expanded(
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40),
                      child: MultipleWordsCard(),
                    ),
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
