import 'package:boardify/utils/extensions/context_extension.dart';
import 'package:flutter/material.dart';

class AppIconButton extends StatelessWidget {
  const AppIconButton({required this.onTap, required this.iconData, super.key});

  final IconData iconData;
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
        child: Icon(iconData, color: colors.white, size: 18),
      ),
    );
  }
}
