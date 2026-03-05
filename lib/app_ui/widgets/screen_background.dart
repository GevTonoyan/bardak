import 'package:alias_pro/utils/extensions/context_extension.dart';
import 'package:flutter/material.dart';

class ScreenBackground extends StatelessWidget {
  const ScreenBackground({
    required this.child,
    this.shadowHeight,
    super.key,
  });

  final Widget child;
  final double? shadowHeight;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(gradient: context.colors.main),
            ),
          ),
          if (shadowHeight != null)
            Align(
              alignment: .bottomCenter,
              child: SizedBox(
                height: shadowHeight,
                width: double.infinity,
                child: CustomPaint(painter: _BlackShadowBackground()),
              ),
            ),
          child,
        ],
      ),
    );
  }
}

class _BlackShadowBackground extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.black.withValues(alpha: 0.3),
          Colors.black.withValues(alpha: 0),
        ],
      ).createShader(Offset.zero & size);

    // We use fixed Y values for the "teeth" so they don't squash
    const edgeH = 60.0;

    final path = Path()
      // Start at the left, slightly down from top
      ..moveTo(0, edgeH * 0.1)
      // The Zig-Zags (X is responsive %, Y is fixed pixels)
      ..lineTo(size.width * 0.23, edgeH * 0.78)
      ..lineTo(size.width * 0.35, edgeH * 0.33)
      ..lineTo(size.width * 0.45, edgeH * 1.12)
      ..lineTo(size.width * 0.50, edgeH * 0.33)
      ..lineTo(size.width * 0.62, edgeH * 0.67)
      ..lineTo(size.width * 0.70, 0)
      ..lineTo(size.width * 0.81, edgeH * 0.67)
      ..lineTo(size.width * 0.93, edgeH * 0.78)
      ..lineTo(size.width, 0)
      // Draw the rest of the box to the bottom of the widget
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
