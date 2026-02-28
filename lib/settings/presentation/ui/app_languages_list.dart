import 'package:alias_pro/app_ui/widgets/app_button/app_button.dart';
import 'package:alias_pro/assets/assets.gen.dart';
import 'package:alias_pro/localizations/common/supported_locales.dart';
import 'package:alias_pro/localizations/l10n/app_localizations.dart';
import 'package:alias_pro/settings/presentation/bloc/settings_bloc.dart';
import 'package:alias_pro/settings/presentation/bloc/settings_event.dart';
import 'package:alias_pro/utils/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppLanguagesList extends StatelessWidget {
  const AppLanguagesList({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    final settingsBloc = context.read<SettingsBloc>();
    final selectedLocale = settingsBloc.state.appSettings.locale;

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      separatorBuilder: (_, _) => const SizedBox(height: 20),
      itemCount: AppLocales.values.length,
      itemBuilder: (context, index) {
        final locale = AppLocales.values[index];

        return AppButton(
          label: _displayName(locale, context.l10n),
          icon: _LanguageIcon(locale: locale),
          isPressed: selectedLocale == locale,
          pressedColor: colors.white,
          pressedTextColor: colors.secondary,
          onPressed: () {
            settingsBloc.add(ChangeLocale(locale));
          },
          color: colors.white20,
        );
      },
    );
  }

  String _displayName(AppLocales locale, AppLocalizations l10n) =>
      switch (locale) {
        AppLocales.en => l10n.settings_localeEnglish,
        AppLocales.ru => l10n.settings_localeRussian,
        AppLocales.am => l10n.settings_localeArmenian,
      };
}

class _LanguageIcon extends StatelessWidget {
  const _LanguageIcon({required this.locale});

  final AppLocales locale;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      height: 32,
      width: 32,
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
    );
  }

  SvgGenImage get _assetPath => switch (locale) {
    .en => Assets.icons.flags.uk,
    .ru => Assets.icons.flags.ru,
    .am => Assets.icons.flags.am,
  };
}
