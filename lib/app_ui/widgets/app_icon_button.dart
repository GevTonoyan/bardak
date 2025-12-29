import 'package:boardify/assets/assets.gen.dart';
import 'package:boardify/utils/extensions/context_extension.dart';
import 'package:flutter/material.dart';

const _containerSize = 40.0;
const _iconSize = 18.0;

class AppIconButton extends StatefulWidget {
  const AppIconButton({
    required this.onTap,
    required this.child,
    this.isPressed = false,
    super.key,
  });

  factory AppIconButton.back({
    required VoidCallback onTap,
    Key? key,
  }) {
    return AppIconButton(
      key: key,
      onTap: onTap,
      child: Assets.back.svg(width: 18, height: 18),
    );
  }

  factory AppIconButton.settings({
    required VoidCallback onTap,
    Key? key,
  }) {
    return AppIconButton(
      key: key,
      onTap: onTap,
      child: const Icon(Icons.settings),
    );
  }

  final Widget child;
  final VoidCallback onTap;
  final bool isPressed;

  @override
  State<AppIconButton> createState() => _AppIconButtonState();
}

class _AppIconButtonState extends State<AppIconButton> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed == value) return;
    setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appTheme.colors;

    final normalBg = colors.secondary;
    final pressedBg = colors.black.withValues(alpha: 0.4);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => _setPressed(true),
      onTapCancel: () => _setPressed(false),
      onTapUp: (_) => _setPressed(false),
      onTap: widget.onTap,
      child: Container(
        height: _containerSize,
        width: _containerSize,
        decoration: BoxDecoration(
          color: _pressed ? pressedBg : normalBg,
          border: Border.all(color: colors.white, width: 3),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 3),
              color: colors.shadow,
            ),
          ],
        ),
        child: IconTheme(
          data: IconThemeData(
            color: colors.white,
            size: _iconSize,
          ),
          child: Center(child: widget.child),
        ),
      ),
    );
  }
}
