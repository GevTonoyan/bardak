import 'dart:async';

import 'package:bardak/core/app_ui/theme/text_styles/app_text_styles.dart';
import 'package:bardak/core/app_ui/widgets/app_icon_button.dart';
import 'package:bardak/core/app_ui/widgets/app_notification.dart';
import 'package:bardak/core/app_ui/widgets/app_spacings.dart';
import 'package:bardak/core/app_ui/widgets/round_timer.dart';
import 'package:bardak/core/app_ui/widgets/screen_background.dart';
import 'package:bardak/core/app_ui/widgets/show_confirm_sheet.dart';
import 'package:bardak/core/extensions/context_extension.dart';
import 'package:bardak/features/games/sudoku/sudoku_game/domain/entities/sudoku_board_entity.dart';
import 'package:bardak/features/games/sudoku/sudoku_game/presentation/bloc/sudoku_bloc.dart';
import 'package:bardak/features/games/sudoku/sudoku_game/presentation/bloc/sudoku_event.dart';
import 'package:bardak/features/games/sudoku/sudoku_game/presentation/bloc/sudoku_state.dart';
import 'package:bardak/features/games/sudoku/sudoku_game/presentation/ui/sudoku_win_screen.dart';
import 'package:bardak/features/home/presentation/ui/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// A single Sudoku game: the grid on top, a digit pad below.
class SudokuScreen extends StatefulWidget {
  const SudokuScreen({super.key});

  static const routePath = 'sudoku';

  @override
  State<SudokuScreen> createState() => _SudokuScreenState();
}

class _SudokuScreenState extends State<SudokuScreen> {
  var _elapsedSeconds = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _elapsedSeconds++);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  /// Confirms before abandoning the puzzle — same semantics as the exit
  /// confirmation in the other games.
  Future<void> _confirmExitGame() async {
    final l10n = context.l10n;
    final colors = context.colors;

    await showConfirmSheet(
      context: context,
      title: l10n.exit_game_title,
      description: l10n.exit_game_description,
      confirmText: l10n.exit_game_confirm,
      cancelText: l10n.cancel,
      confirmColor: colors.red,
      cancelColor: colors.green,
      onConfirm: () => context.goNamed(HomeScreen.routePath),
    );
  }

  @override
  Widget build(BuildContext context) {
    final showTimer = context.read<SudokuBloc>().state.showTimer;

    return MultiBlocListener(
      listeners: [
        BlocListener<SudokuBloc, SudokuState>(
          // Only the transition into solved counts, so navigation fires once.
          listenWhen: (previous, current) =>
              !previous.isSolved && current.isSolved,
          listener: (context, state) {
            _timer?.cancel();
            context.pushReplacementNamed(
              SudokuWinScreen.routePath,
              extra: state.showTimer ? _elapsedSeconds : null,
            );
          },
        ),
        BlocListener<SudokuBloc, SudokuState>(
          // Filling the last cell without winning would otherwise be
          // silent when mistakes are hidden, leaving the player stuck.
          listenWhen: (previous, current) =>
              !previous.isFullButWrong && current.isFullButWrong,
          listener: (context, state) {
            unawaited(
              showAppNotification(
                context,
                message: context.l10n.sudoku_board_has_mistakes,
              ),
            );
          },
        ),
      ],
      child: GradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const .only(left: 20, top: 20, right: 20),
                child: Stack(
                  alignment: .center,
                  children: [
                    Align(
                      alignment: .centerLeft,
                      child: AppIconButton.close(
                        onTap: () => unawaited(_confirmExitGame()),
                      ),
                    ),
                    if (showTimer)
                      // Counting up, so the countdown warning colors are
                      // pushed below zero and the pill stays green.
                      RoundTimer(
                        seconds: _elapsedSeconds,
                        formatAsMinutes: true,
                        orangeBelow: -1,
                        redBelow: -1,
                      ),
                  ],
                ),
              ),
              const Spacer(),
              const Padding(
                padding: .symmetric(horizontal: 20),
                child: _SudokuGrid(),
              ),
              const Spacer(),
              const Padding(
                padding: .fromLTRB(20, 0, 20, 20),
                child: _DigitPad(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Formats elapsed seconds as m:ss for the in-game and win screens.
String formatSudokuTime(int totalSeconds) {
  final minutes = totalSeconds ~/ 60;
  final seconds = totalSeconds % 60;
  return '$minutes:${seconds.toString().padLeft(2, '0')}';
}

class _SudokuGrid extends StatelessWidget {
  const _SudokuGrid();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return AspectRatio(
      aspectRatio: 1,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.secondary,
          borderRadius: .circular(12),
          border: Border.all(color: colors.white, width: 2),
        ),
        // Cell borders and highlight fills are straight rectangles; without
        // clipping they paint over the rounded corners.
        child: ClipRRect(
          borderRadius: .circular(10),
          child: BlocBuilder<SudokuBloc, SudokuState>(
            builder: (context, state) {
              return Column(
                children: [
                  for (var row = 0; row < SudokuBoardEntity.size; row++)
                    Expanded(
                      child: Row(
                        children: [
                          for (var col = 0; col < SudokuBoardEntity.size; col++)
                            Expanded(
                              child: _SudokuCell(
                                index: row * SudokuBoardEntity.size + col,
                                state: state,
                              ),
                            ),
                        ],
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _SudokuCell extends StatelessWidget {
  const _SudokuCell({required this.index, required this.state});

  final int index;
  final SudokuState state;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    final board = state.board;
    final row = index ~/ SudokuBoardEntity.size;
    final col = index % SudokuBoardEntity.size;
    final value = board.values[index];

    final isSelected = state.selectedIndex == index;
    final selected = state.selectedIndex;

    // The selected cell's row, column AND 3x3 box are the regions where its
    // digit may not repeat, so all three get the soft highlight.
    var sharesRegion = false;
    var sameDigit = false;
    if (selected != null) {
      final selectedRow = selected ~/ SudokuBoardEntity.size;
      final selectedCol = selected % SudokuBoardEntity.size;
      final sharesBox =
          row ~/ SudokuBoardEntity.boxSize ==
              selectedRow ~/ SudokuBoardEntity.boxSize &&
          col ~/ SudokuBoardEntity.boxSize ==
              selectedCol ~/ SudokuBoardEntity.boxSize;
      sharesRegion = row == selectedRow || col == selectedCol || sharesBox;

      final selectedValue = board.values[selected];
      sameDigit =
          !isSelected &&
          selectedValue != SudokuBoardEntity.empty &&
          value == selectedValue;
    }

    // Thick edges close each 3x3 box, thin edges separate cells.
    BorderSide side({required bool boxEdge}) => BorderSide(
      color: boxEdge ? colors.white : colors.white30,
      width: boxEdge ? 1.5 : 0.5,
    );

    return GestureDetector(
      behavior: .opaque,
      onTap: () => context.read<SudokuBloc>().add(SelectCell(index)),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: isSelected
              ? colors.white30
              : sameDigit
              ? colors.white20
              : sharesRegion
              ? colors.white10
              : Colors.transparent,
          // The outermost edges are drawn by the grid's own rounded
          // border, so the last row/column skip theirs.
          border: Border(
            right: col == SudokuBoardEntity.size - 1
                ? BorderSide.none
                : side(boxEdge: col % SudokuBoardEntity.boxSize == 2),
            bottom: row == SudokuBoardEntity.size - 1
                ? BorderSide.none
                : side(boxEdge: row % SudokuBoardEntity.boxSize == 2),
          ),
        ),
        child: Center(
          child: value == SudokuBoardEntity.empty
              ? const SizedBox.shrink()
              : Text(
                  '$value',
                  style: context.typography.regular24.withNumericFont.copyWith(
                    color: state.isMistake(index)
                        ? colors.red
                        : board.given[index]
                        ? colors.white
                        : colors.orange,
                  ),
                ),
        ),
      ),
    );
  }
}

class _DigitPad extends StatelessWidget {
  const _DigitPad();

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<SudokuBloc>();

    return Column(
      children: [
        Row(
          spacing: 6,
          children: [
            for (var digit = 1; digit <= SudokuBoardEntity.size; digit++)
              Expanded(
                child: _PadButton(
                  onTap: () => bloc.add(EnterDigit(digit)),
                  child: Text(
                    '$digit',
                    style: context.typography.regular24.withNumericFont,
                  ),
                ),
              ),
          ],
        ),
        height20,
        _PadButton(
          onTap: () => bloc.add(const EraseCell()),
          child: Icon(
            Icons.backspace_outlined,
            color: context.colors.white,
            size: 22,
          ),
        ),
      ],
    );
  }
}

class _PadButton extends StatelessWidget {
  const _PadButton({required this.onTap, required this.child});

  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Material(
      color: colors.white20,
      borderRadius: .circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: .circular(10),
        child: SizedBox(
          height: 48,
          child: Center(child: child),
        ),
      ),
    );
  }
}
