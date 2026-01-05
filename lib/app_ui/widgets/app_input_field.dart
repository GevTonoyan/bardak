import 'package:boardify/utils/extensions/state_extension.dart';
import 'package:flutter/material.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';

class AppInputField extends StatefulWidget {
  const AppInputField({
    required this.label,
    required this.color,
    this.suffix,
    this.onPressed,

    super.key,
  });

  final String label;
  final Color color;
  final Widget? suffix;
  final VoidCallback? onPressed;

  @override
  State<AppInputField> createState() => _AppInputFieldState();
}

class _AppInputFieldState extends State<AppInputField> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onPressed,
      child: Stack(
        children: [
          Container(
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: widget.color,
              boxShadow: [
                BoxShadow(
                  offset: const Offset(0, 4),
                  color: Colors.black.withValues(alpha: 0.25),
                  blurRadius: 2,
                ),
              ],
            ),
          ),
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 20),
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
                  offset: const Offset(0, 10),
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 2,
                ),
              ],
            ),
            child: Row(
              spacing: 10,
              children: [
                Expanded(
                  child: TextFormField(
                    style: typography.regular24.copyWith(
                      color: colors.white,
                    ),
                    autocorrect: false,
                    cursorColor: colors.secondary,
                    cursorWidth: 4,
                    maxLength: 16,
                    decoration: const InputDecoration(
                      counterText: '',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                ?widget.suffix,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
