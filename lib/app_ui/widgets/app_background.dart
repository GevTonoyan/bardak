import 'package:boardify/assets/assets.gen.dart';
import 'package:boardify/utils/extensions/context_extension.dart';
import 'package:flutter/material.dart';

class AppBackground extends StatelessWidget {
  const AppBackground({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = context.appTheme.colors;

    return Material(
      child: Stack(
        children: [
          Container(
            height: double.maxFinite,
            width: double.maxFinite,
            decoration: BoxDecoration(gradient: colors.main),
            child: SafeArea(
              child: child,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Assets.shadowEffect.svg(
              height: 600,
              width: double.maxFinite,
              fit: BoxFit.fitWidth,
            ),
          ),
        ],
      ),
    );
  }
}
