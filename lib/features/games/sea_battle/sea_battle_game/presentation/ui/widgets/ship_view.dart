import 'dart:math';

import 'package:bardak/core/extensions/context_extension.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/ship_orientation.dart';
import 'package:flutter/material.dart';

/// A ship drawn [length] cells long, at the given [cellSize].
///
/// Each length is its own warship seen from above: a battleship (4), a
/// cruiser (3), a destroyer (2) and a patrol boat (1).
///
/// Shared by the board, the placement dock and drag feedback, so a ship
/// looks the same wherever it is.
class ShipView extends StatelessWidget {
  const ShipView({
    required this.length,
    required this.cellSize,
    this.orientation = ShipOrientation.horizontal,
    super.key,
  });

  final int length;
  final double cellSize;
  final ShipOrientation orientation;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final long = cellSize * length;
    final isHorizontal = orientation == ShipOrientation.horizontal;

    return CustomPaint(
      size: isHorizontal ? Size(long, cellSize) : Size(cellSize, long),
      painter: _ShipPainter(
        length: length,
        orientation: orientation,
        palette: _ShipPalette(
          deck: colors.white,
          steel: colors.shadow,
          detail: colors.secondary,
          shadow: colors.black,
        ),
      ),
    );
  }
}

/// The colors a ship is painted with, all derived from theme tokens.
@immutable
class _ShipPalette {
  _ShipPalette({
    required this.deck,
    required this.steel,
    required this.detail,
    required Color shadow,
  }) : deckShade = Color.lerp(deck, steel, 0.55)!,
       steelDark = Color.lerp(steel, shadow, 0.35)!,
       detailDark = Color.lerp(detail, shadow, 0.35)!,
       shadow = shadow.withValues(alpha: 0.4);

  /// Light deck planks.
  final Color deck;

  /// Lower edge of the deck gradient.
  final Color deckShade;

  /// Hull side and superstructure.
  final Color steel;
  final Color steelDark;

  /// Turrets, funnels, windows and outlines.
  final Color detail;
  final Color detailDark;

  final Color shadow;

  @override
  bool operator ==(Object other) =>
      other is _ShipPalette &&
      other.deck == deck &&
      other.steel == steel &&
      other.detail == detail &&
      other.shadow == shadow;

  @override
  int get hashCode => Object.hash(deck, steel, detail, shadow);
}

class _ShipPainter extends CustomPainter {
  const _ShipPainter({
    required this.length,
    required this.orientation,
    required this.palette,
  });

  final int length;
  final ShipOrientation orientation;
  final _ShipPalette palette;

  @override
  void paint(Canvas canvas, Size size) {
    // Everything is drawn bow-right in "cell" units; a vertical ship is
    // the same drawing turned so the bow points down.
    var hullSize = size;
    if (orientation == ShipOrientation.vertical) {
      canvas
        ..translate(size.width, 0)
        ..rotate(pi / 2);
      hullSize = Size(size.height, size.width);
    }
    final cell = hullSize.height;

    _paintHull(canvas, hullSize, cell);

    switch (length) {
      case 1:
        _paintPatrolBoat(canvas, cell);
      case 2:
        _paintDestroyer(canvas, cell);
      case 3:
        _paintCruiser(canvas, cell);
      default:
        _paintBattleship(canvas, cell);
    }
  }

  // ---------------------------------------------------------------------
  // Hull
  // ---------------------------------------------------------------------

  void _paintHull(Canvas canvas, Size size, double cell) {
    final outer = _hullPath(size, cell, inset: 0);
    final deck = _hullPath(size, cell, inset: cell * 0.075);
    final outline = Paint()
      ..color = palette.detail
      ..style = PaintingStyle.stroke
      ..strokeWidth = max(1.2, cell * 0.045)
      ..strokeJoin = StrokeJoin.round;

    canvas
      // Soft drop shadow on the water.
      ..drawPath(
        outer.shift(Offset(cell * 0.03, cell * 0.07)),
        Paint()
          ..color = palette.shadow
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, cell * 0.06),
      )
      // Hull side: the steel rim around the deck.
      ..drawPath(
        outer,
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [palette.steel, palette.steelDark],
          ).createShader(Offset.zero & size),
      )
      // Deck.
      ..drawPath(
        deck,
        Paint()
          ..shader = LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [palette.deck, palette.deck, palette.deckShade],
            stops: const [0, 0.35, 1],
          ).createShader(Offset.zero & size),
      )
      // Planks along the deck, clipped to it.
      ..save()
      ..clipPath(deck);
    final plank = Paint()
      ..color = palette.steel.withValues(alpha: 0.45)
      ..strokeWidth = max(0.6, cell * 0.012);
    for (final y in [0.36, 0.5, 0.64]) {
      canvas.drawLine(
        Offset(0, cell * y),
        Offset(size.width, cell * y),
        plank,
      );
    }
    canvas
      ..restore()
      ..drawPath(outer, outline);
  }

  /// The hull outline, shrunk by [inset] for the deck inside the rim:
  /// a rounded square-ish stern on the left, a long curved bow on the
  /// right.
  Path _hullPath(Size size, double cell, {required double inset}) {
    final top = cell * 0.13 + inset;
    final bottom = cell * 0.87 - inset;
    final middle = cell / 2;
    final stern = cell * 0.08 + inset;
    final tip = size.width - cell * 0.04 - inset * 1.8;
    final bowLength = cell * (length == 1 ? 0.42 : 0.8);
    final bowStart = tip - bowLength + inset;
    final corner = cell * 0.2;

    return Path()
      ..moveTo(stern + corner, top)
      ..lineTo(bowStart, top)
      ..cubicTo(
        bowStart + bowLength * 0.55,
        top,
        tip - cell * 0.06,
        middle - cell * 0.1,
        tip,
        middle,
      )
      ..cubicTo(
        tip - cell * 0.06,
        middle + cell * 0.1,
        bowStart + bowLength * 0.55,
        bottom,
        bowStart,
        bottom,
      )
      ..lineTo(stern + corner, bottom)
      ..quadraticBezierTo(stern, bottom, stern, bottom - corner)
      ..lineTo(stern, top + corner)
      ..quadraticBezierTo(stern, top, stern + corner, top)
      ..close();
  }

  // ---------------------------------------------------------------------
  // Ship types (x positions are in cells from the stern)
  // ---------------------------------------------------------------------

  void _paintBattleship(Canvas canvas, double cell) {
    _paintTurret(canvas, cell, x: 0.62, facesBow: false, isDouble: true);
    _paintFunnel(canvas, cell, x: 1.25);
    _paintBridge(canvas, cell, x: 1.85, width: 0.75);
    _paintTurret(canvas, cell, x: 2.6, isDouble: true);
    _paintTurret(canvas, cell, x: 3.2, isDouble: true);
  }

  void _paintCruiser(Canvas canvas, double cell) {
    _paintTurret(canvas, cell, x: 0.58, facesBow: false);
    _paintFunnel(canvas, cell, x: 1.15);
    _paintBridge(canvas, cell, x: 1.7, width: 0.62);
    _paintTurret(canvas, cell, x: 2.35);
  }

  void _paintDestroyer(Canvas canvas, double cell) {
    _paintDepthCharges(canvas, cell, x: 0.32);
    _paintBridge(canvas, cell, x: 0.85, width: 0.5);
    _paintTurret(canvas, cell, x: 1.42, scale: 0.85);
  }

  void _paintPatrolBoat(Canvas canvas, double cell) {
    _paintCabin(canvas, cell, x: 0.38);
    _paintTurret(canvas, cell, x: 0.68, scale: 0.6);
  }

  // ---------------------------------------------------------------------
  // Parts
  // ---------------------------------------------------------------------

  /// A round gun turret whose barrels point at the bow (or the stern).
  void _paintTurret(
    Canvas canvas,
    double cell, {
    required double x,
    bool facesBow = true,
    bool isDouble = false,
    double scale = 1,
  }) {
    final center = Offset(cell * x, cell / 2);
    final radius = cell * 0.15 * scale;
    final direction = facesBow ? 1 : -1;
    final barrelLength = cell * 0.3 * scale;
    final barrel = Paint()
      ..color = palette.detailDark
      ..strokeWidth = cell * 0.045 * scale
      ..strokeCap = StrokeCap.round;

    final offsets = isDouble ? [-0.045, 0.045] : [0.0];
    for (final dy in offsets) {
      final start = center.translate(0, cell * dy * scale);
      canvas.drawLine(
        start,
        start.translate(direction * (radius + barrelLength), 0),
        barrel,
      );
    }

    canvas
      ..drawCircle(center, radius, Paint()..color = palette.detail)
      ..drawCircle(
        center,
        radius,
        Paint()
          ..color = palette.detailDark
          ..style = PaintingStyle.stroke
          ..strokeWidth = max(0.8, cell * 0.025),
      )
      // Hatch on top, with a glint.
      ..drawCircle(
        center.translate(-direction * radius * 0.25, 0),
        radius * 0.38,
        Paint()..color = palette.detailDark,
      )
      ..drawCircle(
        center.translate(-radius * 0.35, -radius * 0.4),
        radius * 0.2,
        Paint()..color = palette.deck.withValues(alpha: 0.55),
      );
  }

  /// A two-tier superstructure with a window strip facing the bow and a
  /// radar dish on top.
  void _paintBridge(
    Canvas canvas,
    double cell, {
    required double x,
    required double width,
  }) {
    final center = Offset(cell * x, cell / 2);
    final lower = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: center,
        width: cell * width,
        height: cell * 0.48,
      ),
      Radius.circular(cell * 0.09),
    );
    final upper = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: center.translate(cell * width * 0.08, 0),
        width: cell * width * 0.62,
        height: cell * 0.32,
      ),
      Radius.circular(cell * 0.07),
    );
    final edge = Paint()
      ..color = palette.detail
      ..style = PaintingStyle.stroke
      ..strokeWidth = max(0.8, cell * 0.025);

    canvas
      ..drawRRect(lower, Paint()..color = palette.steel)
      ..drawRRect(lower, edge)
      ..drawRRect(upper, Paint()..color = palette.deck)
      ..drawRRect(upper, edge)
      // Window strip along the front of the upper tier.
      ..drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            upper.right - cell * 0.09,
            upper.top + cell * 0.05,
            cell * 0.05,
            upper.height - cell * 0.1,
          ),
          Radius.circular(cell * 0.02),
        ),
        Paint()..color = palette.detail,
      )
      // Radar dish.
      ..drawCircle(
        center.translate(-cell * width * 0.12, 0),
        cell * 0.06,
        Paint()..color = palette.detailDark,
      );
  }

  /// An oval smokestack with a dark opening.
  void _paintFunnel(Canvas canvas, double cell, {required double x}) {
    final center = Offset(cell * x, cell / 2);
    final body = Rect.fromCenter(
      center: center,
      width: cell * 0.34,
      height: cell * 0.26,
    );
    canvas
      ..drawOval(body, Paint()..color = palette.detail)
      ..drawOval(
        body.deflate(cell * 0.045),
        Paint()..color = palette.detailDark,
      );
  }

  /// A small enclosed cabin with a curved windshield facing the bow.
  void _paintCabin(Canvas canvas, double cell, {required double x}) {
    final cabin = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(cell * x, cell / 2),
        width: cell * 0.3,
        height: cell * 0.4,
      ),
      Radius.circular(cell * 0.08),
    );
    canvas
      ..drawRRect(cabin, Paint()..color = palette.steel)
      ..drawRRect(
        cabin,
        Paint()
          ..color = palette.detail
          ..style = PaintingStyle.stroke
          ..strokeWidth = max(0.8, cell * 0.025),
      )
      ..drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            cabin.right - cell * 0.09,
            cabin.top + cell * 0.05,
            cell * 0.05,
            cabin.height - cell * 0.1,
          ),
          Radius.circular(cell * 0.02),
        ),
        Paint()..color = palette.detail,
      );
  }

  /// Two depth-charge racks on the stern.
  void _paintDepthCharges(Canvas canvas, double cell, {required double x}) {
    final paint = Paint()..color = palette.detail;
    for (final dy in [-0.13, 0.13]) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset(cell * x, cell * (0.5 + dy)),
            width: cell * 0.22,
            height: cell * 0.1,
          ),
          Radius.circular(cell * 0.05),
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_ShipPainter oldDelegate) =>
      oldDelegate.length != length ||
      oldDelegate.orientation != orientation ||
      oldDelegate.palette != palette;
}
