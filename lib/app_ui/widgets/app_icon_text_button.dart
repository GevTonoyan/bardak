import 'package:boardify/assets/assets.gen.dart';
import 'package:boardify/utils/extensions/int_extension.dart';
import 'package:boardify/utils/extensions/state_extension.dart';
import 'package:flutter/material.dart';

const _containerHeight = 40.0;

class AppIconTextButton extends StatefulWidget {
  const AppIconTextButton({
    required this.number,
    required this.onTap,
    super.key,
  });

  final int number;
  final VoidCallback onTap;

  @override
  State<AppIconTextButton> createState() => _AppIconTextButtonState();
}

class _AppIconTextButtonState extends State<AppIconTextButton> {
  bool _pressed = false;

  void _setPressed(bool value) {
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
            height: _containerHeight,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: colors.secondary,
              border: Border.all(color: colors.white, width: 3),
              borderRadius: borderRadius,
              boxShadow: [
                BoxShadow(
                  offset: const Offset(0, 3),
                  color: colors.shadow,
                ),
              ],
            ),
            child: Row(
              spacing: 6,
              children: [
                Text(
                  widget.number.toDotThousands,
                  style: typography.medium.copyWith(
                    color: colors.white,
                    fontFamily: 'Digitalt',
                  ),
                ),
                Assets.coin.svg(width: 18, height: 18),
              ],
            ),
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
