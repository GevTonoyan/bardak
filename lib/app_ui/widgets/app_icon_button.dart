import 'package:boardify/assets/assets.gen.dart';
import 'package:boardify/utils/extensions/context_extension.dart';
import 'package:flutter/material.dart';

const _iconSize = 18.0;

class AppIconButton extends StatelessWidget {
  const AppIconButton({required this.onTap, required this.child, super.key});

  factory AppIconButton.back({
    required VoidCallback onTap,
    Key? key,
  }) {
    return AppIconButton(
      key: key,
      onTap: onTap,
      child: Assets.back.svg(width: 18, height: 18),
    );
  }

  factory AppIconButton.settings({
    required VoidCallback onTap,
    Key? key,
  }) {
    return AppIconButton(
      key: key,
      onTap: onTap,
      child: const Icon(Icons.settings),
    );
  }

  final Widget child;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.appTheme.colors;

    return InkWell(
      onTap: onTap,
      child: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          color: colors.secondary,
          border: Border.all(color: colors.white, width: 3),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              offset: const Offset(0, 3),
              color: colors.shadow,
            ),
          ],
        ),
        child: IconTheme(
          data: IconThemeData(
            color: colors.white,
            size: _iconSize,
          ),
          child: Center(child: child),
        ),
      ),
    );
  }
}
