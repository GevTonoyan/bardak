import 'package:bardak/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';

/// The mark a miss leaves on its cell: the shell's tail sticking out of
/// the water where it went in. With [animateIn] it dives in, in time with
/// the splash; without, it is drawn at rest.
class MissMark extends StatefulWidget {
  const MissMark({
    required this.cellSize,
    this.animateIn = false,
    super.key,
  });

  final double cellSize;
  final bool animateIn;

  @override
  State<MissMark> createState() => _MissMarkState();
}

class _MissMarkState extends State<MissMark>
    with SingleTickerProviderStateMixin {
  /// Only a fresh shot gets one, as long as the splash so the rocket hits
  /// the water with it; the marks already on the board stay still.
  late final AnimationController? _entrance = widget.animateIn
      ? (AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 1000),
        )..forward())
      : null;

  @override
  void dispose() {
    _entrance?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final cellSize = widget.cellSize;

    return IgnorePointer(
      child: CustomPaint(
        size: Size.square(cellSize),
        painter: _RocketPainter(
          entrance: _entrance ?? kAlwaysCompleteAnimation,
          body: Color.lerp(colors.white, colors.shadow, 0.25)!,
          trim: colors.red,
          nozzle: colors.black.withValues(alpha: 0.55),
          water: colors.white,
        ),
      ),
    );
  }
}

/// A shell stuck nose-first in the water at a slant: its tail and fins
/// above the waterline, a ripple ring around it. Along [entrance] it
/// dives in from above, plunges a little too deep and settles back.
class _RocketPainter extends CustomPainter {
  _RocketPainter({
    required this.entrance,
    required this.body,
    required this.trim,
    required this.nozzle,
    required this.water,
  }) : super(repaint: entrance);

  final Animation<double> entrance;
  final Color body;
  final Color trim;
  final Color nozzle;
  final Color water;

  /// The slant from upright, towards the side it came from.
  static const _tilt = 0.5;

  /// How far along the shell's axis it sits past its rest, in cells:
  /// coming in from far above, hitting the water at the splash's impact
  /// (a tenth in), going in too deep, then bobbing back up.
  static final Animatable<double> _depth = TweenSequence<double>([
    TweenSequenceItem(
      tween: Tween<double>(begin: -1.6, end: 0.3),
      weight: 10,
    ),
    TweenSequenceItem(
      tween: Tween<double>(
        begin: 0.3,
        end: -0.06,
      ).chain(CurveTween(curve: Curves.easeOut)),
      weight: 25,
    ),
    TweenSequenceItem(
      tween: Tween<double>(
        begin: -0.06,
        end: 0,
      ).chain(CurveTween(curve: Curves.easeInOut)),
      weight: 15,
    ),
    TweenSequenceItem(tween: ConstantTween<double>(0), weight: 50),
  ]);

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.shortestSide;
    final waterline = Offset(s * 0.5, s * 0.64);
    final depth = _depth.transform(entrance.value) * s;

    // The shell in its own frame: upright, nose down at the waterline,
    // tail up.
    final halfWidth = s * 0.1;
    final tailY = -s * 0.46;
    final hull = RRect.fromLTRBAndCorners(
      -halfWidth,
      tailY,
      halfWidth,
      s * 0.3,
      topLeft: Radius.circular(s * 0.03),
      topRight: Radius.circular(s * 0.03),
      bottomLeft: Radius.circular(halfWidth),
      bottomRight: Radius.circular(halfWidth),
    );
    final trimPaint = Paint()..color = trim;

    canvas
      ..save()
      // Only what is above the water shows.
      ..clipRect(Rect.fromLTRB(-s * 2, -s * 3, s * 3, waterline.dy))
      ..translate(waterline.dx, waterline.dy)
      ..rotate(_tilt)
      ..translate(0, depth)
      ..drawPath(_fin(-1, halfWidth, tailY, s), trimPaint)
      ..drawPath(_fin(1, halfWidth, tailY, s), trimPaint)
      ..drawRRect(hull, Paint()..color = body)
      // A red band around the body, and the dark nozzle at the tail.
      ..drawRect(
        Rect.fromLTRB(-halfWidth, -s * 0.2, halfWidth, -s * 0.13),
        trimPaint,
      )
      ..drawRect(
        Rect.fromLTRB(
          -halfWidth * 0.6,
          tailY - s * 0.04,
          halfWidth * 0.6,
          tailY,
        ),
        Paint()..color = nozzle,
      )
      ..restore()
      // The water ring around where it went in.
      ..drawOval(
        Rect.fromCenter(center: waterline, width: s * 0.56, height: s * 0.16),
        Paint()
          ..color = water.withValues(alpha: 0.45)
          ..style = .stroke
          ..strokeWidth = s * 0.04,
      );
  }

  /// A tail fin swept back from the body, on the left (-1) or right (1).
  static Path _fin(double side, double halfWidth, double tailY, double s) =>
      Path()
        ..moveTo(side * halfWidth, -s * 0.24)
        ..lineTo(side * (halfWidth + s * 0.13), tailY + s * 0.02)
        ..lineTo(side * (halfWidth + s * 0.13), tailY - s * 0.04)
        ..lineTo(side * halfWidth, tailY + s * 0.04)
        ..close();

  @override
  bool shouldRepaint(_RocketPainter oldDelegate) =>
      body != oldDelegate.body ||
      trim != oldDelegate.trim ||
      nozzle != oldDelegate.nozzle ||
      water != oldDelegate.water;
}
