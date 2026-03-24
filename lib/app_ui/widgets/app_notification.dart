import 'dart:async';

import 'package:alias_pro/utils/extensions/context_extension.dart';
import 'package:flutter/material.dart';

/// Shows a top notification overlay with the given [message].
///
/// The notification slides in from the top and fades out after [duration].
/// Uses an optional [icon] widget displayed before the text.
Future<void> showAppNotification(
  BuildContext context, {
  required String message,
  Widget? icon,
  Duration duration = const Duration(seconds: 2),
}) async {
  final overlay = Overlay.of(context);

  late final OverlayEntry entry;

  entry = OverlayEntry(
    builder: (ctx) {
      return _AppNotificationOverlay(
        message: message,
        icon: icon,
        duration: duration,
        onDone: () => entry.remove(),
      );
    },
  );

  overlay.insert(entry);
}

class _AppNotificationOverlay extends StatefulWidget {
  const _AppNotificationOverlay({
    required this.message,
    required this.onDone,
    required this.duration,
    this.icon,
  });

  final String message;
  final Widget? icon;
  final VoidCallback onDone;
  final Duration duration;

  @override
  State<_AppNotificationOverlay> createState() =>
      _AppNotificationOverlayState();
}

class _AppNotificationOverlayState extends State<_AppNotificationOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 350),
    reverseDuration: const Duration(milliseconds: 250),
  );

  late final Animation<double> _fade = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeOut,
    reverseCurve: Curves.easeIn,
  );

  late final Animation<Offset> _slide =
      Tween<Offset>(
        begin: const Offset(0, -1.2),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Curves.easeOut,
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
    final safeTop = MediaQuery.of(context).padding.top;

    return IgnorePointer(
      child: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: EdgeInsets.only(top: safeTop + 16, left: 20, right: 20),
          child: SlideTransition(
            position: _slide,
            child: FadeTransition(
              opacity: _fade,
              child: _AppNotificationBanner(
                message: widget.message,
                icon: widget.icon,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AppNotificationBanner extends StatelessWidget {
  const _AppNotificationBanner({
    required this.message,
    this.icon,
  });

  final String message;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;

    return Material(
      color: Colors.transparent,
      child: Container(
        width: double.infinity,
        padding: const .symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: colors.secondary,
          border: Border.all(color: colors.white30, width: 2),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 4),
              blurRadius: 12,
              color: colors.black.withValues(alpha: 0.3),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 10,
          children: [
            ?icon,
            Flexible(
              child: Text(
                message,
                style: typography.regular18,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
