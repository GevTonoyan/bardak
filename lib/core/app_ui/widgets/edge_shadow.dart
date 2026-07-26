import 'package:flutter/material.dart';

/// A drop shadow whose fill area is clipped out, leaving only the offset
/// spillover.
///
/// A plain [BoxShadow] paints a full-size blurred rect behind its box; an
/// opaque box hides the part directly behind it, but a translucent box (e.g.
/// `white20`) lets it bleed through — showing a dark rectangle inside the box
/// instead of a clean edge. Clipping away the box rect reproduces that
/// occlusion geometrically, so the result is identical for opaque colors and
/// correct for translucent ones.
///
/// Stack this behind the surface it belongs to, matched to the same `height`
/// and border [radius].
class EdgeShadow extends StatelessWidget {
  const EdgeShadow({
    required this.height,
    required this.offset,
    required this.alpha,
    this.radius = 12,
    super.key,
  });

  final double height;
  final Offset offset;
  final double alpha;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: _ShadowOnlyClipper(radius: radius),
      child: Container(
        height: height,
        width: double.maxFinite,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          boxShadow: [
            BoxShadow(
              offset: offset,
              color: Colors.black.withValues(alpha: alpha),
              blurRadius: 2,
            ),
          ],
        ),
      ),
    );
  }
}

/// Clips out the rounded-rect box area, keeping everything around it so only
/// the offset/blurred shadow spillover is painted.
class _ShadowOnlyClipper extends CustomClipper<Path> {
  const _ShadowOnlyClipper({required this.radius});

  final double radius;

  @override
  Path getClip(Size size) {
    // Inflate generously so the offset + blurred shadow is never clipped.
    const margin = 40.0;
    final outer = Rect.fromLTWH(
      -margin,
      -margin,
      size.width + margin * 2,
      size.height + margin * 2,
    );
    final box = RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(radius),
    );
    return Path()
      ..addRect(outer)
      ..addRRect(box)
      ..fillType = PathFillType.evenOdd;
  }

  @override
  bool shouldReclip(_ShadowOnlyClipper oldClipper) =>
      oldClipper.radius != radius;
}
