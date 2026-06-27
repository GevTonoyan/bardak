import 'package:bardak/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';

class GradientBackground extends StatelessWidget {
  const GradientBackground({
    required this.child,
    super.key,
  });

  final Widget child;

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
          child,
        ],
      ),
    );
  }
}

const _edgeH = 60.0;

class ShadowBackground extends StatelessWidget {
  const ShadowBackground({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: .expand,
      children: [
        CustomPaint(painter: _BlackShadowBackground()),
        SafeArea(
          top: false,
          child: Padding(
            padding: const .only(top: _edgeH),
            child: child,
          ),
        ),
      ],
    );
  }
}

class _BlackShadowBackground extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        begin: .topCenter,
        end: .bottomCenter,
        colors: [
          Colors.black.withValues(alpha: 0.3),
          Colors.black.withValues(alpha: 0),
        ],
      ).createShader(Offset.zero & size);

    final path = Path()
      // Start at the left, slightly down from top
      ..moveTo(0, _edgeH * 0.1)
      // The Zig-Zags (X is responsive %, Y is fixed pixels)
      ..lineTo(size.width * 0.23, _edgeH * 0.78)
      ..lineTo(size.width * 0.35, _edgeH * 0.33)
      ..lineTo(size.width * 0.45, _edgeH * 1.12)
      ..lineTo(size.width * 0.50, _edgeH * 0.33)
      ..lineTo(size.width * 0.62, _edgeH * 0.67)
      ..lineTo(size.width * 0.70, 0)
      ..lineTo(size.width * 0.81, _edgeH * 0.67)
      ..lineTo(size.width * 0.93, _edgeH * 0.78)
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
