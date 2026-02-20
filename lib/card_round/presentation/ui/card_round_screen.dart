import 'package:boardify/app_ui/widgets/flip_card.dart';
import 'package:boardify/app_ui/widgets/round_header.dart';
import 'package:boardify/app_ui/widgets/screen_background.dart';
import 'package:boardify/card_round/presentation/bloc/card_round_bloc/card_round_bloc.dart';
import 'package:boardify/card_round/presentation/ui/widgets/multiple_words_card.dart';
import 'package:boardify/game_session/presentation/bloc/game_session_bloc/game_session_bloc.dart';
import 'package:boardify/game_session/presentation/ui/round_overview_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class CardRoundScreen extends StatefulWidget {
  const CardRoundScreen({required this.initialRoundDuration, super.key});

  static const routePath = 'card_round';

  final int initialRoundDuration;

  @override
  State<CardRoundScreen> createState() => _CardRoundScreenState();
}

class _CardRoundScreenState extends State<CardRoundScreen> {
  bool _isPaused = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CardRoundBloc, CardRoundState>(
      listener: (context, state) {
        if (state.completed) {
          final reviewedWords = state.wordsToReview();
          context.read<GameSessionBloc>().add(
            RoundFinished(reviewedWords: reviewedWords),
          );

          context.pushReplacementNamed(RoundOverviewScreen.routePath);
        }
      },
      builder: (context, state) {
        final bloc = context.read<CardRoundBloc>();
        final state = context.read<CardRoundBloc>().state;

        return PopScope(
          canPop: false,
          child: ScreenBackground(
            shadowHeight: 200,
            child: SafeArea(
              child: Column(
                children: [
                  RoundHeader(
                    initialRoundDuration: widget.initialRoundDuration,
                    onRoundComplete: () {
                      context.read<CardRoundBloc>().add(
                        const CompleteRoundRequested(),
                      );
                    },
                    onPauseChanged: (paused) =>
                        setState(() => _isPaused = paused),
                  ),
                  Expanded(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: AspectRatio(
                          aspectRatio: 0.8,
                          child: FlipCard(
                            isFlipped: _isPaused,
                            front: IgnorePointer(
                              ignoring: _isPaused,
                              child: MultipleWordsCard(
                                words: bloc.state.visible,
                                guessed: state.guessed,
                                onTap: ({required selected, required word}) {
                                  bloc.add(
                                    ToggleWord(
                                      isSelected: selected,
                                      word: word,
                                    ),
                                  );
                                },
                              ),
                            ),
                            back: const MultipleWordsCardBack(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
