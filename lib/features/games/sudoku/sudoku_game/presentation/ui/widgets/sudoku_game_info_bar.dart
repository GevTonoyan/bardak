import 'package:bardak/core/extensions/context_extension.dart';
import 'package:bardak/features/games/sudoku/sudoku_game/presentation/bloc/sudoku_bloc.dart';
import 'package:bardak/features/games/sudoku/sudoku_game/presentation/bloc/sudoku_state.dart';
import 'package:bardak/features/games/sudoku/sudoku_game/presentation/ui/sudoku_formatters.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// The mode of the current puzzle (difficulty on 9×9, the dimension on 4×4)
/// and the best time to beat on it.
class SudokuGameInfoBar extends StatelessWidget {
  const SudokuGameInfoBar({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final style = context.typography.regular18.copyWith(color: colors.white50);

    return BlocSelector<SudokuBloc, SudokuState, (String, int?)>(
      selector: (state) => (_modeLabel(context, state), state.bestTimeSeconds),
      builder: (context, data) {
        final (modeLabel, bestTime) = data;
        final bestValue = bestTime == null
            ? '—'
            : formatSudokuTime(bestTime);

        return Row(
          children: [
            Expanded(
              child: Text(
                modeLabel,
                style: style,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            // A trophy icon replaces the "best time" label, so no translated
            // word can push the row into an overflow on small screens.
            Icon(Icons.emoji_events_outlined, size: 18, color: colors.white50),
            const SizedBox(width: 4),
            Text(bestValue, style: style),
          ],
        );
      },
    );
  }

  /// The difficulty name on the classic board; sizes without a difficulty
  /// (the 4×4 kids board) show no mode label.
  String _modeLabel(BuildContext context, SudokuState state) {
    return state.boardSize.usesDifficulty
        ? sudokuDifficultyLabel(context, state.difficulty)
        : '';
  }
}
