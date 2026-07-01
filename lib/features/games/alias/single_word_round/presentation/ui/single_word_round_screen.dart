import 'dart:async';
import 'dart:math' as math;

import 'package:audioplayers/audioplayers.dart';
import 'package:bardak/core/app_ui/widgets/app_button/app_button.dart';
import 'package:bardak/core/app_ui/widgets/flip_card.dart';
import 'package:bardak/core/app_ui/widgets/round_header.dart';
import 'package:bardak/core/app_ui/widgets/screen_background.dart';
import 'package:bardak/core/app_ui/widgets/show_points_badge.dart';
import 'package:bardak/core/extensions/context_extension.dart';
import 'package:bardak/core/extensions/state_extension.dart';
import 'package:bardak/core/generated/assets/assets.gen.dart';
import 'package:bardak/features/games/alias/game_session/presentation/bloc/game_session_bloc/game_session_bloc.dart';
import 'package:bardak/features/games/alias/game_session/presentation/ui/round_overview_screen.dart';
import 'package:bardak/features/games/alias/single_word_round/presentation/bloc/single_word_round_bloc/single_word_round_bloc.dart';
import 'package:bardak/features/games/alias/single_word_round/presentation/ui/single_word_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SingleWordRoundScreen extends StatefulWidget {
  const SingleWordRoundScreen({super.key});

  static const routePath = 'single_word_round';

  @override
  State<SingleWordRoundScreen> createState() => _SingleWordRoundScreenState();
}

class _SingleWordRoundScreenState extends State<SingleWordRoundScreen>
    with TickerProviderStateMixin {
  late AnimationController _wordAnimationController;

  double _signedSwipeProgress = 0;

  var _isPaused = false;

  late final AudioPlayer _audioPlayer;
  final _roundHeaderKey = GlobalKey<RoundHeaderState>();

  void _resumeFromPause() {
    setState(() => _isPaused = false);
    _roundHeaderKey.currentState?.resume();
  }

  @override
  void initState() {
    super.initState();
    _wordAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _audioPlayer = AudioPlayer();
    unawaited(_audioPlayer.setPlayerMode(PlayerMode.lowLatency));
  }

  @override
  void dispose() {
    _wordAnimationController.dispose();
    unawaited(_audioPlayer.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final bloc = context.watch<SingleWordRoundBloc>();
    final roundState = bloc.state;

    const fullAt = 0.4;
    final t = (_signedSwipeProgress.abs() / fullAt).clamp(0.0, 1.0);

    final passColor = (_signedSwipeProgress < 0 && roundState.allowSkipping)
        ? Color.lerp(colors.white30, colors.red, t)! // <-- use your "red" color
        : colors.white30;

    final correctColor = (_signedSwipeProgress > 0)
        ? Color.lerp(colors.white30, colors.green, t)!
        : colors.white30;

    return BlocListener<SingleWordRoundBloc, SingleWordRoundState>(
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
        child: GradientBackground(
          child: Column(
            children: [
              SafeArea(
                child: RoundHeader(
                  key: _roundHeaderKey,
                  initialRoundDuration: roundState.roundDuration,
                  isSoundEnabled: roundState.soundsEnabled,
                  onRoundComplete: () {
                    context.read<SingleWordRoundBloc>().add(
                      const CompleteRoundRequested(),
                    );
                  },
                  onPauseChanged: (isPaused) => setState(() {
                    _isPaused = isPaused;
                  }),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const .symmetric(horizontal: 4),
                  child: Stack(
                    children: [
                      Center(
                        child: _SwipeableSingleWordCard(
                          key: ValueKey(roundState.index),
                          word: roundState.words[roundState.index],
                          allowSkipping: roundState.allowSkipping,
                          onResume: _resumeFromPause,
                          onGuessed: () {
                            unawaited(
                              _audioPlayer.play(
                                AssetSource(Assets.sounds.check),
                              ),
                            );

                            setState(() {
                              _signedSwipeProgress = 0.0;
                            });
                            bloc.add(
                              const ResolveCurrentWord(
                                WordResolution.guessed,
                              ),
                            );
                            unawaited(
                              showPointsBadge(context, points: '+1'),
                            );
                          },
                          onSkipped: () {
                            unawaited(
                              _audioPlayer.play(
                                AssetSource(Assets.sounds.uncheck),
                              ),
                            );

                            setState(() {
                              _signedSwipeProgress = 0.0;
                            });
                            bloc.add(
                              const ResolveCurrentWord(
                                WordResolution.skipped,
                              ),
                            );
                            unawaited(
                              showPointsBadge(context, points: '-1'),
                            );
                          },
                          onSwipeProgressChanged: (progress) {
                            setState(
                              () => _signedSwipeProgress = progress,
                            );
                          },
                          isFlipped: _isPaused,
                        ),
                      ),
                      if (roundState.allowSkipping)
                        Align(
                          alignment: .centerStart,
                          child: RotatedBox(
                            quarterTurns: 3,
                            child: AnimatedDefaultTextStyle(
                              duration: const Duration(milliseconds: 80),
                              curve: Curves.easeOut,
                              style: typography.regular20.copyWith(
                                color: passColor,
                              ),
                              child: Text(l10n.skip),
                            ),
                          ),
                        ),
                      Align(
                        alignment: .centerEnd,
                        child: RotatedBox(
                          quarterTurns: 3,
                          child: AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 80),
                            curve: Curves.easeOut,
                            style: typography.regular20.copyWith(
                              color: correctColor,
                            ),
                            child: Text(l10n.correct),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 200,
                child: ShadowBackground(
                  child: Align(
                    alignment: .bottomCenter,
                    child: Builder(
                      builder: (context) {
                        if (!_isPaused) {
                          return Padding(
                            padding: const .all(20),
                            child: Row(
                              spacing: 20,
                              children: [
                                if (roundState.allowSkipping)
                                  Expanded(
                                    child: AppButton(
                                      label: l10n.skip,
                                      color: colors.white20,
                                      onPressed: () {
                                        unawaited(
                                          _audioPlayer.play(
                                            AssetSource(Assets.sounds.uncheck),
                                          ),
                                        );

                                        bloc.add(
                                          const ResolveCurrentWord(
                                            WordResolution.skipped,
                                          ),
                                        );

                                        unawaited(
                                          showPointsBadge(
                                            context,
                                            points: '-1',
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                Expanded(
                                  child: AppButton(
                                    label: l10n.correct,
                                    color: colors.green,
                                    onPressed: () {
                                      unawaited(
                                        _audioPlayer.play(
                                          AssetSource(Assets.sounds.check),
                                        ),
                                      );

                                      bloc.add(
                                        const ResolveCurrentWord(
                                          WordResolution.guessed,
                                        ),
                                      );

                                      unawaited(
                                        showPointsBadge(context, points: '+1'),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                        // TODO(Gevorg): handle height adjustment when buttons shouldn't be shown
                        else {
                          return const Padding(
                            padding: .all(20),
                            child: SizedBox(
                              height: 60,
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SwipeableSingleWordCard extends StatefulWidget {
  const _SwipeableSingleWordCard({
    required super.key,
    required this.word,
    required this.allowSkipping,
    required this.onGuessed,
    required this.onSkipped,
    required this.onSwipeProgressChanged,
    required this.isFlipped,
    required this.onResume,
  });

  final String word;
  final bool allowSkipping;
  final VoidCallback onGuessed;
  final VoidCallback onSkipped;
  final ValueChanged<double> onSwipeProgressChanged;
  final bool isFlipped;
  final VoidCallback onResume;

  @override
  State<_SwipeableSingleWordCard> createState() =>
      _SwipeableSingleWordCardState();
}

class _SwipeableSingleWordCardState extends State<_SwipeableSingleWordCard> {
  static const _maxAngleDeg = 10.25;
  static const double _maxAngleRad = _maxAngleDeg * math.pi / 180.0;
  static const _fullAtProgress = 0.4; // <-- full tilt here
  var _angle = 0.0;

  @override
  Widget build(BuildContext context) {
    final direction = widget.allowSkipping
        ? DismissDirection.horizontal
        : DismissDirection.startToEnd; // only right

    return Dismissible(
      key: widget.key!,
      direction: widget.isFlipped ? DismissDirection.none : direction,
      onDismissed: (d) {
        // reset label colors immediately
        widget.onSwipeProgressChanged(0);

        if (d == DismissDirection.startToEnd) {
          widget.onGuessed();
        } else if (d == DismissDirection.endToStart) {
          if (!widget.allowSkipping) return;
          widget.onSkipped();
        }
      },

      confirmDismiss: (d) async {
        if (d == DismissDirection.startToEnd) return true;
        if (d == DismissDirection.endToStart) return widget.allowSkipping;
        return false;
      },
      movementDuration: const Duration(milliseconds: 220),
      resizeDuration: const Duration(milliseconds: 120),
      onUpdate: (details) {
        // normalize so that 0.4 => 1.0
        final t = (details.progress / _fullAtProgress).clamp(0.0, 1.0);

        // make it feel nicer (optional)
        final curvedT = Curves.easeOut.transform(t);

        // sign: right swipe +, left swipe -
        final sign = (details.direction == DismissDirection.endToStart)
            ? -1.0
            : 1.0;

        setState(() {
          _angle = sign * _maxAngleRad * curvedT;
          // or: _angle = sign * (lerpDouble(0, _maxAngleRad, curvedT) ?? 0);
        });

        widget.onSwipeProgressChanged(sign * details.progress);
      },

      child: FlipCard(
        isFlipped: widget.isFlipped,
        front: SingleWordCard(
          word: widget.word,
          angle: _angle,
        ),
        back: SingleWordCardBack(onTap: widget.onResume),
      ),
    );
  }
}
