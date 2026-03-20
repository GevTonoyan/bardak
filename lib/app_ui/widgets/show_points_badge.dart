import 'dart:async';

import 'package:alias_pro/app_ui/widgets/app_icon_text_button.dart';
import 'package:alias_pro/utils/extensions/context_extension.dart';
import 'package:flutter/material.dart';

Future<void> showPointsBadge(
  BuildContext context, {
  required String points,
  Duration duration = const Duration(seconds: 1),
}) async {
  final overlay = Overlay.of(context);

  late final OverlayEntry entry;

  entry = OverlayEntry(
    builder: (ctx) {
      return _PointsBadgeOverlay(
        points: points,
        onDone: () => entry.remove(),
        duration: duration,
      );
    },
  );

  overlay.insert(entry);
}

class _PointsBadgeOverlay extends StatefulWidget {
  const _PointsBadgeOverlay({
    required this.points,
    required this.onDone,
    required this.duration,
  });

  final String points;
  final VoidCallback onDone;
  final Duration duration;

  @override
  State<_PointsBadgeOverlay> createState() => _PointsBadgeOverlayState();
}

class _PointsBadgeOverlayState extends State<_PointsBadgeOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 400),
    reverseDuration: const Duration(milliseconds: 250),
  );

  late final Animation<double> _fade = CurvedAnimation(
    parent: _controller,
    curve: Curves.linear,
    reverseCurve: Curves.linear,
  );

  late final Animation<Offset> _slide =
      Tween<Offset>(
        begin: const Offset(0, 1.2),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Curves.linear,
        ),
      );

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    unawaited(_controller.forward());
    _timer = Timer(widget.duration, () async {
      if (!mounted) return;
      await _controller.reverse();
      widget.onDone();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final safeBottom = MediaQuery.of(context).padding.bottom;
    return IgnorePointer(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: EdgeInsets.only(bottom: safeBottom + 160),
          child: SlideTransition(
            position: _slide,
            child: FadeTransition(
              opacity: _fade,
              child: _PointsBadge(points: widget.points),
            ),
          ),
        ),
      ),
    );
  }
}

class _PointsBadge extends StatelessWidget {
  const _PointsBadge({required this.points});

  final String points;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;

    final isNegative = points.startsWith('-');

    return Material(
      color: Colors.transparent,
      child: AppIconTextButton(
        color: colors.green,
        gradient: isNegative
            ? const LinearGradient(
                begin: .topCenter,
                end: .bottomCenter,
                colors: [Color(0xFFDF393C), Color(0xFF932123)],
              )
            : null,
        padding: const .symmetric(horizontal: 14, vertical: 10),
        child: Text(
          context.l10n.points_value(points),
          style: typography.regular24,
        ),
      ),
    );
  }
}
