import 'dart:math';

import 'package:bardak/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';

/// Three white dots bouncing one after another: waiting on someone else.
class AppWaitingDots extends StatefulWidget {
  const AppWaitingDots({super.key});

  @override
  State<AppWaitingDots> createState() => _AppWaitingDotsState();
}

class _AppWaitingDotsState extends State<AppWaitingDots>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  )..repeat();

  static const _dotCount = 3;
  static const _dotSize = 12.0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) => Row(
        mainAxisSize: .min,
        spacing: 10,
        children: [
          for (var i = 0; i < _dotCount; i++)
            Transform.translate(
              // Each dot rises in turn, a third of a cycle apart.
              offset: Offset(
                0,
                -10 *
                    max(
                      0,
                      sin((_controller.value - i / _dotCount) * 2 * pi),
                    ),
              ),
              child: Container(
                width: _dotSize,
                height: _dotSize,
                decoration: BoxDecoration(
                  color: colors.white,
                  shape: .circle,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
