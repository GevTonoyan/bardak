import 'package:bardak/core/extensions/context_extension.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/sea_battle_rules.dart';
import 'package:flutter/material.dart';

/// The empty 10×10 board: a dark rounded square with a soft checker
/// pattern and grid lines.
///
/// Shared by the placement and battle screens; ships, shots and highlights
/// are stacked on top of it at multiples of [cellSize].
class SeaBattleGrid extends StatelessWidget {
  const SeaBattleGrid({required this.cellSize, super.key});

  final double cellSize;

  static const radius = 12.0;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final boardSide = cellSize * SeaBattleRules.boardSize;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.secondary,
        borderRadius: .circular(radius),
        border: .all(color: colors.white30, width: 1.5),
        boxShadow: [
          BoxShadow(
            color: colors.black.withValues(alpha: 0.25),
            offset: const Offset(0, 4),
            blurRadius: 8,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: .circular(radius),
        child: CustomPaint(
          size: Size.square(boardSide),
          painter: _GridPainter(
            cellSize: cellSize,
            lineColor: colors.white20,
            checkerColor: colors.white.withValues(alpha: 0.04),
          ),
        ),
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  const _GridPainter({
    required this.cellSize,
    required this.lineColor,
    required this.checkerColor,
  });

  final double cellSize;
  final Color lineColor;
  final Color checkerColor;

  @override
  void paint(Canvas canvas, Size size) {
    final checker = Paint()..color = checkerColor;
    for (var row = 0; row < SeaBattleRules.boardSize; row++) {
      for (
        var column = row.isEven ? 1 : 0;
        column < SeaBattleRules.boardSize;
        column += 2
      ) {
        canvas.drawRect(
          Rect.fromLTWH(column * cellSize, row * cellSize, cellSize, cellSize),
          checker,
        );
      }
    }

    final paint = Paint()
      ..color = lineColor
      ..strokeWidth = 1;

    for (var i = 1; i < SeaBattleRules.boardSize; i++) {
      final offset = i * cellSize;
      canvas
        ..drawLine(Offset(offset, 0), Offset(offset, size.height), paint)
        ..drawLine(Offset(0, offset), Offset(size.width, offset), paint);
    }
  }

  @override
  bool shouldRepaint(_GridPainter oldDelegate) =>
      oldDelegate.cellSize != cellSize ||
      oldDelegate.lineColor != lineColor ||
      oldDelegate.checkerColor != checkerColor;
}
