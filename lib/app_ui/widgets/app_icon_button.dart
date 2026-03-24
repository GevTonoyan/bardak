import 'package:alias_pro/assets/assets.gen.dart';
import 'package:alias_pro/utils/extensions/context_extension.dart';
import 'package:alias_pro/utils/extensions/state_extension.dart';
import 'package:flutter/material.dart';

const _containerSize = 40.0;
const _iconSize = 18.0;

class AppIconButton extends StatefulWidget {
  const AppIconButton({
    required this.child,
    this.onTap,
    this.isPressed = false,
    super.key,
  });

  factory AppIconButton.back({required VoidCallback onTap, Key? key}) {
    return AppIconButton(
      key: key,
      onTap: onTap,
      child: Assets.icons.back.svg(width: 18, height: 18),
    );
  }

  factory AppIconButton.settings({required VoidCallback onTap, Key? key}) {
    return AppIconButton(
      key: key,
      onTap: onTap,
      child: const Icon(Icons.settings),
    );
  }

  factory AppIconButton.edit({required VoidCallback onTap, Key? key}) {
    return AppIconButton(
      key: key,
      onTap: onTap,
      child: const Icon(Icons.edit),
    );
  }

  factory AppIconButton.close({required VoidCallback onTap, Key? key}) {
    return AppIconButton(
      key: key,
      onTap: onTap,
      child: Assets.icons.close.svg(width: 18, height: 18),
    );
  }

  factory AppIconButton.info({required VoidCallback onTap, Key? key}) {
    return AppIconButton(
      key: key,
      onTap: onTap,
      child: Assets.icons.info.svg(width: 15, height: 20),
    );
  }

  factory AppIconButton.pause({required VoidCallback onTap, Key? key}) {
    return AppIconButton(
      key: key,
      onTap: onTap,
      child: Assets.icons.pause.svg(width: 18, height: 18),
    );
  }

  factory AppIconButton.play({required VoidCallback onTap, Key? key}) {
    return AppIconButton(
      key: key,
      onTap: onTap,
      child: Assets.icons.play.svg(width: 18, height: 18),
    );
  }

  factory AppIconButton.themeOwned({
    required BuildContext context,
    required bool isActive,
    Key? key,
  }) {
    return AppIconButton(
      key: key,
      child: Container(
        decoration: BoxDecoration(
          color: context.colors.black.withValues(alpha: 0.8),
          shape: .circle,
        ),
        child: isActive
            ? Center(
                child: Container(
                  height: 22,
                  width: 22,
                  decoration: BoxDecoration(
                    color: context.colors.white,
                    shape: .circle,
                  ),
                ),
              )
            : null,
      ),
    );
  }

  final Widget child;
  final VoidCallback? onTap;
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
    return IgnorePointer(
      ignoring: widget.onTap == null,
      child: GestureDetector(
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
      ),
    );
  }
}
