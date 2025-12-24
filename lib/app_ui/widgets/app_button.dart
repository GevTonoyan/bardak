import 'package:flutter/material.dart';

class AppButton extends StatefulWidget {
  const AppButton({
    required this.label,
    required this.onPressed,
    super.key,
    this.icon = Icons.play_arrow_rounded,
    this.width = 240,
    this.height = 60,
    this.depth = 8,
    this.radius = 16,
    this.faceColor = const Color(0xFF4C6CF6),
    this.faceGradient,
    this.faceBorderColor = const Color(0xFF6F88FF),
    this.baseColor = const Color(0xFF2E49C9),
    this.contentColor = Colors.white,
    this.textStyle,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData icon;

  final double width;
  final double height;
  final double depth;
  final double radius;

  final Color faceColor;
  final Gradient? faceGradient;
  final Color faceBorderColor;
  final Color baseColor;

  final Color contentColor;
  final TextStyle? textStyle;

  bool get enabled => onPressed != null;

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  bool _pressed = false;

  void _setPressed(bool v) {
    if (!widget.enabled) return;
    if (_pressed == v) return;
    setState(() => _pressed = v);
  }

  @override
  Widget build(BuildContext context) {
    final enabled = widget.enabled;

    // Face height is constant; on press the whole
    // button shrinks to face height.
    final faceHeight = widget.height - widget.depth;
    final currentHeight = _pressed ? faceHeight : widget.height;

    // Figma drop shadow only when raised
    final dropShadow = enabled && !_pressed
        ? [
            BoxShadow(
              offset: const Offset(0, -2),
              blurRadius: 2,
              color: Colors.black.withValues(alpha: 0.10),
            ),
            BoxShadow(
              offset: const Offset(0, 4),
              blurRadius: 2,
              color: Colors.black.withValues(alpha: 0.25),
            ),
          ]
        : const <BoxShadow>[];

    return GestureDetector(
      onTapDown: (_) => _setPressed(true),
      onTapCancel: () => _setPressed(false),
      onTapUp: (_) => _setPressed(false),
      onTap: widget.onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 110),
        curve: Curves.easeOut,
        width: widget.width,
        height: currentHeight,
        // <- shrink here
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: dropShadow,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              // BASE: only visible when not pressed (thickness)
              AnimatedPositioned(
                duration: const Duration(milliseconds: 110),
                curve: Curves.easeOut,
                left: 0,
                right: 0,
                top: _pressed ? 0 : widget.depth,
                // slide up when pressed
                height: faceHeight,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 110),
                  opacity: _pressed ? 0 : 1,
                  child: Container(
                    decoration: BoxDecoration(
                      color: widget.baseColor,
                      borderRadius: BorderRadius.circular(widget.radius),
                    ),
                  ),
                ),
              ),

              // FACE: always at top 0 -> no top gap ever
              Positioned(
                left: 0,
                right: 0,
                top: 0,
                height: faceHeight,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(widget.radius),
                    color: widget.faceGradient == null
                        ? widget.faceColor
                        : null,
                    gradient: widget.faceGradient,
                    border: Border.all(color: widget.faceBorderColor, width: 2),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            widget.icon,
                            color: widget.contentColor,
                            size: 30,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            widget.label,
                            style:
                                widget.textStyle ??
                                TextStyle(
                                  color: widget.contentColor,
                                  fontSize: 26,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 1.5,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Disabled wash
              if (!enabled)
                Positioned.fill(
                  child: Container(color: Colors.white.withValues(alpha: 0.45)),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
