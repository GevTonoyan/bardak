import 'package:bardak/core/generated/assets/assets.gen.dart';
import 'package:bardak/core/localizations/common/supported_locales.dart';
import 'package:bardak/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';

class LanguageIcon extends StatelessWidget {
  const LanguageIcon({
    required this.locale,
    this.size = 32.0,
    this.onTap,
    super.key,
  });

  final AppLocales locale;
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
          child: _assetPath.svg(),
        ),
      ),
    );
  }

  SvgGenImage get _assetPath => switch (locale) {
    .en => Assets.icons.flags.uk,
    .ru => Assets.icons.flags.ru,
    .am => Assets.icons.flags.am,
  };
}
