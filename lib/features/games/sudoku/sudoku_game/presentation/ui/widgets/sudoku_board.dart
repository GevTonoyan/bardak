import 'dart:math';

import 'package:bardak/core/app_ui/theme/text_styles/app_text_styles.dart';
import 'package:bardak/core/extensions/context_extension.dart';
import 'package:bardak/features/games/sudoku/sudoku_game/domain/entities/sudoku_board_entity.dart';
import 'package:bardak/features/games/sudoku/sudoku_game/presentation/bloc/sudoku_bloc.dart';
import 'package:bardak/features/games/sudoku/sudoku_game/presentation/bloc/sudoku_event.dart';
import 'package:bardak/features/games/sudoku/sudoku_game/presentation/bloc/sudoku_state.dart';
import 'package:bardak/features/games/sudoku/sudoku_game/presentation/ui/widgets/sudoku_generating_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// The 9x9 board: a rounded frame with pixel-snapped grid lines. Shows a
/// shimmer while the puzzle generates and the filled cells once ready.
class SudokuBoard extends StatelessWidget {
  const SudokuBoard({super.key});

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
            buildWhen: (previous, current) =>
                previous.isGenerating != current.isGenerating ||
                previous.board != current.board ||
                previous.selectedIndex != current.selectedIndex,
            builder: (context, state) {
              final side = state.board.size;
              // The empty grid frame stays put while the puzzle generates,
              // so it fills in with no layout jump. A shimmer signals work.
              final gridLines = Positioned.fill(
                child: IgnorePointer(
                  child: CustomPaint(
                    painter: _GridLinesPainter(
                      size: state.board.size,
                      boxSize: state.board.boxSize,
                      thin: colors.white30,
                      thick: colors.white,
                      devicePixelRatio: dpr,
                    ),
                  ),
                ),
              );

              if (state.isGenerating) {
                return Stack(
                  children: [
                    gridLines,
                    const Positioned.fill(child: SudokuGeneratingShimmer()),
                  ],
                );
              }

              // Cells paint only their fills; the grid lines are drawn once
              // on top by a single pixel-snapped painter so every divider is
              // crisp and uniform regardless of the board's fractional size.
              return Stack(
                children: [
                  Positioned.fill(
                    child: Column(
                      children: [
                        for (var row = 0; row < side; row++)
                          Expanded(
                            child: Row(
                              // Stretch cells to the full row height so empty
                              // cells (whose child is zero-sized) still fill
                              // the square and remain tappable.
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                for (var col = 0; col < side; col++)
                                  Expanded(
                                    child: _SudokuCell(
                                      key: ValueKey(row * side + col),
                                      index: row * side + col,
                                      state: state,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                  gridLines,
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
    required this.size,
    required this.boxSize,
    required this.thin,
    required this.thick,
    required this.devicePixelRatio,
  });

  /// Cells along one side of the board.
  final int size;

  /// Cells per box; every [boxSize]-th line is drawn thick.
  final int boxSize;

  final Color thin;
  final Color thick;
  final double devicePixelRatio;

  @override
  void paint(Canvas canvas, Size canvasSize) {
    // Work in whole device pixels so every line lands on the physical grid;
    // drawn as filled rects (not strokes) which stay crisp under Impeller.
    final dpr = devicePixelRatio;
    final thinPx = dpr.roundToDouble(); // ~1 logical px, whole physical px
    final thickPx = thinPx * 2;

    for (var i = 1; i < size; i++) {
      final isBoxEdge = i % boxSize == 0;
      final paint = Paint()..color = isBoxEdge ? thick : thin;
      final widthPx = isBoxEdge ? thickPx : thinPx;

      final cx = (canvasSize.width * i / size * dpr).roundToDouble();
      canvas.drawRect(
        Rect.fromLTRB(
          (cx - widthPx / 2) / dpr,
          0,
          (cx + widthPx / 2) / dpr,
          canvasSize.height,
        ),
        paint,
      );

      final cy = (canvasSize.height * i / size * dpr).roundToDouble();
      canvas.drawRect(
        Rect.fromLTRB(
          0,
          (cy - widthPx / 2) / dpr,
          canvasSize.width,
          (cy + widthPx / 2) / dpr,
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_GridLinesPainter oldDelegate) =>
      oldDelegate.size != size ||
      oldDelegate.boxSize != boxSize ||
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
    final row = index ~/ board.size;
    final col = index % board.size;
    final value = board.values[index];

    final isSelected = state.selectedIndex == index;
    final selected = state.selectedIndex;

    // The selected cell's row, column AND box are the regions where its
    // digit may not repeat, so all three get the soft highlight.
    var sharesRegion = false;
    var sameDigit = false;
    if (selected != null) {
      final selectedRow = selected ~/ board.size;
      final selectedCol = selected % board.size;
      final sharesBox =
          row ~/ board.boxSize == selectedRow ~/ board.boxSize &&
          col ~/ board.boxSize == selectedCol ~/ board.boxSize;
      sharesRegion = row == selectedRow || col == selectedCol || sharesBox;

      final selectedValue = board.values[selected];
      sameDigit =
          !isSelected &&
          selectedValue != SudokuBoardEntity.empty &&
          value == selectedValue;
    }

    // The 4×4 board has far fewer, much larger cells, so its digits use a
    // bigger style to fill them.
    final valueStyle = board.boxSize <= 2
        ? context.typography.regular38
        : context.typography.regular24;

    final content = value == SudokuBoardEntity.empty
        ? _CellNotes(notes: board.notes[index], boxSize: board.boxSize)
        : Center(
            child: Text(
              '$value',
              style: valueStyle.withNumericFont.copyWith(
                color: state.isMistake(index)
                    ? colors.red
                    : board.given[index]
                    ? colors.white
                    : colors.orange,
              ),
            ),
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
        ),
        child: state.completedCells.contains(index)
            ? Stack(
                fit: .expand,
                children: [
                  content,
                  _CompletionRipple(
                    tick: state.completionTick,
                    origin: state.completionOrigin,
                    index: index,
                    size: board.size,
                  ),
                ],
              )
            : content,
      ),
    );
  }
}

/// A green wave played over the cells of a correctly completed row,
/// column or box, rippling outwards from the cell that completed it.
class _CompletionRipple extends StatelessWidget {
  const _CompletionRipple({
    required this.tick,
    required this.origin,
    required this.index,
    required this.size,
  });

  /// Restarts the animation whenever a new unit completes.
  final int tick;

  /// The placed cell the wave spreads from.
  final int origin;

  /// The cell this ripple instance is drawn in.
  final int index;

  /// Cells along one side of the board.
  final int size;

  @override
  Widget build(BuildContext context) {
    // Distance to the origin decides when this cell lights up, so the
    // glow travels along the completed unit instead of blinking at once.
    final rowDistance = (index ~/ size - origin ~/ size).abs();
    final colDistance = (index % size - origin % size).abs();
    final distance = max(rowDistance, colDistance);

    // The wave is delayed by distance so the glow travels outwards, then each
    // cell brightens and fades within its own window. Normalising the delay
    // to the widest a unit can span (a full row/column) guarantees even the
    // farthest cell completes its fade before the timeline ends — otherwise a
    // completion placed near an edge leaves its far cell frozen bright green.
    final maxDistance = size - 1;
    const spread = 0.6;
    const window = 0.35;
    final delay = distance / maxDistance * spread;

    return IgnorePointer(
      child: TweenAnimationBuilder<double>(
        key: ValueKey('sudoku_ripple_$tick'),
        tween: Tween(begin: 0, end: 1),
        duration: const Duration(milliseconds: 1400),
        builder: (context, t, _) {
          final phase = ((t - delay) / window).clamp(0.0, 1.0);
          final intensity = sin(phase * pi);

          return ColoredBox(
            color: context.colors.green.withValues(alpha: intensity * 0.55),
          );
        },
      ),
    );
  }
}

/// The candidate slots of an empty cell: each digit 1..size sits in its own
/// fixed mini-cell of the [boxSize]×[boxSize] grid, shown only when pencilled
/// in.
class _CellNotes extends StatelessWidget {
  const _CellNotes({required this.notes, required this.boxSize});

  final Set<int> notes;
  final int boxSize;

  @override
  Widget build(BuildContext context) {
    if (notes.isEmpty) return const SizedBox.shrink();

    // Each candidate scales to fill its slot, so pencil marks are as large
    // as the cell allows regardless of the board's size.
    final style = context.typography.regular24.withNumericFont.copyWith(
      color: context.colors.white50,
      height: 1,
    );

    return Padding(
      padding: const EdgeInsets.all(2),
      child: Column(
        children: [
          for (var noteRow = 0; noteRow < boxSize; noteRow++)
            Expanded(
              child: Row(
                children: [
                  for (var noteCol = 0; noteCol < boxSize; noteCol++)
                    Expanded(
                      child: notes.contains(noteRow * boxSize + noteCol + 1)
                          ? Center(
                              child: FittedBox(
                                fit: .scaleDown,
                                child: Text(
                                  '${noteRow * boxSize + noteCol + 1}',
                                  style: style,
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
