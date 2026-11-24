import 'dart:async';

import 'package:bardak/core/app_ui/widgets/app_button/app_button.dart';
import 'package:bardak/core/app_ui/widgets/app_screen_header.dart';
import 'package:bardak/core/app_ui/widgets/screen_background.dart';
import 'package:bardak/core/extensions/context_extension.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/board_coordinate.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/presentation/ui/screens/sea_battle_game_screen.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_online/domain/entities/sea_battle_room_entity.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_online/presentation/bloc/online_placement/sea_battle_online_placement_bloc.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_online/presentation/bloc/online_placement/sea_battle_online_placement_event.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_placement/presentation/bloc/ship_placement_bloc.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_placement/presentation/ui/widgets/online_placement.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_placement/presentation/ui/widgets/placement_board.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_placement/presentation/ui/widgets/ship_dock.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_settings/domain/entities/sea_battle_mode.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_settings/presentation/bloc/sea_battle_settings_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// Arguments for [SeaBattlePlacementScreen].
class SeaBattlePlacementArgs {
  const SeaBattlePlacementArgs({required this.mode, this.room});

  /// Decides what confirming the fleet does: start the battle against the
  /// bot, or report "ready" to the online opponent.
  final SeaBattleMode mode;

  /// The room being played in; set only online.
  final SeaBattleRoomEntity? room;
}

/// Lets the player arrange their fleet: drag ships from the dock onto the
/// board, drag them around, tap to rotate, drag back to the dock to take
/// off, or place them all randomly.
///
/// Shared by every mode; [args] changes only the confirm button.
class SeaBattlePlacementScreen extends StatelessWidget {
  const SeaBattlePlacementScreen({required this.args, super.key});

  static const routePath = 'seaBattlePlacement';

  final SeaBattlePlacementArgs args;

  @override
  Widget build(BuildContext context) {
    final isOnline = args.room != null;
    final screen = GradientBackground(
      child: SafeArea(
        child: Padding(
          padding: const .fromLTRB(16, 16, 16, 20),
          child: Column(
            children: [
              AppScreenHeader(
                title: context.l10n.sea_battle_place_ships,
                // Online, leaving closes the room for the other player too.
                onBack: isOnline
                    ? () => unawaited(showLeaveRoomSheet(context))
                    : context.pop,
              ),
              const SizedBox(height: 16),
              const Expanded(child: _PlacementArea()),
              const SizedBox(height: 16),
              _ConfirmButton(mode: args.mode),
            ],
          ),
        ),
      ),
    );
    return isOnline ? OnlinePlacement(child: screen) : screen;
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
        context.read<SeaBattleOnlinePlacementBloc>().add(
          MarkReady(context.read<ShipPlacementBloc>().state.fleet),
        );
    }
  }
}

/// The board and the dock, sized so the board is as large as the space
/// allows.
class _PlacementArea extends StatelessWidget {
  const _PlacementArea();

  /// Between the board and the top of the dock's shuffle button.
  static const _gap = 8.0;

  /// Total height the area needs at [cellSize].
  static double _heightFor(double cellSize) =>
      cellSize * BoardCoordinate.boardSize +
      _gap +
      ShipDock.heightFor(cellSize);

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

        // Right under the header, like the content of other screens; any
        // spare height stays above the button.
        return Column(
          children: [
            PlacementBoard(cellSize: cellSize),
            const SizedBox(height: _gap),
            ShipDock(cellSize: cellSize),
          ],
        );
      },
    );
  }
}
