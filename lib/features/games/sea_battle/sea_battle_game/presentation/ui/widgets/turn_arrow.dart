import 'dart:math';

import 'package:bardak/core/app_ui/widgets/countdown_ring.dart';
import 'package:bardak/core/extensions/context_extension.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/sea_battle_entity.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/presentation/bloc/sea_battle_game_bloc.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_online/domain/entities/sea_battle_room_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Points at the board being fired at — up at the opponent's on the
/// player's turn, down at the player's own on the opponent's — turning
/// over when the turn passes. On timed turns its round head counts the
/// seconds down; once the battle is over, it fades away.
class TurnArrow extends StatelessWidget {
  const TurnArrow({super.key});

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
