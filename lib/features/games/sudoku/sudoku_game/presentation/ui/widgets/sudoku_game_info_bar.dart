import 'package:bardak/core/app_ui/theme/text_styles/app_text_styles.dart';
import 'package:bardak/core/extensions/context_extension.dart';
import 'package:bardak/features/games/sudoku/sudoku_game/presentation/bloc/sudoku_bloc.dart';
import 'package:bardak/features/games/sudoku/sudoku_game/presentation/bloc/sudoku_state.dart';
import 'package:bardak/features/games/sudoku/sudoku_game/presentation/ui/sudoku_formatters.dart';
import 'package:bardak/features/games/sudoku/sudoku_settings/domain/entities/sudoku_difficulty.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Difficulty on the left, live score on the right.
class SudokuGameInfoBar extends StatelessWidget {
  const SudokuGameInfoBar({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return BlocSelector<
      SudokuBloc,
      SudokuState,
      ({SudokuDifficulty difficulty, int score})
    >(
      selector: (state) => (difficulty: state.difficulty, score: state.score),
      builder: (context, data) {
        return Row(
          mainAxisAlignment: .spaceBetween,
          children: [
            Text(
              sudokuDifficultyLabel(context, data.difficulty),
              style: context.typography.regular18.copyWith(
                color: colors.white50,
              ),
            ),
            Row(
              spacing: 6,
              children: [
                Icon(Icons.star_rounded, size: 20, color: colors.orange),
                Text(
                  '${data.score}',
                  style: context.typography.regular18.withNumericFont,
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
