import 'dart:async';
import 'dart:math';

import 'package:bardak/core/app_ui/sounds/one_shot_sound.dart';
import 'package:bardak/core/app_ui/theme/text_styles/app_text_styles.dart';
import 'package:bardak/core/app_ui/widgets/app_icon_button.dart';
import 'package:bardak/core/app_ui/widgets/countdown_ring.dart';
import 'package:bardak/core/app_ui/widgets/screen_background.dart';
import 'package:bardak/core/app_ui/widgets/show_confirm_sheet.dart';
import 'package:bardak/core/extensions/context_extension.dart';
import 'package:bardak/core/generated/assets/assets.gen.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/board_coordinate.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/fleet_entity.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/sea_battle_entity.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/ship_entity.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/presentation/bloc/sea_battle_game_bloc.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/presentation/bloc/sea_battle_game_event.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/presentation/bloc/sea_battle_game_state.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/presentation/ui/screens/sea_battle_result_screen.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/presentation/ui/widgets/battle_board.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/presentation/ui/widgets/ship_view.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_online/domain/entities/sea_battle_room_entity.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_settings/domain/entities/sea_battle_bot_difficulty.dart';
import 'package:bardak/features/home/presentation/ui/home_screen.dart';
import 'package:bardak/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// Arguments for [SeaBattleGameScreen].
class SeaBattleGameArgs {
  const SeaBattleGameArgs({
    required this.playerFleet,
    this.botDifficulty,
    this.room,
  }) : assert(
         (botDifficulty == null) != (room == null),
         'A battle is either against the bot or online in a room',
       );

  /// The complete fleet the player placed.
  final FleetEntity playerFleet;

  /// The bot's level; set only against the bot.
  final SeaBattleBotDifficulty? botDifficulty;

  /// The room the battle is played in, with who fires first; set only
  /// online.
  final SeaBattleRoomEntity? room;
}

/// The battle: the opponent's board on top to fire at, with their ships
/// still afloat under it; the player's own board below with the
/// opponent's shots on it, and between them an arrow pointing at the board
/// being fired at, with the time left for the shot.
class SeaBattleGameScreen extends StatelessWidget {
  const SeaBattleGameScreen({required this.args, super.key});

  static const routePath = 'seaBattleGame';

  final SeaBattleGameArgs args;

  /// Time to watch the last explosion and the revealed fleet before the
  /// result opens.
  static const _resultDelay = Duration(milliseconds: 1500);

  /// Seconds left from which every second of the player's turn ticks.
  static const _tickingBelow = 5;

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
          // The last seconds of the player's own turn tick, so running out
          // is heard and felt, not only seen.
          listenWhen: (previous, current) {
            final secondsLeft = current.turnSecondsLeft;
            return secondsLeft != null &&
                secondsLeft != previous.turnSecondsLeft &&
                secondsLeft > 0 &&
                secondsLeft <= _tickingBelow &&
                current.battle.turn == .player;
          },
          listener: (context, state) => _tick(context),
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
              child: _BattleArea(),
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

void _tick(BuildContext context) {
  unawaited(HapticFeedback.selectionClick());
  final soundEnabled = context
      .read<SettingsBloc>()
      .state
      .appSettings
      .soundEnabled;
  if (soundEnabled) unawaited(playOneShotSound(Assets.sounds.tick));
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

/// Leaves at once when the battle is over; asks first otherwise.
void _onClose(BuildContext context) {
  final isOver = context.read<SeaBattleGameBloc>().state.battle.isOver;
  if (isOver) {
    context.goNamed(HomeScreen.routePath);
  } else {
    unawaited(_confirmExit(context));
  }
}

/// Close at the top, as back is on other screens; below it the boards
/// with the turn arrow between them, sized to fill the rest: the
/// opponent's as wide as possible with its ships still afloat under it,
/// the player's a little smaller.
class _BattleArea extends StatelessWidget {
  const _BattleArea();

  static const _headerGap = 16.0;
  static const _stripGap = 8.0;
  static const _ownToEnemyRatio = 0.65;

  /// Height the boards need with [cellSize] for the opponent's board.
  static double _heightFor(double cellSize) =>
      _stripGap +
      _EnemyFleetStrip.height +
      _TurnArrow.height +
      cellSize * BoardCoordinate.boardSize * (1 + _ownToEnemyRatio);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: .centerLeft,
          child: AppIconButton.close(onTap: () => _onClose(context)),
        ),
        const SizedBox(height: _headerGap),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              var cellSize = (constraints.maxWidth / BoardCoordinate.boardSize)
                  .floorToDouble();
              while (cellSize > 10 &&
                  _heightFor(cellSize) > constraints.maxHeight) {
                cellSize--;
              }
              final ownCellSize = (cellSize * _ownToEnemyRatio).floorToDouble();

              return Column(
                mainAxisAlignment: .center,
                children: [
                  _EnemyBoard(cellSize: cellSize),
                  const SizedBox(height: _stripGap),
                  const _EnemyFleetStrip(),
                  const _TurnArrow(),
                  _OwnBoard(cellSize: ownCellSize),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

/// Points at the board being fired at — up at the opponent's on the
/// player's turn, down at the player's own on the opponent's — turning
/// over when the turn passes. On timed turns its round head counts the
/// seconds down; once the battle is over, it fades away.
class _TurnArrow extends StatelessWidget {
  const _TurnArrow();

  static const _headSize = 40.0;
  static const _tipLength = 11.0;
  static const _verticalPadding = 6.0;

  /// The strip the arrow takes between the boards.
  static const double height =
      _headSize + _tipLength * 2 + _verticalPadding * 2;

  static const _duration = Duration(milliseconds: 350);

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    final (turn, isOver, secondsLeft) = context
        .select<SeaBattleGameBloc, (SeaBattleSide, bool, int?)>(
          (bloc) => (
            bloc.state.battle.turn,
            bloc.state.battle.isOver,
            bloc.state.turnSecondsLeft,
          ),
        );

    return Semantics(
      label: turn == .player
          ? l10n.sea_battle_your_turn
          : l10n.sea_battle_opponent_turn,
      child: SizedBox(
        height: height,
        child: AnimatedOpacity(
          duration: _duration,
          opacity: isOver ? 0 : 1,
          child: Stack(
            alignment: .center,
            children: [
              AnimatedRotation(
                duration: _duration,
                curve: Curves.easeInOutBack,
                turns: turn == .player ? 0 : 0.5,
                child: CustomPaint(
                  size: const Size(_headSize, _headSize + _tipLength * 2),
                  painter: _ArrowPainter(
                    headRadius: _headSize / 2,
                    tipLength: _tipLength,
                    fill: colors.secondary,
                    stroke: colors.white,
                    shadow: colors.black,
                  ),
                ),
              ),
              // The head stays upright: only the tip turns.
              if (secondsLeft != null)
                CountdownRing(
                  secondsLeft: secondsLeft,
                  totalSeconds: SeaBattleRoomEntity.turnTimeLimit.inSeconds,
                  size: _headSize,
                )
              else
                Icon(Icons.gps_fixed_rounded, size: 20, color: colors.white),
            ],
          ),
        ),
      ),
    );
  }
}

/// A round head with a pointed tip on top, centered in its box so it can
/// be turned over in place.
class _ArrowPainter extends CustomPainter {
  const _ArrowPainter({
    required this.headRadius,
    required this.tipLength,
    required this.fill,
    required this.stroke,
    required this.shadow,
  });

  final double headRadius;
  final double tipLength;
  final Color fill;
  final Color stroke;
  final Color shadow;

  /// Where the tip's sides meet the head, from straight up.
  static const _shoulderAngle = 0.85;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final shoulderX = headRadius * sin(_shoulderAngle);
    final shoulderY = center.dy - headRadius * cos(_shoulderAngle);

    final head = Path()
      ..addOval(Rect.fromCircle(center: center, radius: headRadius));
    final tip = Path()
      ..moveTo(center.dx, center.dy - headRadius - tipLength)
      ..lineTo(center.dx + shoulderX, shoulderY)
      ..lineTo(center.dx - shoulderX, shoulderY)
      ..close();
    final arrow = Path.combine(.union, head, tip);

    canvas
      ..drawShadow(arrow, shadow.withValues(alpha: 0.5), 3, false)
      ..drawPath(arrow, Paint()..color = fill)
      ..drawPath(
        arrow,
        Paint()
          ..color = stroke
          ..style = .stroke
          ..strokeWidth = 2
          ..strokeJoin = .round,
      );
  }

  @override
  bool shouldRepaint(_ArrowPainter oldDelegate) =>
      headRadius != oldDelegate.headRadius ||
      tipLength != oldDelegate.tipLength ||
      fill != oldDelegate.fill ||
      stroke != oldDelegate.stroke ||
      shadow != oldDelegate.shadow;
}

/// One chip per ship size of the opponent's fleet: how many of that size
/// are still afloat, so the player knows what is left to hunt. Their own
/// fleet needs none, as it is in sight on their board.
class _EnemyFleetStrip extends StatelessWidget {
  const _EnemyFleetStrip();

  static const height = 28.0;

  /// Ship sizes from the longest, as the chips are shown.
  static final List<int> _lengths = FleetEntity.shipLengths.toSet().toList()
    ..sort((a, b) => b - a);

  @override
  Widget build(BuildContext context) {
    // The list only changes when a ship sinks, not on every timer tick.
    final sunkShips = context.select<SeaBattleGameBloc, List<ShipEntity>>(
      (bloc) => bloc.state.battle.opponentBoard.sunkShips,
    );
    final afloat = [...FleetEntity.shipLengths];
    for (final ship in sunkShips) {
      afloat.remove(ship.length);
    }

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
      isOwnBoard: false,
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
          isOwnBoard: true,
          lastShot: lastShot?.shooter == .opponent ? lastShot : null,
        );
      },
    );
  }
}
