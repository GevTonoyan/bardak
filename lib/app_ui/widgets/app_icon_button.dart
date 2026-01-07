import 'package:boardify/assets/assets.gen.dart';
import 'package:boardify/utils/extensions/state_extension.dart';
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

  factory AppIconButton.back({required VoidCallback onTap, Key? key}) {
    return AppIconButton(
      key: key,
      onTap: onTap,
      child: Assets.back.svg(width: 18, height: 18),
    );
  }

  factory AppIconButton.settings({required VoidCallback onTap, Key? key}) {
    return AppIconButton(
      key: key,
      onTap: onTap,
      child: const Icon(Icons.settings),
    );
  }

  factory AppIconButton.close({required VoidCallback onTap, Key? key}) {
    return AppIconButton(
      key: key,
      onTap: onTap,
      child: Assets.close.svg(width: 18, height: 18),
    );
  }

  factory AppIconButton.pause({required VoidCallback onTap, Key? key}) {
    return AppIconButton(
      key: key,
      onTap: onTap,
      child: Assets.pause.svg(width: 18, height: 18),
    );
  }

  factory AppIconButton.play({required VoidCallback onTap, Key? key}) {
    return AppIconButton(
      key: key,
      onTap: onTap,
      child: Assets.play.svg(width: 18, height: 18),
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
    return GestureDetector(
      onTapDown: (_) => _setPressed(true),
      onTapCancel: () => _setPressed(false),
      onTapUp: (_) => _setPressed(false),
      onTap: widget.onTap,
      child: Stack(
        children: [
          Container(
            height: _containerSize,
            width: _containerSize,
            decoration: BoxDecoration(
              color: colors.secondary,
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
          if (_pressed)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: colors.black.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
