import 'package:boardify/utils/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';

enum ButtonSize { large, medium, small }

class AppButton extends StatefulWidget {
  const AppButton({
    required this.label,
    required this.color,
    this.size = .large,
    this.onPressed,
    super.key,
  });

  final String label;
  final ButtonSize size;
  final Color color;
  final VoidCallback? onPressed;

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  bool _pressed = false;

  void _setPressed(bool v) {
    //if (!widget.enabled) return;
    if (_pressed == v) return;
    setState(() => _pressed = v);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appTheme.colors;

    final (baseHeight, faceHeight) = _buttonHeight;
    final currentHeight = _pressed ? faceHeight : baseHeight;

    return GestureDetector(
      onTapDown: (_) => _setPressed(true),
      onTapCancel: () => _setPressed(false),
      onTapUp: (_) => _setPressed(false),
      onTap: widget.onPressed,
      child: Container(
        height: baseHeight,
        alignment: Alignment.bottomCenter,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 110),
          width: double.maxFinite,
          height: currentHeight,
          child: Stack(
            children: [
              Container(
                height: baseHeight,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: widget.color,
                  boxShadow: [
                    if (_pressed)
                      BoxShadow(
                        offset: _baseShadowOffsetPressed,
                        color: Colors.black.withValues(alpha: 0.25),
                        blurRadius: 2,
                      )
                    else
                      BoxShadow(
                        offset: _baseShadowOffset,
                        color: colors.black.withValues(alpha: 0.25),
                        blurRadius: 2,
                      ),
                  ],
                ),
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
                  boxShadow: [
                    BoxShadow(
                      offset: _pressed ? Offset.zero : _faceShadowOffset,
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 2,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    widget.label,
                    style: _labelTextStyle().copyWith(color: colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  (double, double) get _buttonHeight => switch (widget.size) {
    .large => (60, 50),
    .medium => (50, 42),
    .small => (42, 36),
  };

  TextStyle _labelTextStyle() {
    final typography = context.appTheme.typography;

    return switch (widget.size) {
      .large => typography.regular24,
      .medium => typography.regular20,
      .small => typography.regular18,
    };
  }

  Offset get _baseShadowOffset => switch (widget.size) {
    .large => const Offset(0, 4),
    .medium => const Offset(0, 3),
    .small => const Offset(0, 2),
  };

  Offset get _baseShadowOffsetPressed => switch (widget.size) {
    .large => const Offset(0, 2),
    .medium => const Offset(0, 1),
    .small => const Offset(0, 1),
  };

  Offset get _faceShadowOffset => switch (widget.size) {
    .large => const Offset(0, 10),
    .medium => const Offset(0, 8),
    .small => const Offset(0, 6),
  };
}

//
// class AppButton extends StatefulWidget {
//   const AppButton({
//     required this.label,
//     required this.onPressed,
//     super.key,
//     this.icon = Icons.play_arrow_rounded,
//     this.width = 340,
//     this.height = 60,
//     this.depth = 8,
//     this.radius = 16,
//     this.faceColor = const Color(0xFF4C6CF6),
//     this.faceGradient,
//     this.faceBorderColor = const Color(0xFF6F88FF),
//     this.baseColor = const Color(0xFF2E49C9),
//     this.contentColor = Colors.white,
//     this.textStyle,
//   });
//
//   final String label;
//   final VoidCallback? onPressed;
//   final IconData icon;
//
//   final double width;
//   final double height;
//   final double depth;
//   final double radius;
//
//   final Color faceColor;
//   final Gradient? faceGradient;
//   final Color faceBorderColor;
//   final Color baseColor;
//
//   final Color contentColor;
//   final TextStyle? textStyle;
//
//   bool get enabled => onPressed != null;
//
//   @override
//   State<AppButton> createState() => _AppButtonState();
// }
//
// class _AppButtonState extends State<AppButton> {
//   bool _pressed = false;
//
//   void _setPressed(bool v) {
//     if (!widget.enabled) return;
//     if (_pressed == v) return;
//     setState(() => _pressed = v);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final enabled = widget.enabled;
//
//     // Face height is constant; on press the whole
//     // button shrinks to face height.
//     final faceHeight = widget.height - widget.depth;
//     final currentHeight = _pressed ? faceHeight : widget.height;
//
//     // Figma drop shadow only when raised
//     final dropShadow = enabled && !_pressed
//         ? [
//             BoxShadow(
//               offset: const Offset(0, -2),
//               blurRadius: 2,
//               color: Colors.black.withValues(alpha: 0.10),
//             ),
//             BoxShadow(
//               offset: const Offset(0, 4),
//               blurRadius: 2,
//               color: Colors.black.withValues(alpha: 0.25),
//             ),
//           ]
//         : const <BoxShadow>[];
//
//     return GestureDetector(
//       onTapDown: (_) => _setPressed(true),
//       onTapCancel: () => _setPressed(false),
//       onTapUp: (_) => _setPressed(false),
//       onTap: widget.onPressed,
//       child: Container(
//         height: 60,
//         alignment: Alignment.bottomCenter,
//         child: AnimatedContainer(
//           duration: const Duration(milliseconds: 110),
//           curve: Curves.easeOut,
//           width: double.maxFinite,
//           height: currentHeight,
//           // <- shrink here
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(12),
//             boxShadow: dropShadow,
//           ),
//           child: ClipRRect(
//             borderRadius: BorderRadius.circular(12),
//             child: Stack(
//               children: [
//                 // BASE: only visible when not pressed (thickness)
//                 AnimatedPositioned(
//                   duration: const Duration(milliseconds: 110),
//                   curve: Curves.easeOut,
//                   left: 0,
//                   right: 0,
//                   top: _pressed ? 0 : widget.depth,
//                   // slide up when pressed
//                   height: faceHeight,
//                   child: AnimatedOpacity(
//                     duration: const Duration(milliseconds: 110),
//                     opacity: _pressed ? 0 : 1,
//                     child: Container(
//                       decoration: BoxDecoration(
//                         color: widget.baseColor,
//                         borderRadius: BorderRadius.circular(widget.radius),
//                       ),
//                     ),
//                   ),
//                 ),
//
//                 // FACE: always at top 0 -> no top gap ever
//                 Positioned(
//                   left: 0,
//                   right: 0,
//                   top: 0,
//                   height: faceHeight,
//                   child: Container(
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(widget.radius),
//                       color: widget.faceGradient == null
//                           ? widget.faceColor
//                           : null,
//                       gradient: widget.faceGradient,
//                       border: Border.all(
//                         color: widget.faceBorderColor,
//                         width: 2,
//                       ),
//                     ),
//                     child: Center(
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 18),
//                         child: Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             Text(
//                               widget.label,
//                               style:
//                                   widget.textStyle ??
//                                   TextStyle(
//                                     color: widget.contentColor,
//                                     fontSize: 24,
//                                     fontWeight: FontWeight.w800,
//                                     fontFamily: 'NishikiTeki',
//                                   ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//
//                 // Disabled wash
//                 if (!enabled)
//                   Positioned.fill(
//                     child: Container(
//                       color: Colors.white.withValues(alpha: 0.45),
//                     ),
//                   ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
