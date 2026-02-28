import 'package:alias_pro/app_ui/widgets/app_icon_button.dart';
import 'package:alias_pro/assets/assets.gen.dart';
import 'package:alias_pro/localizations/common/supported_locales.dart';
import 'package:flutter/material.dart';

class LanguageIcon extends StatelessWidget {
  const LanguageIcon({required this.locale, this.isPressed = false, super.key});

  final AppLocales locale;
  final bool isPressed;

  @override
  Widget build(BuildContext context) {
    return AppIconButton(
      onTap: () {},
      isPressed: isPressed,
      child: ClipOval(
        child: Container(
          child: _assetPath.svg(),
        ),
      ),
    );
  }

  SvgGenImage get _assetPath => switch (locale) {
    AppLocales.en => Assets.icons.flags.uk,
    AppLocales.ru => Assets.icons.flags.ru,
    AppLocales.am => Assets.icons.flags.am,
  };
}
