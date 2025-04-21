import 'package:app_core/extensions/context_extension.dart';
import 'package:flutter/material.dart';

enum GameAlertType { success, error, warning, info }

class GameAlertBanner extends StatelessWidget {
  final String message;
  final GameAlertType type;
  final VoidCallback? onTap;

  const GameAlertBanner({super.key, required this.message, required this.type, this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = context.appTheme.colors;
    final text = context.appTheme.typography;

    final (bgColor, contentColor) = switch (type) {
      GameAlertType.success => (colors.success, Colors.white),
      GameAlertType.error => (colors.error, Colors.black),
      GameAlertType.warning => (colors.warning, Colors.black),
      GameAlertType.info => (colors.primary, Colors.white),
    };

    final icon = switch (type) {
      GameAlertType.success => Icons.emoji_events,
      GameAlertType.error => Icons.warning_amber_rounded,
      GameAlertType.warning => Icons.error_outline,
      GameAlertType.info => Icons.bolt_rounded,
    };

    return SafeArea(
      bottom: false,
      child: Material(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: contentColor.withOpacity(0.1),
                    ),
                    child: Icon(icon, size: 24, color: contentColor),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      message,
                      style: text.bodyLarge.copyWith(
                        color: contentColor,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

OverlayEntry? _currentBannerEntry;

void showAlertBanner(
  BuildContext context, {
  required String message,
  GameAlertType type = GameAlertType.info,
  Duration duration = const Duration(seconds: 3),
}) {
  _currentBannerEntry?.remove();

  final overlay = Overlay.of(context);

  final entry = OverlayEntry(
    builder:
        (_) => Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: GameAlertBanner(message: message, type: type),
        ),
  );

  _currentBannerEntry = entry;
  overlay.insert(entry);

  Future.delayed(duration, () {
    entry.remove();
    if (_currentBannerEntry == entry) {
      _currentBannerEntry = null;
    }
  });
}
