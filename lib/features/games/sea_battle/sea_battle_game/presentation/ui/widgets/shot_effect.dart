import 'dart:math';

import 'package:bardak/core/extensions/context_extension.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/shot_result.dart';
import 'package:flutter/material.dart';

/// A one-off animation for a fresh shot, drawn over a 3×3 cell area
/// centred on the shot cell: a water splash for a miss, a fiery burst with
/// sparks for a hit, and a bigger one when the ship sinks.
///
/// Give it a key per shot so every new shot plays it from the start.
class ShotEffect extends StatefulWidget {
  const ShotEffect({required this.result, required this.cellSize, super.key});

  final ShotResult result;
  final double cellSize;

  /// How many cells the effect spans on each side.
  static const span = 3;

  @override
  State<ShotEffect> createState() => _ShotEffectState();
}

class _ShotEffectState extends State<ShotEffect>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: switch (widget.result) {
      .miss => const Duration(milliseconds: 1000),
      .hit => const Duration(milliseconds: 550),
      .sunk => const Duration(milliseconds: 800),
    },
  )..forward();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return IgnorePointer(
      child: CustomPaint(
        size: Size.square(widget.cellSize * ShotEffect.span),
        painter: switch (widget.result) {
          .miss => _SplashPainter(
            progress: _controller,
            cellSize: widget.cellSize,
            foam: colors.white,
            water: colors.blue,
          ),
          .hit || .sunk => _BurstPainter(
            progress: _controller,
            cellSize: widget.cellSize,
            isSunk: widget.result == .sunk,
            core: colors.white,
            flame: colors.orange,
            ember: colors.red,
          ),
        },
      ),
    );
  }
}

/// A shell landing in the sea: a burst of spray, droplets thrown up that
/// arc out and fall back, and foam rings spreading on the water.
class _SplashPainter extends CustomPainter {
  _SplashPainter({
    required this.progress,
    required this.cellSize,
    required this.foam,
    required this.water,
  }) : super(repaint: progress);

  final Animation<double> progress;
  final double cellSize;
  final Color foam;
  final Color water;

  /// When the shell hits the water, matching the splash in the sound.
  static const _impact = 0.1;
  static const _droplets = 16;

  /// The part of the animation between [start] and [end], from 0 to 1.
  double _phase(double start, double end) =>
      ((progress.value - start) / (end - start)).clamp(0.0, 1.0);

  @override
  void paint(Canvas canvas, Size size) {
    if (progress.value >= 1) return;
    final center = size.center(Offset.zero);
    final spray = Color.lerp(foam, water, 0.45)!;

    // The shell's shadow closing in just before it lands.
    final fall = _phase(0, _impact);
    if (fall < 1) {
      canvas.drawCircle(
        center,
        cellSize * (0.35 - 0.2 * fall),
        Paint()..color = water.withValues(alpha: 0.35 * fall),
      );
    }

    // Foam rings spreading one after another.
    for (final (start, reach) in [(0.1, 1.25), (0.25, 0.95), (0.42, 0.7)]) {
      final ring = _phase(start, start + 0.55);
      if (ring <= 0 || ring >= 1) continue;
      canvas.drawCircle(
        center,
        cellSize * (0.2 + reach * Curves.easeOut.transform(ring)),
        Paint()
          ..color = foam.withValues(alpha: 0.75 * (1 - ring))
          ..style = .stroke
          ..strokeWidth = cellSize * 0.07 * (1 - ring) + 0.8,
      );
    }

    // The burst of white water where the shell went in.
    final burst = _phase(_impact, 0.45);
    if (burst > 0 && burst < 1) {
      final radius = cellSize * (0.3 + 0.55 * Curves.easeOut.transform(burst));
      canvas.drawCircle(
        center,
        radius,
        Paint()
          ..shader = RadialGradient(
            colors: [
              foam.withValues(alpha: 0.95 * (1 - burst)),
              spray.withValues(alpha: 0.7 * (1 - burst)),
              spray.withValues(alpha: 0),
            ],
          ).createShader(Rect.fromCircle(center: center, radius: radius)),
      );
    }

    // A crown of spray shooting out the moment the shell goes in.
    final crown = _phase(_impact, 0.4);
    if (crown > 0 && crown < 1) {
      final streak = Paint()
        ..color = foam.withValues(alpha: 0.9 * (1 - crown))
        ..strokeWidth = cellSize * 0.08
        ..strokeCap = .round;
      final travel = Curves.easeOut.transform(crown);
      for (var i = 0; i < 8; i++) {
        final direction = Offset(
          cos(i * pi / 4 + 0.2),
          sin(i * pi / 4 + 0.2),
        );
        canvas.drawLine(
          center + direction * cellSize * (0.25 + 0.45 * travel),
          center + direction * cellSize * (0.3 + 0.75 * travel),
          streak,
        );
      }
    }

    // Droplets: thrown up and out, then falling back and shrinking.
    final flight = _phase(_impact, 0.85);
    if (flight > 0 && flight < 1) {
      for (var i = 0; i < _droplets; i++) {
        // Fixed, uneven angles and speeds so the spray looks natural.
        final angle = i * 2 * pi / _droplets + sin(i * 2.3) * 0.25;
        final speed = 0.65 + 0.35 * ((i * 7) % 5) / 4;
        final out = cellSize * 1.2 * speed * Curves.easeOut.transform(flight);
        final height = cellSize * 0.6 * speed * sin(pi * flight);
        final position =
            center + Offset(cos(angle), sin(angle)) * out - Offset(0, height);
        canvas.drawCircle(
          position,
          cellSize * (0.07 + 0.06 * sin(pi * flight)) * speed,
          Paint()
            ..color = (i.isEven ? foam : spray).withValues(
              alpha: 0.95 * (1 - flight * flight),
            ),
        );
      }
    }
  }

  @override
  bool shouldRepaint(_SplashPainter oldDelegate) => false;
}

/// A flash that swells and fades, with sparks flying outwards.
class _BurstPainter extends CustomPainter {
  _BurstPainter({
    required this.progress,
    required this.cellSize,
    required this.isSunk,
    required this.core,
    required this.flame,
    required this.ember,
  }) : super(repaint: progress);

  final Animation<double> progress;
  final double cellSize;
  final bool isSunk;
  final Color core;
  final Color flame;
  final Color ember;

  static const _sparks = 9;

  @override
  void paint(Canvas canvas, Size size) {
    final t = progress.value;
    if (t >= 1) return;
    final center = size.center(Offset.zero);
    final reach = cellSize * (isSunk ? 1.45 : 1.05);

    final flash = Curves.easeOut.transform((t / 0.6).clamp(0.0, 1.0));
    final fade = 1 - Curves.easeIn.transform(t);
    final radius = reach * (0.25 + 0.75 * flash);
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..shader = RadialGradient(
          colors: [
            core.withValues(alpha: fade),
            flame.withValues(alpha: 0.9 * fade),
            ember.withValues(alpha: 0.6 * fade),
            ember.withValues(alpha: 0),
          ],
          stops: const [0, 0.3, 0.7, 1],
        ).createShader(Rect.fromCircle(center: center, radius: radius)),
    );

    final spark = Paint()
      ..strokeCap = .round
      ..strokeWidth = cellSize * 0.07;
    for (var i = 0; i < _sparks; i++) {
      // Fixed, slightly uneven angles so the burst does not look stamped.
      final angle = i * 2 * pi / _sparks + (i.isEven ? 0.2 : -0.15);
      final direction = Offset(cos(angle), sin(angle));
      final travel = Curves.easeOut.transform(t);
      final head = center + direction * reach * (0.3 + 0.8 * travel);
      final tail = center + direction * reach * (0.3 + 0.55 * travel);
      spark.color = Color.lerp(core, flame, t)!.withValues(alpha: fade);
      canvas.drawLine(tail, head, spark);
    }
  }

  @override
  bool shouldRepaint(_BurstPainter oldDelegate) => false;
}
