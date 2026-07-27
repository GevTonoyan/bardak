import 'package:bardak/core/extensions/context_extension.dart';
import 'package:bardak/features/games/sudoku/sudoku_game/presentation/bloc/sudoku_bloc.dart';
import 'package:bardak/features/games/sudoku/sudoku_game/presentation/bloc/sudoku_state.dart';
import 'package:bardak/features/games/sudoku/sudoku_game/presentation/ui/sudoku_formatters.dart';
import 'package:bardak/features/games/sudoku/sudoku_settings/domain/entities/sudoku_difficulty.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// The difficulty of the current puzzle and the best time to beat on it.
class SudokuGameInfoBar extends StatelessWidget {
  const SudokuGameInfoBar({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final style = context.typography.regular18.copyWith(color: colors.white50);

    return BlocSelector<SudokuBloc, SudokuState, (SudokuDifficulty, int?)>(
      selector: (state) => (state.difficulty, state.bestTimeSeconds),
      builder: (context, data) {
        final (difficulty, bestTime) = data;
        // A dash keeps the label present before the first win, so the row
        // never reflows once a best time is set.
        final bestValue = bestTime == null
            ? '—'
            : formatSudokuTime(bestTime);

        return Row(
          children: [
            Expanded(
              child: Text(
                sudokuDifficultyLabel(context, difficulty),
                style: style,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            Text('${l10n.sudoku_best_time}: $bestValue', style: style),
          ],
        );
      },
    );
  }
}
