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
              // The board fills all the space between the header and the
              // pad, sized to the largest square that fits (bounded by width
              // on tall screens), so it is as large as possible.
              const Expanded(
                child: Padding(
                  padding: .symmetric(horizontal: 12, vertical: 8),
                  child: Center(child: _SudokuGrid()),
                ),
              ),
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
    final dpr = MediaQuery.devicePixelRatioOf(context);

    return AspectRatio(
      aspectRatio: 1,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.secondary,
          borderRadius: .circular(12),
          border: Border.all(color: colors.white, width: 2),
        ),
        // Highlight fills are straight rectangles; without clipping they
        // paint over the rounded corners.
        child: ClipRRect(
          borderRadius: .circular(10),
          child: BlocBuilder<SudokuBloc, SudokuState>(
            builder: (context, state) {
              // Cells paint only their fills; the grid lines are drawn once
              // on top by a single pixel-snapped painter so every divider is
              // crisp and uniform regardless of the board's fractional size.
              return Stack(
                children: [
                  Positioned.fill(
                    child: Column(
                      children: [
                        for (var row = 0; row < SudokuBoardEntity.size; row++)
                          Expanded(
                            child: Row(
                              // Stretch cells to the full row height so empty
                              // cells (whose child is zero-sized) still fill
                              // the square and remain tappable.
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                for (
                                  var col = 0;
                                  col < SudokuBoardEntity.size;
                                  col++
                                )
                                  Expanded(
                                    child: _SudokuCell(
                                      key: ValueKey(
                                        row * SudokuBoardEntity.size + col,
                                      ),
                                      index: row * SudokuBoardEntity.size + col,
                                      state: state,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                  Positioned.fill(
                    child: IgnorePointer(
                      child: CustomPaint(
                        painter: _GridLinesPainter(
                          thin: colors.white30,
                          thick: colors.white,
                          devicePixelRatio: dpr,
                        ),
                      ),
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

/// Paints the 8 internal vertical and horizontal dividers of the 9x9 grid.
/// Line centres are snapped to whole device pixels so hairlines never drop
/// out or blur — the failure mode of per-cell fractional borders.
class _GridLinesPainter extends CustomPainter {
  const _GridLinesPainter({
    required this.thin,
    required this.thick,
    required this.devicePixelRatio,
  });

  final Color thin;
  final Color thick;
  final double devicePixelRatio;

  @override
  void paint(Canvas canvas, Size size) {
    // Work in whole device pixels so every line lands on the physical grid;
    // drawn as filled rects (not strokes) which stay crisp under Impeller.
    final dpr = devicePixelRatio;
    final thinPx = dpr.roundToDouble(); // ~1 logical px, whole physical px
    final thickPx = thinPx * 2;

    for (var i = 1; i < SudokuBoardEntity.size; i++) {
      final isBoxEdge = i % SudokuBoardEntity.boxSize == 0;
      final paint = Paint()..color = isBoxEdge ? thick : thin;
      final widthPx = isBoxEdge ? thickPx : thinPx;

      final cx = (size.width * i / SudokuBoardEntity.size * dpr)
          .roundToDouble();
      canvas.drawRect(
        Rect.fromLTRB(
          (cx - widthPx / 2) / dpr,
          0,
          (cx + widthPx / 2) / dpr,
          size.height,
        ),
        paint,
      );

      final cy = (size.height * i / SudokuBoardEntity.size * dpr)
          .roundToDouble();
      canvas.drawRect(
        Rect.fromLTRB(
          0,
          (cy - widthPx / 2) / dpr,
          size.width,
          (cy + widthPx / 2) / dpr,
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_GridLinesPainter oldDelegate) =>
      oldDelegate.thin != thin ||
      oldDelegate.thick != thick ||
      oldDelegate.devicePixelRatio != devicePixelRatio;
}

class _SudokuCell extends StatelessWidget {
  const _SudokuCell({required this.index, required this.state, super.key});

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
        ),
        child: value == SudokuBoardEntity.empty
            ? _CellNotes(notes: board.notes[index])
            : Center(
                child: Text(
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

/// The nine candidate slots of an empty cell: each digit 1..9 sits in its
/// own fixed mini-cell, shown only when pencilled in.
class _CellNotes extends StatelessWidget {
  const _CellNotes({required this.notes});

  final Set<int> notes;

  @override
  Widget build(BuildContext context) {
    if (notes.isEmpty) return const SizedBox.shrink();

    final style = context.typography.labelSmall.withNumericFont.copyWith(
      color: context.colors.white50,
      fontSize: 10,
      height: 1,
    );

    return Padding(
      padding: const EdgeInsets.all(1),
      child: Column(
        children: [
          for (var noteRow = 0; noteRow < SudokuBoardEntity.boxSize; noteRow++)
            Expanded(
              child: Row(
                children: [
                  for (
                    var noteCol = 0;
                    noteCol < SudokuBoardEntity.boxSize;
                    noteCol++
                  )
                    Expanded(
                      child: Center(
                        child: Text(
                          notes.contains(noteRow * 3 + noteCol + 1)
                              ? '${noteRow * 3 + noteCol + 1}'
                              : '',
                          style: style,
                        ),
                      ),
                    ),
                ],
              ),
            ),
        ],
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
                  key: ValueKey('sudoku_digit_$digit'),
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
            child: SizedBox(height: 48, child: Center(child: child)),
          ),
        ),
      ),
    );
  }
}
