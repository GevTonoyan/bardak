import 'dart:ui';

import 'package:bardak/core/app_ui/widgets/app_button/app_button.dart';
import 'package:bardak/core/app_ui/widgets/app_icon_button.dart';
import 'package:bardak/core/app_ui/widgets/app_icon_text_button.dart';
import 'package:bardak/core/app_ui/widgets/screen_background.dart';
import 'package:bardak/core/app_ui/widgets/smart_number_text.dart';
import 'package:bardak/core/extensions/context_extension.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/board_coordinate.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/fleet_entity.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/ship_entity.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/presentation/ui/screens/sea_battle_game_screen.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/presentation/ui/widgets/sea_battle_grid.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/presentation/ui/widgets/ship_view.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_placement/presentation/bloc/ship_placement_bloc.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_placement/presentation/bloc/ship_placement_event.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_settings/domain/entities/sea_battle_mode.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_settings/presentation/bloc/sea_battle_settings_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// Arguments for [SeaBattlePlacementScreen].
class SeaBattlePlacementArgs {
  const SeaBattlePlacementArgs({required this.mode});

  /// Decides what confirming the fleet does: start the battle against the
  /// bot, or report "ready" to the online opponent.
  final SeaBattleMode mode;
}

/// Lets the player arrange their fleet: drag ships from the dock onto the
/// board, drag them around, tap to rotate, or place them randomly.
///
/// Shared by every mode; [args] changes only the confirm button.
class SeaBattlePlacementScreen extends StatelessWidget {
  const SeaBattlePlacementScreen({required this.args, super.key});

  static const routePath = 'seaBattlePlacement';

  final SeaBattlePlacementArgs args;

  /// Ring width of the Shuffle / Clear pills, thinner than the app default
  /// to sit calmly next to the board.
  static const buttonBorderWidth = 1.5;

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: SafeArea(
        child: Padding(
          padding: const .fromLTRB(16, 16, 16, 20),
          child: Column(
            children: [
              const _PlacementHeader(),
              const SizedBox(height: 16),
              const Expanded(child: _PlacementArea()),
              const SizedBox(height: 16),
              _ConfirmButton(mode: args.mode),
            ],
          ),
        ),
      ),
    );
  }
}

/// Back on the left and the title centered on the screen.
class _PlacementHeader extends StatelessWidget {
  const _PlacementHeader();

  /// Matches the back button, so the title stays truly centered.
  static const _sideWidth = 40.0;

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 10,
      children: [
        AppIconButton.back(onTap: context.pop),
        Expanded(
          child: FittedBox(
            fit: .scaleDown,
            child: Text(
              context.l10n.sea_battle_place_ships,
              style: context.typography.regular24,
            ),
          ),
        ),
        const SizedBox(width: _sideWidth),
      ],
    );
  }
}

/// Green; disabled (dimmed) until the whole fleet is on the board.
class _ConfirmButton extends StatelessWidget {
  const _ConfirmButton({required this.mode});

  final SeaBattleMode mode;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    final isComplete = context.select<ShipPlacementBloc, bool>(
      (bloc) => bloc.state.fleet.isComplete,
    );

    return AppButton(
      label: switch (mode) {
        .solo => l10n.sea_battle_start,
        .online => l10n.sea_battle_ready,
      },
      color: colors.green,
      onPressed: isComplete ? () => _confirm(context) : null,
    );
  }

  void _confirm(BuildContext context) {
    switch (mode) {
      case .solo:
        // The battle replaces placement, so leaving it goes back to the
        // settings rather than to a finished placement.
        context.pushReplacementNamed(
          SeaBattleGameScreen.routePath,
          extra: SeaBattleGameArgs(
            playerFleet: context.read<ShipPlacementBloc>().state.fleet,
            botDifficulty: context
                .read<SeaBattleSettingsBloc>()
                .state
                .seaBattleSettings
                .botDifficulty,
          ),
        );
      case .online:
        // TODO(Gevorg): report ready to the opponent once online play
        // exists.
        break;
    }
  }
}

/// The board, the Random / Clear toolbar and the dock, sized so the board
/// is as large as the space allows.
class _PlacementArea extends StatelessWidget {
  const _PlacementArea();

  static const _gap = 12.0;

  /// Total height the area needs at [cellSize].
  static double _heightFor(double cellSize) =>
      cellSize * BoardCoordinate.boardSize +
      _gap * 2 +
      _PlacementToolbar.height +
      _ShipDock.heightFor(cellSize);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Start from the widest board that fits, then shrink until the
        // dock (which uses the same cell size) fits below it too.
        var cellSize = (constraints.maxWidth / BoardCoordinate.boardSize)
            .floorToDouble();
        while (cellSize > 10 && _heightFor(cellSize) > constraints.maxHeight) {
          cellSize--;
        }

        // On tall screens the spare height is split above and below
        // instead of pooling over the button.
        return Column(
          mainAxisAlignment: .center,
          children: [
            _PlacementBoard(cellSize: cellSize),
            const SizedBox(height: _gap),
            const _PlacementToolbar(),
            const SizedBox(height: _gap),
            _ShipDock(cellSize: cellSize),
          ],
        );
      },
    );
  }
}

/// Small pill buttons under the board: Shuffle on the left, Clear on the
/// right.
class _PlacementToolbar extends StatelessWidget {
  const _PlacementToolbar();

  static const height = 40.0;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    final hasShips = context.select<ShipPlacementBloc, bool>(
      (bloc) => bloc.state.fleet.ships.isNotEmpty,
    );

    return SizedBox(
      height: height,
      child: Row(
        children: [
          _ToolbarButton(
            icon: Icons.shuffle_rounded,
            label: l10n.sea_battle_shuffle,
            onTap: () =>
                context.read<ShipPlacementBloc>().add(const ShuffleShips()),
          ),
          const Spacer(),
          Opacity(
            opacity: hasShips ? 1 : 0.4,
            child: _ToolbarButton(
              icon: Icons.delete_outline_rounded,
              label: l10n.sea_battle_clear,
              onTap: hasShips
                  ? () => context.read<ShipPlacementBloc>().add(
                      const ClearShips(),
                    )
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}

/// A pill with an icon and a short label.
class _ToolbarButton extends StatelessWidget {
  const _ToolbarButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return AppIconTextButton(
      onTap: onTap,
      borderWidth: SeaBattlePlacementScreen.buttonBorderWidth,
      padding: const .symmetric(horizontal: 14, vertical: 6),
      child: Row(
        mainAxisSize: .min,
        spacing: 6,
        children: [
          Icon(icon, color: colors.white, size: 18),
          Text(label, style: context.typography.regular18),
        ],
      ),
    );
  }
}

/// The board as a drop target: shows the placed ships and, while a ship
/// is dragged over it, a green (fits) or red (breaks the rules) preview.
class _PlacementBoard extends StatefulWidget {
  const _PlacementBoard({required this.cellSize});

  final double cellSize;

  @override
  State<_PlacementBoard> createState() => _PlacementBoardState();
}

class _PlacementBoardState extends State<_PlacementBoard> {
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

/// One model per ship type at full board size, each with a count badge of
/// how many are left to place. Also a drop target: dragging a ship from
/// the board back here takes it off the board.
class _ShipDock extends StatelessWidget {
  const _ShipDock({required this.cellSize});

  final double cellSize;

  static const _padding = 12.0;
  static const _rowSpacing = 10.0;
  static const _borderWidth = 1.0;

  /// The ship types in the dock, two per row: largest first.
  static const _rows = [
    [4, 3],
    [2, 1],
  ];

  /// The dock's height at [cellSize].
  static double heightFor(double cellSize) =>
      cellSize * _rows.length + _rowSpacing + _padding * 2 + _borderWidth * 2;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    final fleet = context.select<ShipPlacementBloc, FleetEntity>(
      (bloc) => bloc.state.fleet,
    );
    final unplacedIds = fleet.unplacedShipIds;

    return DragTarget<ShipEntity>(
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
          height: heightFor(cellSize),
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
                Row(
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
            ],
          ),
        );
      },
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
