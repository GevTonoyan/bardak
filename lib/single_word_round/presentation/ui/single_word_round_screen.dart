import 'dart:async';
import 'dart:math' as math;

import 'package:boardify/app_ui/widgets/app_button.dart';
import 'package:boardify/app_ui/widgets/round_header.dart';
import 'package:boardify/app_ui/widgets/screen_background.dart';
import 'package:boardify/app_ui/widgets/show_points_badge.dart';
import 'package:boardify/assets/assets.gen.dart';
import 'package:boardify/game_session/domain/entities/round_result.dart';
import 'package:boardify/single_word_round/presentation/bloc/single_word_round_bloc/single_word_round_bloc.dart';
import 'package:boardify/single_word_round/presentation/ui/single_word_card.dart';
import 'package:boardify/utils/extensions/state_extension.dart';
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

  @override
  void initState() {
    super.initState();
    _wordAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _wordAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          context.pop(
            RoundResult(
              guessedCount: state.score,
              seenWordsCount: state.index + 1,
              reviewedWords: state.reviewedWords(),
            ),
          );
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
                  initialRoundDuration: roundState.roundDuration,
                  onRoundComplete: () {
                    context.read<SingleWordRoundBloc>().add(
                      const CompleteRoundRequested(),
                    );
                  },
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      children: [
                        if (roundState.allowSkipping)
                          RotatedBox(
                            quarterTurns: 3,
                            child: AnimatedDefaultTextStyle(
                              duration: const Duration(milliseconds: 80),
                              curve: Curves.easeOut,
                              style: typography.regular20.copyWith(
                                color: passColor,
                              ),
                              child: const Text('Փաս'),
                            ),
                          ),
                        Expanded(
                          child: Center(
                            child: _SwipeableSingleWordCard(
                              key: ValueKey(roundState.index),
                              word: roundState.words[roundState.index],
                              allowSkipping: roundState.allowSkipping,
                              onGuessed: () {
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
                            ),
                          ),
                        ),
                        RotatedBox(
                          quarterTurns: 3,
                          child: AnimatedDefaultTextStyle(
                            duration: const Duration(milliseconds: 80),
                            curve: Curves.easeOut,
                            style: typography.regular20.copyWith(
                              color: correctColor,
                            ),
                            child: const Text('️Ճիշտ է'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: .center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 40,
                      ),
                      child: Row(
                        spacing: 20,
                        children: [
                          if (roundState.allowSkipping)
                            Expanded(
                              child: AppButton(
                                label: 'Փաս',
                                color: colors.white20,
                                onPressed: () {
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
                              label: '️Ճիշտ է',
                              icon: Assets.check.svg(width: 22, height: 22),
                              color: colors.green,
                              onPressed: () {
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
                    ),
                  ],
                ),
              ],
            ),
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
  });

  final String word;
  final bool allowSkipping;
  final VoidCallback onGuessed;
  final VoidCallback onSkipped;
  final ValueChanged<double> onSwipeProgressChanged;

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
      direction: direction,
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

      child: SingleWordCard(
        word: widget.word,
        angle: _angle,
      ),
    );
  }
}
