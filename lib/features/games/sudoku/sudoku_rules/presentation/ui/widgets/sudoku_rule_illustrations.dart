import 'package:bardak/core/app_ui/theme/text_styles/app_text_styles.dart';
import 'package:bardak/core/extensions/context_extension.dart';
import 'package:bardak/features/games/sudoku/sudoku_game/domain/entities/sudoku_board_entity.dart';
import 'package:bardak/features/games/sudoku/sudoku_game/presentation/ui/sudoku_formatters.dart';
import 'package:bardak/features/games/sudoku/sudoku_settings/domain/entities/sudoku_difficulty.dart';
import 'package:flutter/material.dart';

/// The rules always illustrate the classic 9×9 board (3×3 boxes).
const _classicSize = 9;
const _classicBoxSize = 3;

/// A classic partly-filled puzzle used as the backdrop for the board
/// illustrations, so the mini boards read like a real game in progress.
const _sampleValues = <int>[
  5, 3, 0, 0, 7, 0, 0, 0, 0, //
  6, 0, 0, 1, 9, 5, 0, 0, 0, //
  0, 9, 8, 0, 0, 0, 0, 6, 0, //
  8, 0, 0, 0, 6, 0, 0, 0, 3, //
  4, 0, 0, 8, 0, 3, 0, 0, 1, //
  7, 0, 0, 0, 2, 0, 0, 0, 6, //
  0, 6, 0, 0, 0, 0, 2, 8, 0, //
  0, 0, 0, 4, 1, 9, 0, 0, 5, //
  0, 0, 0, 0, 8, 0, 0, 7, 9, //
];

/// Rule 1 — the goal: a single 3×3 box filled with 1–9, no repeats.
class SudokuGoalIllustration extends StatelessWidget {
  const SudokuGoalIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;

    return SizedBox(
      width: 220,
      height: 220,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.secondary,
          borderRadius: .circular(12),
          border: Border.all(color: colors.white, width: 2),
        ),
        child: ClipRRect(
          borderRadius: .circular(10),
          child: Column(
            children: [
              for (var row = 0; row < _classicBoxSize; row++)
                Expanded(
                  child: Row(
                    crossAxisAlignment: .stretch,
                    children: [
                      for (var col = 0; col < _classicBoxSize; col++)
                        Expanded(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: colors.white30,
                                width: 0.5,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                '${row * _classicBoxSize + col + 1}',
                                style: typography.regular38.withNumericFont,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Rule 2 — placing a digit: a selected cell holds a freshly-placed orange
/// number while its row, column and box light up.
class SudokuHighlightIllustration extends StatelessWidget {
  const SudokuHighlightIllustration({super.key});

  // Centre cell (row 4, col 4) is empty in the sample; fill it as the move.
  static const int _selected = 4 * _classicSize + 4;

  @override
  Widget build(BuildContext context) {
    final values = [..._sampleValues]..[_selected] = 5;
    return _MiniBoard(
      values: values,
      selectedIndex: _selected,
      userIndex: _selected,
    );
  }
}

/// Rule 3 — mistakes: a wrong digit shown in red, with the remaining lives as
/// hearts.
class SudokuMistakesIllustration extends StatelessWidget {
  const SudokuMistakesIllustration({super.key});

  static const int _wrong = 2 * _classicSize; // empty in the sample

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final values = [..._sampleValues]..[_wrong] = 8; // clashes in its column

    return Column(
      mainAxisSize: .min,
      children: [
        _MiniBoard(values: values, mistakeIndex: _wrong),
        const SizedBox(height: 20),
        Container(
          padding: const .symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: colors.white10,
            borderRadius: .circular(20),
            border: Border.all(color: colors.white30, width: 0.5),
          ),
          child: Row(
            mainAxisSize: .min,
            spacing: 6,
            children: [
              Icon(Icons.favorite_rounded, size: 22, color: colors.red),
              Icon(Icons.favorite_rounded, size: 22, color: colors.red),
              Icon(Icons.heart_broken_rounded, size: 22, color: colors.white30),
            ],
          ),
        ),
      ],
    );
  }
}

/// Rule 4 — pencil notes: the pencil toggle active above a cell holding small
/// candidate numbers.
class SudokuNotesIllustration extends StatelessWidget {
  const SudokuNotesIllustration({super.key});

  static const _notes = {1, 2, 5, 7, 9};

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;

    return Column(
      mainAxisSize: .min,
      children: [
        const _PadChip(icon: Icon(Icons.edit_outlined), isActive: true),
        const SizedBox(height: 24),
        SizedBox(
          width: 150,
          height: 150,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: colors.secondary,
              borderRadius: .circular(12),
              border: Border.all(color: colors.white, width: 2),
            ),
            child: Padding(
              padding: const .all(6),
              child: Column(
                children: [
                  for (
                    var noteRow = 0;
                    noteRow < _classicBoxSize;
                    noteRow++
                  )
                    Expanded(
                      child: Row(
                        children: [
                          for (
                            var noteCol = 0;
                            noteCol < _classicBoxSize;
                            noteCol++
                          )
                            Expanded(
                              child: Center(
                                child:
                                    _notes.contains(noteRow * 3 + noteCol + 1)
                                    ? Text(
                                        '${noteRow * 3 + noteCol + 1}',
                                        style: typography
                                            .titleLarge
                                            .withNumericFont
                                            .copyWith(
                                              color: colors.white50,
                                              height: 1,
                                            ),
                                      )
                                    : const SizedBox.shrink(),
                              ),
                            ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Rule 5 — the undo and erase controls.
class SudokuControlsIllustration extends StatelessWidget {
  const SudokuControlsIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisSize: .min,
      spacing: 20,
      children: [
        _PadChip(icon: Icon(Icons.undo)),
        _PadChip(icon: Icon(Icons.backspace_outlined)),
      ],
    );
  }
}

/// Rule 6 — the difficulty ladder: harder levels are worth more points.
class SudokuDifficultyIllustration extends StatelessWidget {
  const SudokuDifficultyIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;
    const levels = SudokuDifficulty.values;

    return Column(
      mainAxisSize: .min,
      spacing: 10,
      children: [
        for (var i = 0; i < levels.length; i++)
          Container(
            width: 260,
            padding: const .symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: colors.white20,
              borderRadius: .circular(12),
              border: Border.all(color: colors.white30, width: 0.5),
            ),
            child: Row(
              mainAxisAlignment: .spaceBetween,
              children: [
                Text(
                  sudokuDifficultyLabel(context, levels[i]),
                  style: typography.regular20,
                ),
                // A rising ramp of filled dots signals harder levels.
                Row(
                  spacing: 6,
                  children: [
                    for (var dot = 0; dot < levels.length; dot++)
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: .circle,
                          color: dot <= i ? colors.orange : colors.white30,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
      ],
    );
  }
}

/// A small mock of a control-pad button, matching the in-game pad styling.
class _PadChip extends StatelessWidget {
  const _PadChip({required this.icon, this.isActive = false});

  final Widget icon;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: isActive ? colors.white : colors.white20,
        borderRadius: .circular(10),
      ),
      child: SizedBox(
        width: 72,
        height: 64,
        child: IconTheme.merge(
          data: IconThemeData(
            color: isActive ? colors.secondary : colors.white,
            size: 28,
          ),
          child: Center(child: icon),
        ),
      ),
    );
  }
}

/// A 9×9 mini board rendering the sample puzzle with optional region
/// highlighting and coloured user / mistake digits. Cells paint only their
/// fills; the grid lines are drawn once on top.
class _MiniBoard extends StatelessWidget {
  const _MiniBoard({
    required this.values,
    this.selectedIndex,
    this.userIndex,
    this.mistakeIndex,
  });

  final List<int> values;
  final int? selectedIndex;
  final int? userIndex;
  final int? mistakeIndex;

  static const int _size = _classicSize;
  static const int _boxSize = _classicBoxSize;
  static const double _dimension = 240;

  bool _sharesRegion(int index, int selected) {
    final row = index ~/ _size;
    final col = index % _size;
    final selectedRow = selected ~/ _size;
    final selectedCol = selected % _size;
    final sharesBox =
        row ~/ _boxSize == selectedRow ~/ _boxSize &&
        col ~/ _boxSize == selectedCol ~/ _boxSize;
    return row == selectedRow || col == selectedCol || sharesBox;
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final dpr = MediaQuery.devicePixelRatioOf(context);

    return SizedBox(
      width: _dimension,
      height: _dimension,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.secondary,
          borderRadius: .circular(12),
          border: Border.all(color: colors.white, width: 2),
        ),
        child: ClipRRect(
          borderRadius: .circular(10),
          child: Stack(
            children: [
              Positioned.fill(
                child: Column(
                  children: [
                    for (var row = 0; row < _size; row++)
                      Expanded(
                        child: Row(
                          crossAxisAlignment: .stretch,
                          children: [
                            for (var col = 0; col < _size; col++)
                              Expanded(
                                child: _cell(context, row * _size + col),
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
                    painter: _MiniGridPainter(
                      thin: colors.white30,
                      thick: colors.white,
                      devicePixelRatio: dpr,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _cell(BuildContext context, int index) {
    final colors = context.colors;
    final value = values[index];

    final selected = selectedIndex;
    final isSelected = selected == index;
    final sharesRegion =
        selected != null && !isSelected && _sharesRegion(index, selected);

    Color? fill;
    if (isSelected) {
      fill = colors.white30;
    } else if (sharesRegion) {
      fill = colors.white10;
    }

    final Color digitColor;
    if (index == mistakeIndex) {
      digitColor = colors.red;
    } else if (index == userIndex) {
      digitColor = colors.orange;
    } else {
      digitColor = colors.white;
    }

    final content = value == SudokuBoardEntity.empty
        ? const SizedBox.shrink()
        : Center(
            child: FittedBox(
              fit: .scaleDown,
              child: Padding(
                padding: const .all(2),
                child: Text(
                  '$value',
                  style: context.typography.regular24.withNumericFont.copyWith(
                    color: digitColor,
                  ),
                ),
              ),
            ),
          );

    return fill == null ? content : ColoredBox(color: fill, child: content);
  }
}

/// Paints the 8 internal dividers of the 9×9 grid, snapping line centres to
/// whole device pixels so the hairlines stay crisp.
class _MiniGridPainter extends CustomPainter {
  const _MiniGridPainter({
    required this.thin,
    required this.thick,
    required this.devicePixelRatio,
  });

  final Color thin;
  final Color thick;
  final double devicePixelRatio;

  static const int _size = _classicSize;
  static const int _boxSize = _classicBoxSize;

  @override
  void paint(Canvas canvas, Size size) {
    final dpr = devicePixelRatio;
    final thinPx = dpr.roundToDouble();
    final thickPx = thinPx * 2;

    for (var i = 1; i < _size; i++) {
      final isBoxEdge = i % _boxSize == 0;
      final paint = Paint()..color = isBoxEdge ? thick : thin;
      final widthPx = isBoxEdge ? thickPx : thinPx;

      final cx = (size.width * i / _size * dpr).roundToDouble();
      canvas.drawRect(
        Rect.fromLTRB(
          (cx - widthPx / 2) / dpr,
          0,
          (cx + widthPx / 2) / dpr,
          size.height,
        ),
        paint,
      );

      final cy = (size.height * i / _size * dpr).roundToDouble();
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
  bool shouldRepaint(_MiniGridPainter oldDelegate) =>
      oldDelegate.thin != thin ||
      oldDelegate.thick != thick ||
      oldDelegate.devicePixelRatio != devicePixelRatio;
}
