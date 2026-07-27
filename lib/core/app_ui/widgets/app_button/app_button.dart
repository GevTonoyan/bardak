import 'package:bardak/core/app_ui/widgets/edge_shadow.dart';
import 'package:bardak/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';

enum ButtonSize { extraLarge, large, medium, small }

class AppButton extends StatefulWidget {
  const AppButton({
    required this.label,
    required this.color,
    this.size = .large,
    this.isPressed = false,
    this.animateOnPress = true,
    this.pressedColor,
    this.pressedTextColor,
    this.icon,
    this.onPressed,
    this.child,
    super.key,
  });

  final String label;
  final Color color;
  final ButtonSize size;
  final bool animateOnPress;
  final Color? pressedColor;
  final Color? pressedTextColor;
  final Widget? icon;
  final VoidCallback? onPressed;
  final Widget? child;

  final bool isPressed;

  bool get enabled => onPressed != null;

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  bool _pressedByGesture = false;

  void _setPressed(bool v) {
    if (!widget.enabled) return;
    if (!widget.animateOnPress) return;
    if (widget.isPressed) return;
    if (_pressedByGesture == v) return;
    setState(() => _pressedByGesture = v);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appTheme.colors;

    final effectivePressed = widget.isPressed || _pressedByGesture; // <-

    final (baseHeight, faceHeight) = _buttonHeight;
    final currentHeight = effectivePressed ? faceHeight : baseHeight;

    return GestureDetector(
      onTapDown: widget.enabled ? (_) => _setPressed(true) : null,
      onTapCancel: widget.enabled ? () => _setPressed(false) : null,
      onTapUp: widget.enabled ? (_) => _setPressed(false) : null,
      onTap: widget.onPressed,
      child: Container(
        height: baseHeight,
        alignment: Alignment.bottomCenter,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 110),
          curve: Curves.easeOut,
          width: double.maxFinite,
          height: currentHeight,
          child: Stack(
            children: [
              // Drop shadow beneath the whole button. Clipped so it only
              // spills outside the base rect — otherwise a translucent
              // `color` (e.g. white20) lets the shadow bleed through.
              EdgeShadow(
                height: baseHeight,
                offset: effectivePressed
                    ? _baseShadowOffsetPressed
                    : _baseShadowOffset,
                alpha: 0.25,
              ),
              Container(
                height: baseHeight,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: effectivePressed ? widget.pressedColor : widget.color,
                ),
              ),
              // Depth shadow cast by the raised face onto the exposed edge.
              // Clipped away from the face rect so it never shows through a
              // translucent face; only the offset spillover remains visible.
              EdgeShadow(
                height: faceHeight,
                offset: effectivePressed ? Offset.zero : _faceShadowOffset,
                alpha: 0.2,
              ),
              Container(
                height: faceHeight,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: widget.color,
                  border: GradientBoxBorder(
                    width: 2,
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        colors.white.withValues(alpha: 0.3),
                        colors.white.withValues(alpha: 0.05),
                        colors.white.withValues(alpha: 0.05),
                        colors.white.withValues(alpha: 0.3),
                      ],
                    ),
                  ),
                ),
                child:
                    widget.child ??
                    Row(
                      mainAxisAlignment: .center,
                      spacing: 14,
                      children: [
                        ?widget.icon,
                        Text(
                          widget.label,
                          style: _labelTextStyle().copyWith(
                            color: effectivePressed
                                ? (widget.pressedTextColor ?? colors.white)
                                : colors.white,
                          ),
                        ),
                      ],
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  (double, double) get _buttonHeight => switch (widget.size) {
    .extraLarge => (157, 147),
    .large => (60, 50),
    .medium => (50, 42),
    .small => (42, 36),
  };

  TextStyle _labelTextStyle() {
    final typography = context.appTheme.typography;

    return switch (widget.size) {
      .large || .extraLarge => typography.regular24,
      .medium => typography.regular20,
      .small => typography.regular18,
    };
  }

  Offset get _baseShadowOffset => switch (widget.size) {
    .large || .extraLarge => const Offset(0, 4),
    .medium => const Offset(0, 3),
    .small => const Offset(0, 2),
  };

  Offset get _baseShadowOffsetPressed => switch (widget.size) {
    .large || .extraLarge => const Offset(0, 2),
    .medium => const Offset(0, 1),
    .small => const Offset(0, 1),
  };

  Offset get _faceShadowOffset => switch (widget.size) {
    .large || .extraLarge => const Offset(0, 10),
    .medium => const Offset(0, 8),
    .small => const Offset(0, 6),
  };
}
