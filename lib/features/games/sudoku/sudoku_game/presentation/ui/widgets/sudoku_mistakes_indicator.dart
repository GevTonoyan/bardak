import 'dart:math';

import 'package:bardak/core/extensions/context_extension.dart';
import 'package:bardak/features/games/sudoku/sudoku_game/presentation/bloc/sudoku_bloc.dart';
import 'package:bardak/features/games/sudoku/sudoku_game/presentation/bloc/sudoku_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// The player's remaining lives as hearts in a glass pill. Losing one
/// shakes the pill and breaks the heart so the mistake registers at a
/// glance.
class SudokuMistakesIndicator extends StatelessWidget {
  const SudokuMistakesIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<SudokuBloc, SudokuState, int>(
      selector: (state) => state.mistakes,
      builder: (context, mistakes) {
        final colors = context.colors;
        final lives = SudokuState.maxMistakes - mistakes;

        // Keyed by the mistake count: each lost life restarts the shake,
        // which decays as the tween runs 1 -> 0.
        return TweenAnimationBuilder<double>(
          key: ValueKey('sudoku_lives_$mistakes'),
          tween: Tween(begin: mistakes == 0 ? 0.0 : 1.0, end: 0),
          duration: const Duration(milliseconds: 700),
          builder: (context, t, child) => Transform.translate(
            offset: Offset(sin(t * pi * 5) * 6 * t, 0),
            child: Transform.scale(scale: 1 + t * 0.15, child: child),
          ),
          child: Container(
            padding: const .symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: colors.white10,
              borderRadius: .circular(20),
              border: Border.all(color: colors.white30, width: 0.5),
            ),
            child: Row(
              mainAxisSize: .min,
              spacing: 4,
              children: [
                for (var i = 0; i < SudokuState.maxMistakes; i++)
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 350),
                    switchInCurve: Curves.easeOutBack,
                    transitionBuilder: (child, animation) =>
                        ScaleTransition(scale: animation, child: child),
                    child: i < lives
                        ? Icon(
                            Icons.favorite_rounded,
                            key: ValueKey('sudoku_heart_full_$i'),
                            size: 18,
                            color: colors.red,
                          )
                        : Icon(
                            Icons.heart_broken_rounded,
                            key: ValueKey('sudoku_heart_broken_$i'),
                            size: 18,
                            color: colors.white30,
                          ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
