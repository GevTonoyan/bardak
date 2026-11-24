import 'package:bardak/core/app_ui/theme/text_styles/app_text_styles.dart';
import 'package:bardak/core/extensions/context_extension.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/fleet_entity.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/sea_battle_board_entity.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/presentation/bloc/sea_battle_game_bloc.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/presentation/ui/widgets/ship_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// One chip per ship size of the opponent's fleet: how many of that size
/// are still afloat, so the player knows what is left to hunt. Their own
/// fleet needs none, as it is in sight on their board.
class EnemyFleetStrip extends StatelessWidget {
  const EnemyFleetStrip({super.key});

  static const height = 28.0;

  /// Ship sizes from the longest, as the chips are shown.
  static final List<int> _lengths = FleetEntity.shipLengths.toSet().toList()
    ..sort((a, b) => b - a);

  @override
  Widget build(BuildContext context) {
    // The list only changes when a ship sinks, not on every timer tick.
    // The board, unlike a list made from it, stays the same object until
    // a shot lands, so timer ticks do not rebuild the strip.
    final afloat = context
        .select<SeaBattleGameBloc, SeaBattleBoardEntity>(
          (bloc) => bloc.state.battle.opponentBoard,
        )
        .afloatShipLengths;

    // Shrinks on narrow screens rather than overflowing.
    return Semantics(
      label: context.l10n.sea_battle_enemy_fleet,
      child: SizedBox(
        height: height,
        child: FittedBox(
          fit: .scaleDown,
          child: Row(
            spacing: 8,
            children: [
              for (final length in _lengths)
                _ShipCountChip(
                  length: length,
                  afloat: afloat.where((l) => l == length).length,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A ship of [length] with how many of its size are [afloat]; faded once
/// none are left.
class _ShipCountChip extends StatelessWidget {
  const _ShipCountChip({required this.length, required this.afloat});

  final int length;
  final int afloat;

  static const _shipCellSize = 10.0;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return AnimatedOpacity(
      opacity: afloat == 0 ? 0.35 : 1,
      duration: const Duration(milliseconds: 300),
      child: Container(
        padding: const .fromLTRB(8, 3, 8, 3),
        decoration: BoxDecoration(
          color: colors.white10,
          borderRadius: .circular(12),
          border: .all(color: colors.white20),
        ),
        child: Row(
          mainAxisSize: .min,
          spacing: 6,
          children: [
            ShipView(length: length, cellSize: _shipCellSize),
            Text(
              '×$afloat',
              style: context.typography.regular18.withNumericFont,
            ),
          ],
        ),
      ),
    );
  }
}
