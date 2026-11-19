import 'dart:async';
import 'dart:math';

import 'package:bardak/core/app_ui/sounds/one_shot_sound.dart';
import 'package:bardak/core/app_ui/theme/text_styles/app_text_styles.dart';
import 'package:bardak/core/app_ui/widgets/app_button/app_button.dart';
import 'package:bardak/core/app_ui/widgets/app_spacings.dart';
import 'package:bardak/core/app_ui/widgets/screen_background.dart';
import 'package:bardak/core/app_ui/widgets/text_with_border.dart';
import 'package:bardak/core/extensions/context_extension.dart';
import 'package:bardak/core/generated/assets/assets.gen.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/fleet_entity.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/sea_battle_entity.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/presentation/ui/widgets/ship_view.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_placement/presentation/ui/sea_battle_placement_screen.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_settings/domain/entities/sea_battle_bot_difficulty.dart';
import 'package:bardak/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// Arguments for [SeaBattleResultScreen].
class SeaBattleResultArgs {
  const SeaBattleResultArgs({
    required this.battle,
    required this.botDifficulty,
  });

  /// The finished battle.
  final SeaBattleEntity battle;
  final SeaBattleBotDifficulty botDifficulty;
}

/// Shown when a battle ends: victory or defeat, and how the player shot.
class SeaBattleResultScreen extends StatefulWidget {
  const SeaBattleResultScreen({required this.args, super.key});

  static const routePath = 'seaBattleResult';

  final SeaBattleResultArgs args;

  @override
  State<SeaBattleResultScreen> createState() => _SeaBattleResultScreenState();
}

class _SeaBattleResultScreenState extends State<SeaBattleResultScreen> {
  late final ConfettiController _confetti = ConfettiController(
    duration: const Duration(seconds: 6),
  );

  bool get _isVictory => widget.args.battle.winner == .player;

  @override
  void initState() {
    super.initState();
    if (!_isVictory) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _confetti.play();

      final soundEnabled = context
          .read<SettingsBloc>()
          .state
          .appSettings
          .soundEnabled;
      if (soundEnabled) unawaited(playOneShotSound(Assets.sounds.winner));
    });
  }

  @override
  void dispose() {
    _confetti.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final args = widget.args;

    return Material(
      child: Stack(
        children: [
          GradientBackground(child: Container()),
          Align(
            alignment: .topCenter,
            child: ConfettiWidget(
              confettiController: _confetti,
              blastDirection: pi / 2,
              blastDirectionality: .explosive,
              maxBlastForce: 15,
              emissionFrequency: 0.05,
              numberOfParticles: 75,
            ),
          ),
          Column(
            children: [
              Expanded(
                child: SafeArea(
                  bottom: false,
                  child: Padding(
                    padding: const .fromLTRB(24, 24, 24, 0),
                    // Scales down on short screens rather than overflowing.
                    child: Center(
                      child: FittedBox(
                        fit: .scaleDown,
                        child: SizedBox(
                          width: 340,
                          child: _ResultSummary(
                            isVictory: _isVictory,
                            args: args,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 280,
                child: ShadowBackground(
                  child: Padding(
                    padding: const .all(20),
                    child: Column(
                      children: [
                        AppButton(
                          label: l10n.play_again,
                          color: colors.green,
                          // A fresh, empty board for the next battle.
                          onPressed: () => context.pushReplacementNamed(
                            SeaBattlePlacementScreen.routePath,
                            extra: const SeaBattlePlacementArgs(mode: .solo),
                          ),
                        ),
                        height20,
                        AppButton(
                          label: l10n.proceed,
                          color: colors.white20,
                          onPressed: () => context.pop(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// The emblem, the headline, the opponent's level and the stats card.
class _ResultSummary extends StatelessWidget {
  const _ResultSummary({required this.isVictory, required this.args});

  final bool isVictory;
  final SeaBattleResultArgs args;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;
    final l10n = context.l10n;

    return Column(
      mainAxisSize: .min,
      children: [
        _ResultEmblem(isVictory: isVictory),
        height20,
        TextWithBorder(
          isVictory ? l10n.sea_battle_victory : l10n.sea_battle_defeat,
          style: typography.regular38,
          textAlign: .center,
        ),
        const SizedBox(height: 8),
        Text(
          isVictory
              ? l10n.sea_battle_victory_subtitle
              : l10n.sea_battle_defeat_subtitle,
          textAlign: .center,
          style: typography.regular20.copyWith(color: colors.white50),
        ),
        const SizedBox(height: 14),
        _DifficultyPill(difficulty: args.botDifficulty),
        const SizedBox(height: 24),
        _StatsCard(battle: args.battle),
      ],
    );
  }
}

/// A trophy for a victory; a ship going down for a defeat.
class _ResultEmblem extends StatelessWidget {
  const _ResultEmblem({required this.isVictory});

  final bool isVictory;

  static const _size = 120.0;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      width: _size,
      height: _size,
      decoration: BoxDecoration(
        color: colors.secondary,
        shape: .circle,
        border: .all(color: colors.white, width: 3),
        boxShadow: [
          BoxShadow(
            color: colors.black.withValues(alpha: 0.25),
            offset: const Offset(0, 6),
            blurRadius: 12,
          ),
        ],
      ),
      clipBehavior: .antiAlias,
      child: isVictory
          ? Icon(Icons.emoji_events_rounded, size: 70, color: colors.orange)
          : const _SinkingShip(size: _size),
    );
  }
}

/// A ship tilted bow-down, half under a band of water.
class _SinkingShip extends StatelessWidget {
  const _SinkingShip({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Stack(
      alignment: .center,
      children: [
        Transform.translate(
          offset: Offset(0, size * 0.08),
          child: Transform.rotate(
            angle: 0.45,
            child: const ShipView(length: 3, cellSize: 26),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          height: size * 0.42,
          child: ColoredBox(color: colors.blue.withValues(alpha: 0.55)),
        ),
      ],
    );
  }
}

/// The bot's level, as a small frosted pill.
class _DifficultyPill extends StatelessWidget {
  const _DifficultyPill({required this.difficulty});

  final SeaBattleBotDifficulty difficulty;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    final level = switch (difficulty) {
      .easy => l10n.sea_battle_difficulty_easy,
      .medium => l10n.sea_battle_difficulty_medium,
      .hard => l10n.sea_battle_difficulty_hard,
    };

    return Container(
      padding: const .symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: colors.white10,
        borderRadius: .circular(20),
        border: .all(color: colors.white30),
      ),
      child: Text(
        '${l10n.sea_battle_bot_difficulty}: $level',
        style: context.typography.bodyMedium.copyWith(color: colors.white),
      ),
    );
  }
}

/// The player's accuracy as a ring, next to shots, hits, ships sunk and
/// ships lost. Everything counts up when the screen opens.
class _StatsCard extends StatelessWidget {
  const _StatsCard({required this.battle});

  final SeaBattleEntity battle;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;

    // The player's shots landed on the opponent's board, and the other
    // way round.
    final targetBoard = battle.opponentBoard;
    final fleetSize = FleetEntity.shipCount;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 1400),
      curve: Curves.easeOutCubic,
      builder: (context, progress, _) {
        int count(int value) => (value * progress).round();

        return Container(
          padding: const .all(20),
          decoration: BoxDecoration(
            color: colors.secondary,
            borderRadius: .circular(20),
            border: .all(color: colors.white30, width: 1.5),
          ),
          child: Row(
            children: [
              _AccuracyRing(rate: targetBoard.hitRate * progress),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  spacing: 16,
                  children: [
                    Row(
                      children: [
                        _StatTile(
                          value: '${count(targetBoard.shotCount)}',
                          label: l10n.sea_battle_shots,
                        ),
                        _StatTile(
                          value: '${count(targetBoard.hitCells.length)}',
                          label: l10n.sea_battle_hits,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        _StatTile(
                          value:
                              '${count(targetBoard.sunkShips.length)}'
                              '/$fleetSize',
                          label: l10n.sea_battle_ships_sunk,
                        ),
                        _StatTile(
                          value:
                              '${count(battle.playerBoard.sunkShips.length)}'
                              '/$fleetSize',
                          label: l10n.sea_battle_ships_lost,
                        ),
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
  }
}

/// A ring filled to [rate] with the percentage inside.
class _AccuracyRing extends StatelessWidget {
  const _AccuracyRing({required this.rate});

  final double rate;

  static const _size = 112.0;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return SizedBox.square(
      dimension: _size,
      child: Stack(
        fit: .expand,
        children: [
          CircularProgressIndicator(
            value: rate,
            strokeWidth: 10,
            strokeCap: .round,
            color: colors.green,
            backgroundColor: colors.white20,
          ),
          Center(
            child: Column(
              mainAxisSize: .min,
              children: [
                Text(
                  '${(rate * 100).round()}%',
                  style: context.typography.regular28.withNumericFont,
                ),
                Text(
                  context.l10n.sea_battle_accuracy,
                  style: context.typography.bodySmall.copyWith(
                    color: colors.white50,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// One number with its caption underneath.
class _StatTile extends StatelessWidget {
  const _StatTile({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(value, style: context.typography.regular28.withNumericFont),
          Text(
            label,
            maxLines: 1,
            overflow: .ellipsis,
            style: context.typography.bodySmall.copyWith(
              color: context.colors.white50,
            ),
          ),
        ],
      ),
    );
  }
}
