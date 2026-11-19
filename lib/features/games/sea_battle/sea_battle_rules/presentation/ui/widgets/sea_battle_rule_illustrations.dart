import 'package:bardak/core/app_ui/widgets/smart_number_text.dart';
import 'package:bardak/core/extensions/context_extension.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/board_coordinate.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/ship_entity.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/presentation/ui/widgets/cell_mark.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/presentation/ui/widgets/sea_battle_grid.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/presentation/ui/widgets/ship_view.dart';
import 'package:flutter/material.dart';

/// Cell size of the mini boards; a full 10×10 board is 240px wide.
const _cellSize = 24.0;

/// Rule 1 — the fleet: one model per ship type with how many of it each
/// player gets.
class SeaBattleFleetIllustration extends StatelessWidget {
  const SeaBattleFleetIllustration({super.key});

  static const _cellSize = 32.0;

  @override
  Widget build(BuildContext context) {
    final typography = context.typography;

    return Column(
      mainAxisSize: .min,
      crossAxisAlignment: .start,
      spacing: 14,
      children: [
        for (final (length, count) in [(4, 1), (3, 2), (2, 3), (1, 4)])
          Row(
            mainAxisSize: .min,
            children: [
              SizedBox(
                width: _cellSize * 4,
                child: Align(
                  alignment: .centerLeft,
                  child: ShipView(length: length, cellSize: _cellSize),
                ),
              ),
              const SizedBox(width: 20),
              SmartNumberText('×$count', style: typography.regular28),
            ],
          ),
      ],
    );
  }
}

/// Rule 2 — no touching: a ship with the cells around it shaded red, and a
/// second ship sitting just outside that zone.
class SeaBattleNoTouchIllustration extends StatelessWidget {
  const SeaBattleNoTouchIllustration({super.key});

  static const _ship = ShipEntity(
    id: 0,
    length: 3,
    origin: BoardCoordinate(3, 2),
  );

  @override
  Widget build(BuildContext context) {
    return _MiniBoard(
      ships: const [
        _ship,
        ShipEntity(
          id: 1,
          length: 2,
          origin: BoardCoordinate(5, 6),
          orientation: .vertical,
        ),
      ],
      marks: {
        for (final cell in _ship.surroundingCells) cell: .blocked,
      },
    );
  }
}

/// Rule 3 — shooting: a crosshair on the opponent's board among the dots
/// left by earlier misses.
class SeaBattleShootIllustration extends StatelessWidget {
  const SeaBattleShootIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return _MiniBoard(
      marks: {
        const BoardCoordinate(1, 2): .miss,
        const BoardCoordinate(2, 7): .miss,
        const BoardCoordinate(4, 4): .target,
        const BoardCoordinate(6, 1): .miss,
        const BoardCoordinate(7, 6): .miss,
        const BoardCoordinate(8, 3): .miss,
      },
    );
  }
}

/// Rule 4 — a hit earns another shot: two hits in a row and a crosshair
/// lined up for the next one.
class SeaBattleHitAgainIllustration extends StatelessWidget {
  const SeaBattleHitAgainIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return _MiniBoard(
      marks: {
        const BoardCoordinate(2, 6): .miss,
        const BoardCoordinate(4, 3): .hit,
        const BoardCoordinate(4, 4): .hit,
        const BoardCoordinate(4, 5): .target,
        const BoardCoordinate(7, 2): .miss,
      },
    );
  }
}

/// Rule 5 — sinking: a ship hit in every cell, with the cells around it
/// marked as misses automatically.
class SeaBattleSinkIllustration extends StatelessWidget {
  const SeaBattleSinkIllustration({super.key});

  static const _ship = ShipEntity(
    id: 0,
    length: 3,
    origin: BoardCoordinate(3, 3),
  );

  @override
  Widget build(BuildContext context) {
    return _MiniBoard(
      ships: const [_ship],
      marks: {
        for (final cell in _ship.surroundingCells) cell: .miss,
        for (final cell in _ship.cells) cell: .hit,
      },
    );
  }
}

/// Rule 6 — winning: a trophy over the opponent's sunk, faded fleet.
class SeaBattleWinIllustration extends StatelessWidget {
  const SeaBattleWinIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Column(
      mainAxisSize: .min,
      spacing: 24,
      children: [
        Container(
          width: 130,
          height: 130,
          decoration: BoxDecoration(
            color: colors.secondary,
            shape: .circle,
            border: .all(color: colors.white, width: 3),
          ),
          child: Icon(
            Icons.emoji_events_rounded,
            size: 76,
            color: colors.orange,
          ),
        ),
        const Row(
          mainAxisSize: .min,
          spacing: 12,
          children: [
            _SunkShip(length: 3),
            _SunkShip(length: 2),
            _SunkShip(length: 1),
          ],
        ),
      ],
    );
  }
}

/// A full 10×10 board with [ships] and [marks] drawn on it.
class _MiniBoard extends StatelessWidget {
  const _MiniBoard({this.ships = const [], this.marks = const {}});

  final List<ShipEntity> ships;
  final Map<BoardCoordinate, CellMarkType> marks;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const SeaBattleGrid(cellSize: _cellSize),
        for (final ship in ships)
          Positioned(
            left: ship.origin.column * _cellSize,
            top: ship.origin.row * _cellSize,
            child: ShipView(
              length: ship.length,
              cellSize: _cellSize,
              orientation: ship.orientation,
            ),
          ),
        for (final MapEntry(key: cell, value: mark) in marks.entries)
          Positioned(
            left: cell.column * _cellSize,
            top: cell.row * _cellSize,
            child: CellMark(type: mark, cellSize: _cellSize),
          ),
      ],
    );
  }
}

/// A sunk ship: faded out of the battle.
class _SunkShip extends StatelessWidget {
  const _SunkShip({required this.length});

  final int length;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.4,
      child: ShipView(length: length, cellSize: 30),
    );
  }
}
