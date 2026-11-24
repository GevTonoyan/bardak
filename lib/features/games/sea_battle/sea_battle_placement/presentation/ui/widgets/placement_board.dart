import 'dart:ui';

import 'package:bardak/core/extensions/context_extension.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/board_coordinate.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/fleet_entity.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/ship_entity.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/presentation/ui/widgets/sea_battle_grid.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/presentation/ui/widgets/ship_view.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_placement/presentation/bloc/ship_placement_bloc.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_placement/presentation/bloc/ship_placement_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// The board as a drop target: shows the placed ships and, while a ship
/// is dragged over it, a green (fits) or red (breaks the rules) preview.
class PlacementBoard extends StatefulWidget {
  const PlacementBoard({required this.cellSize, super.key});

  final double cellSize;

  @override
  State<PlacementBoard> createState() => _PlacementBoardState();
}

class _PlacementBoardState extends State<PlacementBoard> {
  final GlobalKey _gridKey = GlobalKey();
  ShipEntity? _preview;

  /// The dragged ship moved to the cell under its top-left corner.
  ShipEntity? _shipUnderDrag(DragTargetDetails<ShipEntity> details) {
    final box = _gridKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null) return null;

    final local = box.globalToLocal(details.offset);
    return details.data.copyWith(
      origin: BoardCoordinate(
        (local.dy / widget.cellSize).round(),
        (local.dx / widget.cellSize).round(),
      ),
    );
  }

  void _updatePreview(ShipEntity? preview) {
    if (preview == _preview) return;
    setState(() => _preview = preview);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final cellSize = widget.cellSize;
    final fleet = context.select<ShipPlacementBloc, FleetEntity>(
      (bloc) => bloc.state.fleet,
    );

    final preview = _preview;
    final previewFits = preview != null && fleet.canPlace(preview);
    final previewColor = previewFits ? colors.green : colors.red;

    return DragTarget<ShipEntity>(
      onMove: (details) => _updatePreview(_shipUnderDrag(details)),
      onLeave: (_) => _updatePreview(null),
      onAcceptWithDetails: (details) {
        final ship = _shipUnderDrag(details);
        _updatePreview(null);
        if (ship != null) {
          context.read<ShipPlacementBloc>().add(PlaceShip(ship));
        }
      },
      builder: (context, candidateData, rejectedData) {
        return Stack(
          key: _gridKey,
          children: [
            SeaBattleGrid(cellSize: cellSize),
            // How-to hint on the empty board; gone with the first ship.
            if (fleet.ships.isEmpty && preview == null)
              const Positioned.fill(
                child: IgnorePointer(child: Center(child: _BoardHint())),
              ),
            for (final ship in fleet.ships)
              Positioned(
                left: ship.origin.column * cellSize,
                top: ship.origin.row * cellSize,
                child: _PlacedShip(ship: ship, cellSize: cellSize),
              ),
            if (preview != null)
              for (final cell in preview.cells.where((c) => c.isOnBoard))
                Positioned(
                  left: cell.column * cellSize,
                  top: cell.row * cellSize,
                  child: IgnorePointer(
                    child: Container(
                      width: cellSize,
                      height: cellSize,
                      color: previewColor.withValues(alpha: 0.5),
                    ),
                  ),
                ),
          ],
        );
      },
    );
  }
}

/// A frosted pill with a drag-hand icon, floating above the grid lines.
class _BoardHint extends StatelessWidget {
  const _BoardHint();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final borderRadius = BorderRadius.circular(20);

    return Padding(
      padding: const .symmetric(horizontal: 20),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: Container(
            padding: const .symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: colors.white20,
              borderRadius: borderRadius,
              border: .all(color: colors.white30),
            ),
            child: Row(
              mainAxisSize: .min,
              spacing: 10,
              children: [
                Icon(Icons.pan_tool_alt_rounded, color: colors.white, size: 22),
                Flexible(
                  child: Text(
                    context.l10n.sea_battle_placement_hint,
                    style: context.typography.bodyMedium.copyWith(
                      color: colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// A ship on the board: drag to move it, tap to rotate it.
class _PlacedShip extends StatelessWidget {
  const _PlacedShip({required this.ship, required this.cellSize});

  final ShipEntity ship;
  final double cellSize;

  @override
  Widget build(BuildContext context) {
    final view = ShipView(
      length: ship.length,
      cellSize: cellSize,
      orientation: ship.orientation,
    );

    return Draggable<ShipEntity>(
      data: ship,
      feedback: view,
      childWhenDragging: Opacity(opacity: 0.3, child: view),
      child: GestureDetector(
        onTap: () => context.read<ShipPlacementBloc>().add(RotateShip(ship.id)),
        child: view,
      ),
    );
  }
}
