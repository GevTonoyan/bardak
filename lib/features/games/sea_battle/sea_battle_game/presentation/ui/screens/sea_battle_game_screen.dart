import 'dart:async';

import 'package:bardak/core/app_ui/sounds/one_shot_sound.dart';
import 'package:bardak/core/app_ui/widgets/app_icon_button.dart';
import 'package:bardak/core/app_ui/widgets/app_notification.dart';
import 'package:bardak/core/app_ui/widgets/screen_background.dart';
import 'package:bardak/core/app_ui/widgets/show_confirm_sheet.dart';
import 'package:bardak/core/extensions/context_extension.dart';
import 'package:bardak/core/generated/assets/assets.gen.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/board_coordinate.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/fleet_entity.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/sea_battle_board_entity.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/sea_battle_entity.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/presentation/bloc/sea_battle_game_bloc.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/presentation/bloc/sea_battle_game_event.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/presentation/bloc/sea_battle_game_state.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/presentation/ui/screens/sea_battle_result_screen.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/presentation/ui/widgets/battle_board.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/presentation/ui/widgets/enemy_fleet_strip.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/presentation/ui/widgets/turn_arrow.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_online/domain/entities/sea_battle_room_entity.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_settings/domain/entities/sea_battle_bot_difficulty.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_settings/presentation/ui/sea_battle_settings_screen.dart';
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
    final isPlaying = context.select<SeaBattleGameBloc, bool>(
      (bloc) => bloc.state.isPlaying,
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
          // Online the battle can stop early: back to the settings, with
          // why.
          listenWhen: (previous, current) =>
              previous.interruption == null && current.interruption != null,
          listener: (context, state) {
            unawaited(
              showAppNotification(
                context,
                message: switch (state.interruption!) {
                  .left => context.l10n.sea_battle_opponent_left,
                  .connection => context.l10n.sea_battle_connection_lost,
                },
              ),
            );
            context.goNamed(SeaBattleSettingsScreen.routePath);
          },
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
        canPop: !isPlaying,
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
  // A light tap as the shell meets the water, so a miss is felt too.
  if (shot.result == .miss) unawaited(HapticFeedback.lightImpact());

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
/// Online, leaving ends it for the opponent too.
Future<void> _confirmExit(BuildContext context) async {
  await showExitGameSheet(
    context: context,
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
      EnemyFleetStrip.height +
      TurnArrow.height +
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
                  const EnemyFleetStrip(),
                  const TurnArrow(),
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

/// The opponent's board: tap a cell to fire at it on your turn.
class _EnemyBoard extends StatelessWidget {
  const _EnemyBoard({required this.cellSize});

  final double cellSize;

  @override
  Widget build(BuildContext context) {
    // Only what is drawn: the countdown ticking must not rebuild the
    // board.
    final (board, lastShot) = context
        .select<SeaBattleGameBloc, (SeaBattleBoardEntity, ShotEntity?)>(
          (bloc) =>
              (bloc.state.battle.opponentBoard, bloc.state.battle.lastShot),
        );

    return BattleBoard(
      board: board,
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
