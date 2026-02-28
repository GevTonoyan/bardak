import 'package:alias_pro/assets/assets.gen.dart';
import 'package:alias_pro/utils/extensions/context_extension.dart';
import 'package:flutter/material.dart';

class ScreenBackground extends StatelessWidget {
  const ScreenBackground({
    required this.child,
    this.shadowHeight,
    super.key,
  });

  final Widget child;
  final double? shadowHeight;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(gradient: context.colors.main),
            ),
          ),
          if (shadowHeight != null)
            Align(
              alignment: Alignment.bottomCenter,
              child: Assets.shadowEffect.svg(height: shadowHeight),
            ),
          child,
        ],
      ),
    );
  }
}
