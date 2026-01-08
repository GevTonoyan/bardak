import 'package:boardify/app_ui/widgets/app_button.dart';
import 'package:boardify/app_ui/widgets/round_header.dart';
import 'package:boardify/app_ui/widgets/screen_background.dart';
import 'package:boardify/assets/assets.gen.dart';
import 'package:boardify/game_session/domain/entities/card_round_result.dart';
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

    return BlocListener<SingleWordRoundBloc, SingleWordRoundState>(
      listener: (context, state) {
        if (state.completed) {
          context.pop(
            RoundResult(
              guessedCount: state.score,
              seenWordsCount: state.index + 1,
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
                      mainAxisAlignment: .spaceBetween,
                      children: [
                        RotatedBox(
                          quarterTurns: 3,
                          child: Text(
                            'Փաս',
                            style: typography.regular20.copyWith(
                              color: colors.white30,
                            ),
                          ),
                        ),
                        Center(
                          child: SingleWordCard(
                            word: roundState.words[roundState.index],
                          ),
                        ),
                        RotatedBox(
                          quarterTurns: 3,
                          child: Text(
                            '️Ճիշտ է',
                            style: typography.regular20.copyWith(
                              color: colors.white30,
                            ),
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
                                onPressed: () => bloc.add(
                                  const ResolveCurrentWord(
                                    WordResolution.skipped,
                                  ),
                                ),
                              ),
                            ),
                          Expanded(
                            child: AppButton(
                              label: '️Ճիշտ է',
                              icon: Assets.check.svg(width: 22, height: 22),
                              color: colors.green,
                              onPressed: () => bloc.add(
                                const ResolveCurrentWord(
                                  WordResolution.guessed,
                                ),
                              ),
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
