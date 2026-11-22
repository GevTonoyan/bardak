import 'dart:math';

import 'package:bardak/core/extensions/context_extension.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/board_coordinate.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/sea_battle_board_entity.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/sea_battle_entity.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/presentation/ui/widgets/cell_mark.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/presentation/ui/widgets/sea_battle_grid.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/presentation/ui/widgets/ship_view.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/presentation/ui/widgets/shot_effect.dart';
import 'package:flutter/material.dart';

/// One side's board during the battle, with every shot marked on it.
///
/// Draws the fleet when it is known — always on the player's own board,
/// and on the opponent's once it is revealed after the battle — and only
/// the ships already sunk otherwise. The latest shot plays its
/// [ShotEffect], and sinking a ship shakes the board.
class BattleBoard extends StatefulWidget {
  const BattleBoard({
    required this.board,
    required this.cellSize,
    required this.isOwnBoard,
    this.lastShot,
    this.onCellTap,
    super.key,
  });

  final SeaBattleBoardEntity board;
  final double cellSize;

  /// Whether this is the player's board. On the opponent's, revealed ships
  /// that were never sunk are drawn faded.
  final bool isOwnBoard;

  /// The most recent shot on this board: outlined and animated.
  final ShotEntity? lastShot;

  /// Called with the tapped cell; null leaves the board read-only.
  final ValueChanged<BoardCoordinate>? onCellTap;

  @override
  State<BattleBoard> createState() => _BattleBoardState();
}

class _BattleBoardState extends State<BattleBoard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _shake = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 450),
  );

  @override
  void didUpdateWidget(BattleBoard oldWidget) {
    super.didUpdateWidget(oldWidget);
    final shot = widget.lastShot;
    if (shot != oldWidget.lastShot && shot?.result == .sunk) {
      _shake.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _shake.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cellSize = widget.cellSize;
    final board = widget.board;
    final sunkShips = board.sunkShips;
    final ships = board.fleet?.ships ?? sunkShips;
    final lastShot = widget.lastShot;
    final onCellTap = widget.onCellTap;

    return AnimatedBuilder(
      animation: _shake,
      // A quick side-to-side shake that dies down.
      builder: (context, child) => Transform.translate(
        offset: Offset(
          sin(_shake.value * pi * 6) * (1 - _shake.value) * cellSize * 0.2,
          0,
        ),
        child: child,
      ),
      child: GestureDetector(
        onTapUp: onCellTap == null
            ? null
            : (details) => onCellTap(
                BoardCoordinate(
                  details.localPosition.dy ~/ cellSize,
                  details.localPosition.dx ~/ cellSize,
                ),
              ),
        child: Stack(
          clipBehavior: .none,
          children: [
            SeaBattleGrid(cellSize: cellSize),
            for (final ship in ships)
              Positioned(
                left: ship.origin.column * cellSize,
                top: ship.origin.row * cellSize,
                // Ships nobody found are shown faded once the fleet is
                // revealed.
                child: Opacity(
                  opacity: widget.isOwnBoard || sunkShips.contains(ship)
                      ? 1
                      : 0.5,
                  child: ShipView(
                    length: ship.length,
                    cellSize: cellSize,
                    orientation: ship.orientation,
                  ),
                ),
              ),
            for (final cell in board.missCells)
              _Mark(cell: cell, cellSize: cellSize, type: .miss),
            for (final cell in board.hitCells)
              _Mark(cell: cell, cellSize: cellSize, type: .hit),
            if (lastShot != null) ...[
              // A sunk ship turns all red; the frame would only break it up.
              if (lastShot.result != .sunk)
                _LastShotFrame(cell: lastShot.cell, cellSize: cellSize),
              Positioned(
                left: (lastShot.cell.column - 1) * cellSize,
                top: (lastShot.cell.row - 1) * cellSize,
                child: ShotEffect(
                  key: ValueKey(lastShot),
                  result: lastShot.result,
                  cellSize: cellSize,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Mark extends StatelessWidget {
  const _Mark({
    required this.cell,
    required this.cellSize,
    required this.type,
  });

  final BoardCoordinate cell;
  final double cellSize;
  final CellMarkType type;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: cell.column * cellSize,
      top: cell.row * cellSize,
      child: IgnorePointer(
        child: CellMark(type: type, cellSize: cellSize),
      ),
    );
  }
}

/// An orange outline around the latest shot.
class _LastShotFrame extends StatelessWidget {
  const _LastShotFrame({required this.cell, required this.cellSize});

  final BoardCoordinate cell;
  final double cellSize;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: cell.column * cellSize,
      top: cell.row * cellSize,
      child: IgnorePointer(
        child: Container(
          width: cellSize,
          height: cellSize,
          decoration: BoxDecoration(
            border: .all(color: context.colors.orange, width: 2),
          ),
        ),
      ),
    );
  }
}
