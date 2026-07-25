import 'package:bardak/core/extensions/context_extension.dart';
import 'package:bardak/features/games/sudoku/sudoku_game/presentation/bloc/sudoku_bloc.dart';
import 'package:bardak/features/games/sudoku/sudoku_game/presentation/bloc/sudoku_state.dart';
import 'package:bardak/features/games/sudoku/sudoku_game/presentation/ui/sudoku_formatters.dart';
import 'package:bardak/features/games/sudoku/sudoku_settings/domain/entities/sudoku_difficulty.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// The difficulty the current puzzle is being played on.
class SudokuGameInfoBar extends StatelessWidget {
  const SudokuGameInfoBar({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return BlocSelector<SudokuBloc, SudokuState, SudokuDifficulty>(
      selector: (state) => state.difficulty,
      builder: (context, difficulty) {
        return Row(
          children: [
            Text(
              sudokuDifficultyLabel(context, difficulty),
              style: context.typography.regular18.copyWith(
                color: colors.white50,
              ),
            ),
          ],
        );
      },
    );
  }
}
