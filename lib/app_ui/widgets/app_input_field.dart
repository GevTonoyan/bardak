import 'package:alias_pro/utils/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';

class AppInputField extends StatelessWidget {
  const AppInputField({
    required this.controller,
    this.focusNode,
    this.suffix,
    this.onPressed,
    super.key,
  });

  final TextEditingController controller;
  final FocusNode? focusNode;

  final Widget? suffix;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return GestureDetector(
      onTap: onPressed,
      child: Stack(
        children: [
          Container(
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: colors.white20,
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
            padding: const .only(left: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: colors.white20,
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
              spacing: 14,
              children: [
                Expanded(
                  child: TextFormField(
                    controller: controller,
                    focusNode: focusNode,
                    style: context.typography.regular24,
                    autocorrect: false,
                    cursorColor: colors.white,
                    cursorWidth: 3,
                    maxLength: 16,
                    decoration: const InputDecoration(
                      counterText: '',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                ?suffix,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
