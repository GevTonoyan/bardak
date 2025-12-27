import 'package:boardify/app_ui/widgets/app_button.dart';
import 'package:boardify/app_ui/widgets/language_icon.dart';
import 'package:boardify/localizations/common/supported_locales.dart';
import 'package:boardify/localizations/l10n/app_localizations.dart';
import 'package:boardify/settings/presentation/bloc/settings_bloc.dart';
import 'package:boardify/settings/presentation/bloc/settings_event.dart';
import 'package:boardify/utils/extensions/context_extension.dart';
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
          icon: LanguageIcon(locale: locale),
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
