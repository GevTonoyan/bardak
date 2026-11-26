import 'package:bardak/core/app_ui/widgets/app_icon_button.dart';
import 'package:bardak/core/app_ui/widgets/smart_number_text.dart';
import 'package:bardak/core/extensions/context_extension.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/board_coordinate.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/fleet_entity.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/ship_entity.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/presentation/ui/widgets/ship_view.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_placement/presentation/bloc/ship_placement_bloc.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_placement/presentation/bloc/ship_placement_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// One model per ship type at full board size, each with a count badge of
/// how many are left to place, the clear button on its top-left corner
/// and the shuffle button on its top-right one. Also a drop target:
/// dragging a ship from the board back here takes it off the board.
class ShipDock extends StatelessWidget {
  const ShipDock({required this.cellSize, super.key});

  final double cellSize;

  static const _padding = 12.0;
  static const _rowSpacing = 10.0;
  static const _borderWidth = 1.0;

  /// How far the corner buttons rise above the dock's top edge.
  static const double _buttonOverhang = AppIconButton.size * 0.65;

  /// Room kept clear at each end of the top row so its ships and badges
  /// stay out from under the corner buttons.
  static const double _buttonClearance = AppIconButton.size * 0.6;

  /// The ship types in the dock, two per row: largest first.
  static const _rows = [
    [4, 3],
    [2, 1],
  ];

  /// The dock's height at [cellSize], with the corner buttons above it.
  static double heightFor(double cellSize) =>
      _buttonOverhang + _boxHeightFor(cellSize);

  static double _boxHeightFor(double cellSize) =>
      cellSize * _rows.length + _rowSpacing + _padding * 2 + _borderWidth * 2;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    final fleet = context.select<ShipPlacementBloc, FleetEntity>(
      (bloc) => bloc.state.fleet,
    );
    final unplacedIds = fleet.unplacedShipIds;

    final dock = DragTarget<ShipEntity>(
      onWillAcceptWithDetails: (details) =>
          fleet.ships.any((ship) => ship.id == details.data.id),
      onAcceptWithDetails: (details) => context.read<ShipPlacementBloc>().add(
        RemoveShip(details.data.id),
      ),
      builder: (context, candidateData, rejectedData) {
        final isHovered = candidateData.isNotEmpty;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: double.infinity,
          height: _boxHeightFor(cellSize),
          padding: const .all(_padding),
          decoration: BoxDecoration(
            color: isHovered ? colors.white20 : colors.white10,
            borderRadius: .circular(16),
            border: .all(
              color: isHovered ? colors.white50 : colors.white20,
              width: _borderWidth,
            ),
          ),
          child: Column(
            spacing: _rowSpacing,
            children: [
              for (final row in _rows)
                Padding(
                  padding: .symmetric(
                    horizontal: row == _rows.first ? _buttonClearance : 0,
                  ),
                  child: Row(
                    mainAxisAlignment: .spaceEvenly,
                    children: [
                      for (final length in row)
                        _DockShip(
                          length: length,
                          cellSize: cellSize,
                          unplacedIds: [
                            for (final id in unplacedIds)
                              if (FleetEntity.shipLengths[id] == length) id,
                          ],
                        ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );

    // The buttons sit inside the stack's bounds, so all of both are
    // tappable.
    return Stack(
      children: [
        Padding(
          padding: const .only(top: _buttonOverhang),
          child: dock,
        ),
        Positioned(
          top: 0,
          left: 6,
          child: _ClearButton(isEnabled: fleet.ships.isNotEmpty),
        ),
        const Positioned(top: 0, right: 6, child: _ShuffleButton()),
      ],
    );
  }
}

/// One ship type in the dock. Dragging it places the next ship of that
/// type; once all of them are on the board it fades out.
class _DockShip extends StatelessWidget {
  const _DockShip({
    required this.length,
    required this.cellSize,
    required this.unplacedIds,
  });

  final int length;
  final double cellSize;
  final List<int> unplacedIds;

  @override
  Widget build(BuildContext context) {
    final view = ShipView(length: length, cellSize: cellSize);
    final remaining = unplacedIds.length;

    final ship = remaining == 0
        ? Opacity(opacity: 0.25, child: view)
        : Draggable<ShipEntity>(
            // The origin is replaced by the cell the ship is dropped on.
            data: ShipEntity(
              id: unplacedIds.first,
              length: length,
              origin: const BoardCoordinate(0, 0),
            ),
            feedback: view,
            // Only the dragged one leaves the dock; with more left, the
            // model stays.
            childWhenDragging: remaining == 1
                ? Opacity(opacity: 0.25, child: view)
                : view,
            child: view,
          );

    return Stack(
      clipBehavior: .none,
      children: [
        ship,
        Positioned(
          top: -6,
          right: -8,
          child: _CountBadge(remaining: remaining),
        ),
      ],
    );
  }
}

/// "×N" ships left of a type, or a green check once all are placed.
class _CountBadge extends StatelessWidget {
  const _CountBadge({required this.remaining});

  final int remaining;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isDone = remaining == 0;

    return Container(
      constraints: const BoxConstraints(minWidth: 24),
      height: 20,
      padding: const .symmetric(horizontal: 6),
      decoration: BoxDecoration(
        color: isDone ? colors.green : colors.orange,
        borderRadius: .circular(10),
        border: .all(color: colors.white, width: 1.5),
      ),
      alignment: .center,
      child: isDone
          ? Icon(Icons.check_rounded, color: colors.white, size: 14)
          : SmartNumberText(
              '×$remaining',
              style: context.typography.bodySmall.copyWith(
                color: colors.white,
                height: 1,
              ),
            ),
    );
  }
}

/// The round shuffle button on the dock's corner: places the whole fleet
/// at random.
class _ShuffleButton extends StatelessWidget {
  const _ShuffleButton();

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: context.l10n.sea_battle_shuffle,
      child: AppIconButton(
        onTap: () =>
            context.read<ShipPlacementBloc>().add(const ShuffleShips()),
        child: Icon(
          Icons.shuffle_rounded,
          size: 22,
          color: context.colors.white,
        ),
      ),
    );
  }
}

/// The round clear button on the dock's corner: takes every ship off the
/// board. Faded and inert while the board is empty.
class _ClearButton extends StatelessWidget {
  const _ClearButton({required this.isEnabled});

  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      enabled: isEnabled,
      label: context.l10n.sea_battle_clear,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 150),
        opacity: isEnabled ? 1 : 0.4,
        child: AppIconButton(
          onTap: isEnabled
              ? () => context.read<ShipPlacementBloc>().add(const ClearShips())
              : null,
          child: Icon(
            Icons.delete_outline_rounded,
            size: 22,
            color: context.colors.white,
          ),
        ),
      ),
    );
  }
}
