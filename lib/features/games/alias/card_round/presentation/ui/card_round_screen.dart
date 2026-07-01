import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:bardak/core/app_ui/widgets/flip_card.dart';
import 'package:bardak/core/app_ui/widgets/round_header.dart';
import 'package:bardak/core/app_ui/widgets/screen_background.dart';
import 'package:bardak/core/generated/assets/assets.gen.dart';
import 'package:bardak/features/games/alias/card_round/presentation/bloc/card_round_bloc/card_round_bloc.dart';
import 'package:bardak/features/games/alias/card_round/presentation/ui/widgets/multiple_words_card.dart';
import 'package:bardak/features/games/alias/game_session/presentation/bloc/game_session_bloc/game_session_bloc.dart';
import 'package:bardak/features/games/alias/game_session/presentation/ui/round_overview_screen.dart';
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
  late final AudioPlayer _audioPlayer;
  final _roundHeaderKey = GlobalKey<RoundHeaderState>();

  void _resumeFromPause() {
    setState(() => _isPaused = false);
    _roundHeaderKey.currentState?.resume();
  }

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    unawaited(_audioPlayer.setPlayerMode(PlayerMode.lowLatency));
  }

  @override
  void dispose() {
    unawaited(_audioPlayer.dispose());
    super.dispose();
  }

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
          child: GradientBackground(
            child: Column(
              children: [
                SafeArea(
                  child: RoundHeader(
                    key: _roundHeaderKey,
                    initialRoundDuration: widget.initialRoundDuration,
                    isSoundEnabled: state.soundsEnabled,
                    onRoundComplete: () {
                      context.read<CardRoundBloc>().add(
                        const CompleteRoundRequested(),
                      );
                    },
                    onPauseChanged: (paused) =>
                        setState(() => _isPaused = paused),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Padding(
                      padding: const .symmetric(horizontal: 30),
                      child: FlipCard(
                        isFlipped: _isPaused,
                        front: IgnorePointer(
                          ignoring: _isPaused,
                          child: MultipleWordsCard(
                            words: bloc.state.visible,
                            guessed: state.guessed,
                            onTap: ({required selected, required word}) async {
                              bloc.add(
                                ToggleWord(
                                  isSelected: selected,
                                  word: word,
                                ),
                              );
                              if (state.soundsEnabled) {
                                final soundPath = selected
                                    ? Assets.sounds.check
                                    : Assets.sounds.uncheck;

                                await _audioPlayer.stop();
                                unawaited(
                                  _audioPlayer.play(AssetSource(soundPath)),
                                );
                              }
                            },
                          ),
                        ),
                        back: MultipleWordsCardBack(
                          onTap: _resumeFromPause,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 200,
                  child: ShadowBackground(child: SizedBox.shrink()),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
