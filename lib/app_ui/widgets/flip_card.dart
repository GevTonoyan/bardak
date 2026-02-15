import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';

class FlipCard extends StatefulWidget {
  const FlipCard({
    required this.isFlipped,
    required this.front,
    required this.back,
    this.duration = const Duration(milliseconds: 450),
    super.key,
  });

  final bool isFlipped;
  final Widget front;
  final Widget back;
  final Duration duration;

  @override
  State<FlipCard> createState() => _FlipCardState();
}

class _FlipCardState extends State<FlipCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    if (widget.isFlipped) _controller.value = 1.0;
  }

  @override
  void didUpdateWidget(covariant FlipCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isFlipped != widget.isFlipped) {
      unawaited(
        widget.isFlipped ? _controller.forward() : _controller.reverse(),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, _) {
        final t = Curves.easeInOutCubic.transform(_controller.value);
        final angle = t * math.pi; // 0..π
        final isBack = angle > math.pi / 2;

        final m = Matrix4.identity()
          ..setEntry(3, 2, 0.0018) // perspective
          ..rotateY(angle);

        return Transform(
          alignment: Alignment.center,
          transform: m,
          child: isBack
              // un-mirror the back side
              ? Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()..rotateY(math.pi),
                  child: widget.back,
                )
              : widget.front,
        );
      },
    );
  }
}
