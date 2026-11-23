import 'package:bardak/core/app_ui/theme/text_styles/app_text_styles.dart';
import 'package:bardak/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';

/// The seconds left inside a ring that drains smoothly as they run out:
/// green, then orange at [orangeBelow] and red at [redBelow]. Each digit
/// rolls in from below, and the ring gives a small pulse every second
/// once it is red.
class CountdownRing extends StatefulWidget {
  const CountdownRing({
    required this.secondsLeft,
    required this.totalSeconds,
    this.size = 48,
    this.orangeBelow = 10,
    this.redBelow = 5,
    super.key,
  });

  final int secondsLeft;
  final int totalSeconds;
  final double size;

  /// The ring turns orange at or below this.
  final int orangeBelow;

  /// The ring turns red, and starts pulsing, at or below this.
  final int redBelow;

  @override
  State<CountdownRing> createState() => _CountdownRingState();
}

class _CountdownRingState extends State<CountdownRing>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 350),
  );

  late final Animation<double> _scale = TweenSequence<double>([
    TweenSequenceItem(
      tween: Tween<double>(begin: 1, end: 1.14).chain(
        CurveTween(curve: Curves.easeOut),
      ),
      weight: 35,
    ),
    TweenSequenceItem(
      tween: Tween<double>(begin: 1.14, end: 1).chain(
        CurveTween(curve: Curves.easeIn),
      ),
      weight: 65,
    ),
  ]).animate(_pulse);

  @override
  void didUpdateWidget(CountdownRing oldWidget) {
    super.didUpdateWidget(oldWidget);
    final ticked = widget.secondsLeft < oldWidget.secondsLeft;
    if (ticked && widget.secondsLeft <= widget.redBelow) {
      _pulse.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final secondsLeft = widget.secondsLeft;
    final color = switch (secondsLeft) {
      _ when secondsLeft <= widget.redBelow => colors.red,
      _ when secondsLeft <= widget.orangeBelow => colors.orange,
      _ => colors.green,
    };
    final stroke = widget.size / 12;

    return ScaleTransition(
      scale: _scale,
      child: Container(
        width: widget.size,
        height: widget.size,
        padding: .all(stroke / 2),
        decoration: BoxDecoration(
          color: colors.secondary,
          shape: .circle,
          border: .all(color: colors.white, width: 2),
          boxShadow: [
            BoxShadow(
              color: colors.black.withValues(alpha: 0.25),
              offset: const Offset(0, 3),
              blurRadius: 6,
            ),
          ],
        ),
        child: Stack(
          fit: .expand,
          children: [
            // Each second eases into the next, so the ring drains
            // continuously instead of in steps.
            TweenAnimationBuilder<double>(
              tween: Tween(end: secondsLeft / widget.totalSeconds),
              duration: const Duration(seconds: 1),
              builder: (context, value, _) => TweenAnimationBuilder<Color?>(
                tween: ColorTween(end: color),
                duration: const Duration(milliseconds: 400),
                builder: (context, color, _) => CircularProgressIndicator(
                  value: value,
                  strokeWidth: stroke,
                  strokeCap: .round,
                  color: color,
                  backgroundColor: colors.white20,
                ),
              ),
            ),
            Center(
              child: ClipRect(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  // The new digit rises from below while the old one
                  // leaves upwards.
                  transitionBuilder: (child, animation) => SlideTransition(
                    position: Tween(
                      begin: Offset(
                        0,
                        child.key == ValueKey(secondsLeft) ? 0.6 : -0.6,
                      ),
                      end: Offset.zero,
                    ).animate(animation),
                    child: FadeTransition(opacity: animation, child: child),
                  ),
                  child: Text(
                    '$secondsLeft',
                    key: ValueKey(secondsLeft),
                    style: context.typography.regular20.withNumericFont,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
