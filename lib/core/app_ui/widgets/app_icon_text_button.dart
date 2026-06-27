import 'package:bardak/core/extensions/state_extension.dart';
import 'package:flutter/material.dart';

class AppIconTextButton extends StatefulWidget {
  const AppIconTextButton({
    required this.child,
    this.onTap,
    this.padding,
    this.color,
    this.gradient,
    super.key,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsets? padding;
  final Color? color;
  final Gradient? gradient;

  @override
  State<AppIconTextButton> createState() => _AppIconTextButtonState();
}

class _AppIconTextButtonState extends State<AppIconTextButton> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (widget.onTap == null) return;
    if (_pressed == value) return;
    setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(192);

    return GestureDetector(
      onTapDown: (_) => _setPressed(true),
      onTapCancel: () => _setPressed(false),
      onTapUp: (_) => _setPressed(false),
      onTap: widget.onTap,
      child: Stack(
        children: [
          Container(
            padding: widget.padding ?? const .all(10),
            decoration: BoxDecoration(
              color: widget.color ?? colors.secondary,
              gradient: widget.gradient,
              border: Border.all(color: colors.white, width: 3),
              borderRadius: borderRadius,
              boxShadow: [
                BoxShadow(
                  offset: const Offset(0, 3),
                  color: colors.shadow,
                ),
              ],
            ),
            child: widget.child,
          ),
          if (_pressed)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: colors.black.withValues(alpha: 0.2),
                  borderRadius: borderRadius,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
