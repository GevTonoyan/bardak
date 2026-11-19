import 'dart:async';

import 'package:bardak/core/app_ui/sounds/one_shot_sound.dart';
import 'package:bardak/core/app_ui/widgets/app_icon_button.dart';
import 'package:bardak/core/app_ui/widgets/app_icon_text_button.dart';
import 'package:bardak/core/app_ui/widgets/screen_background.dart';
import 'package:bardak/core/app_ui/widgets/show_confirm_sheet.dart';
import 'package:bardak/core/extensions/context_extension.dart';
import 'package:bardak/core/generated/assets/assets.gen.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/board_coordinate.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/fleet_entity.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/sea_battle_entity.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/presentation/bloc/sea_battle_game_bloc.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/presentation/bloc/sea_battle_game_event.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/presentation/bloc/sea_battle_game_state.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/presentation/ui/screens/sea_battle_result_screen.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/presentation/ui/widgets/battle_board.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/presentation/ui/widgets/ship_view.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_settings/domain/entities/sea_battle_bot_difficulty.dart';
import 'package:bardak/features/home/presentation/ui/home_screen.dart';
import 'package:bardak/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// Arguments for [SeaBattleGameScreen].
class SeaBattleGameArgs {
  const SeaBattleGameArgs({
    required this.playerFleet,
    required this.botDifficulty,
  });

  /// The complete fleet the player placed.
  final FleetEntity playerFleet;
  final SeaBattleBotDifficulty botDifficulty;
}

/// The battle: the opponent's board on top to fire at, the player's own
/// board below with the opponent's shots on it.
class SeaBattleGameScreen extends StatelessWidget {
  const SeaBattleGameScreen({required this.args, super.key});

  static const routePath = 'seaBattleGame';

  final SeaBattleGameArgs args;

  /// Time to watch the last explosion and the revealed fleet before the
  /// result opens.
  static const _resultDelay = Duration(milliseconds: 1500);

  @override
  Widget build(BuildContext context) {
    final isOver = context.select<SeaBattleGameBloc, bool>(
      (bloc) => bloc.state.battle.isOver,
    );

    return MultiBlocListener(
      listeners: [
        BlocListener<SeaBattleGameBloc, SeaBattleGameState>(
          // Every shot, by either side, is heard: a splash, a hit or a
          // sinking.
          listenWhen: (previous, current) =>
              current.battle.lastShot != null &&
              previous.battle.lastShot != current.battle.lastShot,
          listener: (context, state) =>
              _playShotSound(context, state.battle.lastShot!),
        ),
        BlocListener<SeaBattleGameBloc, SeaBattleGameState>(
          listenWhen: (previous, current) =>
              !previous.battle.isOver && current.battle.isOver,
          listener: (context, state) =>
              unawaited(_showResult(context, state.battle)),
        ),
      ],
      child: PopScope(
        // Leaving mid-battle asks first; a finished battle just closes.
        canPop: isOver,
        onPopInvokedWithResult: (didPop, _) {
          if (!didPop) unawaited(_confirmExit(context));
        },
        child: const CalmBackground(
          child: SafeArea(
            child: Padding(
              padding: .fromLTRB(16, 16, 16, 20),
              child: Column(
                children: [
                  _BattleHeader(),
                  SizedBox(height: 16),
                  Expanded(child: _BattleArea()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showResult(BuildContext context, SeaBattleEntity battle) async {
    await Future<void>.delayed(_resultDelay);
    if (!context.mounted) return;

    // The result replaces the battle, so leaving it goes back to the
    // settings.
    context.pushReplacementNamed(
      SeaBattleResultScreen.routePath,
      extra: SeaBattleResultArgs(
        battle: battle,
        botDifficulty: args.botDifficulty,
      ),
    );
  }
}

void _playShotSound(BuildContext context, ShotEntity shot) {
  final soundEnabled = context
      .read<SettingsBloc>()
      .state
      .appSettings
      .soundEnabled;
  if (!soundEnabled) return;

  unawaited(
    playOneShotSound(switch (shot.result) {
      .miss => Assets.sounds.seaBattleMiss,
      .hit => Assets.sounds.seaBattleHit,
      .sunk => Assets.sounds.seaBattleSunk,
    }),
  );
}

/// Confirms before abandoning the battle — same as the other games.
Future<void> _confirmExit(BuildContext context) async {
  final l10n = context.l10n;
  final colors = context.colors;

  await showConfirmSheet(
    context: context,
    title: l10n.exit_game_title,
    description: l10n.exit_game_description,
    confirmText: l10n.exit_game_confirm,
    cancelText: l10n.cancel,
    confirmColor: colors.red,
    cancelColor: colors.green,
    onConfirm: () => context.goNamed(HomeScreen.routePath),
  );
}

/// Close on the left, whose turn it is in the middle.
class _BattleHeader extends StatelessWidget {
  const _BattleHeader();

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: .center,
      children: [
        Align(
          alignment: .centerLeft,
          child: AppIconButton.close(onTap: () => _onClose(context)),
        ),
        const _TurnPill(),
      ],
    );
  }

  void _onClose(BuildContext context) {
    final isOver = context.read<SeaBattleGameBloc>().state.battle.isOver;
    if (isOver) {
      context.goNamed(HomeScreen.routePath);
    } else {
      unawaited(_confirmExit(context));
    }
  }
}

/// Green on the player's turn, orange while the opponent aims; says who
/// won once the battle is over.
class _TurnPill extends StatelessWidget {
  const _TurnPill();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    final (turn, winner) = context
        .select<SeaBattleGameBloc, (SeaBattleSide, SeaBattleSide?)>(
          (bloc) => (bloc.state.battle.turn, bloc.state.battle.winner),
        );

    final (label, color) = switch ((winner, turn)) {
      (.player, _) => (l10n.sea_battle_you_won, colors.green),
      (.opponent, _) => (l10n.sea_battle_you_lost, colors.red),
      (null, .player) => (l10n.sea_battle_your_turn, colors.green),
      (null, .opponent) => (l10n.sea_battle_opponent_turn, colors.orange),
    };

    return AppIconTextButton(
      padding: const .symmetric(horizontal: 18, vertical: 8),
      color: color,
      child: AnimatedSize(
        duration: const Duration(milliseconds: 200),
        child: Text(label, style: context.typography.regular20),
      ),
    );
  }
}

/// Both boards, each under its caption, sized to fill the screen: the
/// opponent's as wide as possible, the player's at half that cell size.
class _BattleArea extends StatelessWidget {
  const _BattleArea();

  static const _gap = 16.0;
  static const _ownToEnemyRatio = 0.5;

  /// Total height the area needs with [cellSize] for the opponent's board.
  static double _heightFor(double cellSize) =>
      _FleetCaption.height * 2 +
      _gap +
      cellSize * BoardCoordinate.boardSize * (1 + _ownToEnemyRatio);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        var cellSize = (constraints.maxWidth / BoardCoordinate.boardSize)
            .floorToDouble();
        while (cellSize > 10 && _heightFor(cellSize) > constraints.maxHeight) {
          cellSize--;
        }
        final ownCellSize = (cellSize * _ownToEnemyRatio).floorToDouble();

        return Column(
          mainAxisAlignment: .center,
          children: [
            _FleetCaption(
              label: context.l10n.sea_battle_enemy_fleet,
              side: .opponent,
            ),
            _EnemyBoard(cellSize: cellSize),
            const SizedBox(height: _gap),
            _FleetCaption(
              label: context.l10n.sea_battle_your_fleet,
              side: .player,
            ),
            _OwnBoard(cellSize: ownCellSize),
          ],
        );
      },
    );
  }
}

/// A board's caption with the fleet still afloat beside it: one small
/// ship per ship, faded once it is sunk.
class _FleetCaption extends StatelessWidget {
  const _FleetCaption({required this.label, required this.side});

  final String label;

  /// Whose fleet the caption is about.
  final SeaBattleSide side;

  static const height = 36.0;
  static const _shipCellSize = 11.0;

  @override
  Widget build(BuildContext context) {
    final sunkIds = context.select<SeaBattleGameBloc, Set<int>>((bloc) {
      final battle = bloc.state.battle;
      final board = side == .player ? battle.playerBoard : battle.opponentBoard;
      return {for (final ship in board.sunkShips) ship.id};
    });

    return SizedBox(
      height: height,
      child: Row(
        children: [
          Text(label, style: context.typography.regular18),
          const SizedBox(width: 12),
          // Shrinks on narrow screens rather than overflowing.
          Expanded(
            child: FittedBox(
              alignment: .centerRight,
              fit: .scaleDown,
              child: Row(
                spacing: 4,
                children: [
                  for (var id = 0; id < FleetEntity.shipCount; id++)
                    Opacity(
                      opacity: sunkIds.contains(id) ? 0.25 : 1,
                      child: ShipView(
                        length: FleetEntity.shipLengths[id],
                        cellSize: _shipCellSize,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// The opponent's board: tap a cell to fire at it on your turn.
class _EnemyBoard extends StatelessWidget {
  const _EnemyBoard({required this.cellSize});

  final double cellSize;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<SeaBattleGameBloc>().state;
    final battle = state.battle;
    final lastShot = battle.lastShot;

    return BattleBoard(
      board: battle.opponentBoard,
      cellSize: cellSize,
      // Shows where the opponent's ships were once the battle is lost.
      revealFleet: battle.isOver,
      lastShot: lastShot?.shooter == .player ? lastShot : null,
      onCellTap: (cell) => _fire(context, cell),
    );
  }

  void _fire(BuildContext context, BoardCoordinate cell) {
    context.read<SeaBattleGameBloc>().add(FireShot(cell));
  }
}

/// The player's own board with the opponent's shots on it.
class _OwnBoard extends StatelessWidget {
  const _OwnBoard({required this.cellSize});

  final double cellSize;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SeaBattleGameBloc, SeaBattleGameState>(
      buildWhen: (previous, current) =>
          previous.battle.playerBoard != current.battle.playerBoard ||
          previous.battle.lastShot != current.battle.lastShot,
      builder: (context, state) {
        final lastShot = state.battle.lastShot;

        return BattleBoard(
          board: state.battle.playerBoard,
          cellSize: cellSize,
          revealFleet: true,
          lastShot: lastShot?.shooter == .opponent ? lastShot : null,
        );
      },
    );
  }
}
