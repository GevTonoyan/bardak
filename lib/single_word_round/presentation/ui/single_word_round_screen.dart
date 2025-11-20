import 'package:boardify/utils/extensions/state_extension.dart';
import 'package:boardify/app_ui/widgets/round_header.dart';
import 'package:boardify/game_session/domain/entities/card_round_result.dart';
import 'package:boardify/single_word_round/presentation/bloc/single_word_round_bloc/single_word_round_bloc.dart';
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
        child: Scaffold(
          body: SafeArea(
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

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: colors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: colors.primary, width: 2),
                  ),
                  child: Row(
                    spacing: 8,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.star, color: colors.primary, size: 20),
                      Text(
                        'Score: ${roundState.score}',
                        style: typography.titleMedium.copyWith(
                          color: colors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: Center(
                    child: Container(
                      margin: const EdgeInsets.all(24),
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: colors.surface,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: colors.shadow,
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: 24,
                        children: [
                          SizedBox(
                            height: 90,
                            child: AnimatedBuilder(
                              animation: _wordAnimationController,
                              builder: (context, child) {
                                return Transform.scale(
                                  scale:
                                      1.0 +
                                      (_wordAnimationController.value * 0.1),
                                  child: Text(
                                    roundState.words[roundState.index],
                                    style: typography.displaySmall,
                                    textAlign: TextAlign.center,
                                  ),
                                );
                              },
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              if (roundState.allowSkipping)
                                _ActionButton(
                                  icon: Icons.close,
                                  color: colors.error,
                                  onPressed:
                                      () => bloc.add(
                                        const ResolveCurrentWord(
                                          WordResolution.skipped,
                                        ),
                                      ),
                                ),
                              _ActionButton(
                                icon: Icons.check,
                                color: colors.success,
                                onPressed:
                                    () => bloc.add(
                                      const ResolveCurrentWord(
                                        WordResolution.guessed,
                                      ),
                                    ),
                              ),
                            ],
                          ),
                        ],
                      ),
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

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(30),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 32),
        ),
      ),
    );
  }
}
