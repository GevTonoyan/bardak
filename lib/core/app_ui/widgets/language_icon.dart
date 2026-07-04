import 'package:bardak/core/extensions/context_extension.dart';
import 'package:bardak/core/localizations/app_locale.dart';
import 'package:flutter/material.dart';

class LanguageIcon extends StatelessWidget {
  const LanguageIcon({
    required this.locale,
    this.size = 32.0,
    this.onTap,
    super.key,
  });

  final AppLocale locale;
  final double size;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: size,
        width: size,
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
        child: ClipOval(
          child: locale.flag.svg(),
        ),
      ),
    );
  }
}
