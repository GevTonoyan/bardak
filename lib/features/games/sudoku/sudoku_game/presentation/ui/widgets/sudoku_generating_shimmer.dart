import 'package:bardak/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';

/// A soft diagonal light sweep played over the empty grid while a puzzle
/// is generated. No label — the wait is at most about a second.
class SudokuGeneratingShimmer extends StatefulWidget {
  const SudokuGeneratingShimmer({super.key});

  @override
  State<SudokuGeneratingShimmer> createState() =>
      _SudokuGeneratingShimmerState();
}

class _SudokuGeneratingShimmerState extends State<SudokuGeneratingShimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          // A band of light sweeps from top-left to bottom-right and
          // repeats; the -0.4 -> 1.4 range keeps it fully off-screen at
          // both ends.
          final t = -0.4 + _controller.value * 1.8;
          return DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: .topLeft,
                end: .bottomRight,
                stops: [
                  (t - 0.25).clamp(0.0, 1.0),
                  t.clamp(0.0, 1.0),
                  (t + 0.25).clamp(0.0, 1.0),
                ],
                colors: [
                  colors.white.withValues(alpha: 0),
                  colors.white.withValues(alpha: 0.12),
                  colors.white.withValues(alpha: 0),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
