import 'package:bardak/core/app_ui/widgets/edge_shadow.dart';
import 'package:bardak/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';

class AppInputField extends StatelessWidget {
  const AppInputField({
    required this.controller,
    this.focusNode,
    this.suffix,
    this.onPressed,
    this.maxLength = 16,
    super.key,
  });

  final TextEditingController controller;
  final FocusNode? focusNode;

  final Widget? suffix;
  final VoidCallback? onPressed;
  final int maxLength;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return GestureDetector(
      onTap: onPressed,
      child: Stack(
        children: [
          // Drop shadow beneath the field. Clipped so it only spills outside
          // the base rect — otherwise the translucent white20 fill lets the
          // shadow bleed through.
          const EdgeShadow(height: 60, offset: Offset(0, 4), alpha: 0.25),
          Container(
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: colors.white20,
            ),
          ),
          // Depth shadow cast by the raised face onto the exposed edge.
          const EdgeShadow(height: 50, offset: Offset(0, 10), alpha: 0.2),
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
                    maxLength: maxLength,
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
