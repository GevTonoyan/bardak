import 'package:bardak/core/generated/assets/assets.gen.dart';
import 'package:flutter/material.dart';

class SvgIcon extends StatelessWidget {
  const SvgIcon({required this.asset, super.key});

  final SvgGenImage asset;

  @override
  Widget build(BuildContext context) {
    final themeData = IconTheme.of(context);
    final color = themeData.color;
    final height = themeData.size;

    final colorFilter = (color != null)
        ? ColorFilter.mode(color, BlendMode.srcIn)
        : null;

    return asset.svg(colorFilter: colorFilter, height: height);
  }
}
