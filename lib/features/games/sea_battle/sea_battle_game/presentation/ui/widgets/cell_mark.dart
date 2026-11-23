import 'package:bardak/core/extensions/context_extension.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/presentation/ui/widgets/miss_mark.dart';
import 'package:flutter/material.dart';

/// What a [CellMark] draws on a board cell.
enum CellMarkType {
  /// A shot that found only water.
  miss,

  /// Water marked around a sunk ship: no ship can be there, but it was
  /// never fired at.
  cleared,

  /// A shot that struck a ship.
  hit,

  /// The cell about to be shot.
  target,

  /// A cell no ship may use, next to another ship.
  blocked,
}

/// One board cell's mark, the same on the battle boards and in the rules.
class CellMark extends StatelessWidget {
  const CellMark({
    required this.type,
    required this.cellSize,
    this.animateIn = false,
    super.key,
  });

  final CellMarkType type;
  final double cellSize;

  /// Whether a miss dives in, as a fresh shot; at rest otherwise.
  final bool animateIn;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return SizedBox.square(
      dimension: cellSize,
      child: switch (type) {
        .miss => MissMark(cellSize: cellSize, animateIn: animateIn),
        .cleared => Center(
          child: Container(
            width: cellSize * 0.3,
            height: cellSize * 0.3,
            decoration: BoxDecoration(
              color: colors.white50,
              shape: .circle,
            ),
          ),
        ),
        // See-through, so a sunk ship still shows under its hits.
        .hit => ColoredBox(
          color: colors.red.withValues(alpha: 0.55),
          child: Icon(
            Icons.close_rounded,
            color: colors.white,
            size: cellSize * 0.8,
          ),
        ),
        .target => DecoratedBox(
          decoration: BoxDecoration(
            color: colors.orange.withValues(alpha: 0.35),
            border: .all(color: colors.orange, width: 2),
          ),
          child: Icon(
            Icons.gps_fixed_rounded,
            color: colors.white,
            size: cellSize * 0.75,
          ),
        ),
        .blocked => ColoredBox(color: colors.red.withValues(alpha: 0.35)),
      },
    );
  }
}
