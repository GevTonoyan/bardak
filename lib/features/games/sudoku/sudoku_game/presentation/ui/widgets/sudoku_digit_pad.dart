import 'package:bardak/core/app_ui/theme/text_styles/app_text_styles.dart';
import 'package:bardak/core/app_ui/widgets/app_spacings.dart';
import 'package:bardak/core/extensions/context_extension.dart';
import 'package:bardak/features/games/sudoku/sudoku_game/domain/entities/sudoku_board_entity.dart';
import 'package:bardak/features/games/sudoku/sudoku_game/presentation/bloc/sudoku_bloc.dart';
import 'package:bardak/features/games/sudoku/sudoku_game/presentation/bloc/sudoku_event.dart';
import 'package:bardak/features/games/sudoku/sudoku_game/presentation/bloc/sudoku_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// The 1-9 keys plus the undo / erase / notes-toggle action row.
class SudokuDigitPad extends StatelessWidget {
  const SudokuDigitPad({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<SudokuBloc>();

    return Column(
      children: [
        Row(
          spacing: 6,
          children: [
            for (var digit = 1; digit <= SudokuBoardEntity.size; digit++)
              Expanded(child: _DigitButton(digit: digit)),
          ],
        ),
        height20,
        Row(
          spacing: 10,
          children: [
            Expanded(
              child: BlocSelector<SudokuBloc, SudokuState, bool>(
                selector: (state) => state.canUndo,
                builder: (context, canUndo) {
                  return _PadButton(
                    key: const ValueKey('sudoku_undo'),
                    onTap: canUndo ? () => bloc.add(const Undo()) : null,
                    child: const Icon(Icons.undo, size: 22),
                  );
                },
              ),
            ),
            Expanded(
              child: _PadButton(
                onTap: () => bloc.add(const EraseCell()),
                child: const Icon(Icons.backspace_outlined, size: 22),
              ),
            ),
            Expanded(
              child: BlocSelector<SudokuBloc, SudokuState, bool>(
                selector: (state) => state.notesMode,
                builder: (context, notesMode) {
                  return _PadButton(
                    isActive: notesMode,
                    onTap: () => bloc.add(const ToggleNotesMode()),
                    child: const Icon(Icons.edit_outlined, size: 22),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// A digit key showing how many of that digit are still to be placed;
/// dimmed and disabled once all nine are on the board.
class _DigitButton extends StatelessWidget {
  const _DigitButton({required this.digit});

  final int digit;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<SudokuBloc>();

    return BlocSelector<SudokuBloc, SudokuState, int>(
      selector: (state) => state.remainingOf(digit),
      builder: (context, remaining) {
        return _PadButton(
          key: ValueKey('sudoku_digit_$digit'),
          onTap: remaining > 0 ? () => bloc.add(EnterDigit(digit)) : null,
          child: Column(
            mainAxisSize: .min,
            children: [
              Text(
                '$digit',
                style: context.typography.regular24.withNumericFont,
              ),
              Text(
                '$remaining',
                style: context.typography.bodySmall.withNumericFont.copyWith(
                  color: context.colors.white50,
                  height: 1,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _PadButton extends StatelessWidget {
  const _PadButton({
    required this.onTap,
    required this.child,
    this.isActive = false,
    super.key,
  });

  /// Null renders the button in a disabled (dimmed, non-tappable) state.
  final VoidCallback? onTap;
  final Widget child;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isDisabled = onTap == null;

    return Opacity(
      opacity: isDisabled ? 0.4 : 1,
      child: Material(
        color: isActive ? colors.white : colors.white20,
        borderRadius: .circular(10),
        child: InkWell(
          onTap: onTap,
          borderRadius: .circular(10),
          child: IconTheme.merge(
            data: IconThemeData(
              color: isActive ? colors.secondary : colors.white,
            ),
            child: SizedBox(height: 56, child: Center(child: child)),
          ),
        ),
      ),
    );
  }
}
