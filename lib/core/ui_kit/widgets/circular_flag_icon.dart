import 'package:boardify/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CircularFlagIcon extends StatelessWidget {
  final String assetPath;
  final double size;

  const CircularFlagIcon({super.key, required this.assetPath, this.size = 28});

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: theme.colors.outline.withValues(alpha: 0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipOval(child: SvgPicture.asset(assetPath, fit: BoxFit.cover)),
    );
  }
}
