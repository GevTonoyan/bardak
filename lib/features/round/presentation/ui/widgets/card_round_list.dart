import 'package:boardify/core/extensions/context_extension.dart';
import 'package:boardify/features/round/presentation/blocs/card_round_bloc/card_round_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CardRoundList extends StatefulWidget {
  const CardRoundList({super.key});

  @override
  State<CardRoundList> createState() => _CardRoundListState();
}

class _CardRoundListState extends State<CardRoundList> {
  @override
  Widget build(BuildContext context) {
    final colors = context.appTheme.colors;
    final typography = context.appTheme.typography;

    return BlocBuilder<CardRoundBloc, CardRoundState>(
      builder: (context, state) {
        final words = state.visible;
        final guessed = state.guessed;

        return ListView.separated(
          itemCount: words.length,
          separatorBuilder: (_, _) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final currentWord = words[index];
            final isSelected = guessed.contains(currentWord);

            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              transform:
                  isSelected
                      ? (Matrix4.identity()..scale(1.02))
                      : Matrix4.identity(),
              child: Material(
                color:
                    isSelected
                        ? colors.success.withValues(alpha: 0.15)
                        : colors.surface,
                elevation: isSelected ? 8 : 2,
                shadowColor: colors.shadow,
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(
                    color:
                        isSelected
                            ? colors.success
                            : colors.outline.withValues(alpha: 0.3),
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: InkWell(
                  onTap:
                      () => context.read<CardRoundBloc>().add(
                        ToggleWord(isSelected: !isSelected, word: currentWord),
                      ),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            words[index],
                            style: typography.titleLarge.copyWith(
                              color:
                                  isSelected
                                      ? colors.success
                                      : colors.onSurface,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),

                        SizedBox(
                          width: 24,
                          height: 24,
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            transitionBuilder: (child, animation) {
                              return ScaleTransition(
                                scale: animation,
                                child: FadeTransition(
                                  opacity: animation,
                                  child: child,
                                ),
                              );
                            },
                            child:
                                isSelected
                                    ? Container(
                                      key: const ValueKey(true),
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: colors.success,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.check,
                                        color: colors.onPrimary,
                                        size: 16,
                                      ),
                                    )
                                    : Container(
                                      key: const ValueKey(false),
                                      width: 24,
                                      height: 24,
                                      decoration: BoxDecoration(
                                        color: colors.outline.withValues(
                                          alpha: 0.3,
                                        ),
                                        shape: BoxShape.circle,
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
          },
        );
      },
    );
  }
}
