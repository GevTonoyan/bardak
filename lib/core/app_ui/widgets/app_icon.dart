import 'package:flutter/material.dart';

class AppIcon extends StatelessWidget {
  const AppIcon({
    required this.icon,
    this.clickableArea = 48.0,
    this.iconSize = 20,
    this.onTap,
    super.key,
  });

  final Widget icon;
  final double iconSize;
  final double clickableArea;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: clickableArea,
      width: clickableArea,
      // A local transparent Material so the InkWell's ripple/highlight always
      // paints here, on top of the surface behind it (e.g. an AppInputField),
      // instead of on a distant Material ancestor where it stays hidden.
      child: Material(
        type: MaterialType.transparency,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: Center(child: icon),
        ),
      ),
    );
  }
}
