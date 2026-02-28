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
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Center(child: icon),
      ),
    );
  }
}
