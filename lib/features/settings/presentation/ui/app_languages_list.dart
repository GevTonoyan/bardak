import 'package:bardak/core/app_ui/widgets/app_button/app_button.dart';
import 'package:bardak/core/app_ui/widgets/language_icon.dart';
import 'package:bardak/core/extensions/context_extension.dart';
import 'package:bardak/core/localizations/app_locale.dart';
import 'package:bardak/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:bardak/features/settings/presentation/bloc/settings_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppLanguagesList extends StatelessWidget {
  const AppLanguagesList({this.afterSelection, super.key});

  final VoidCallback? afterSelection;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    final settingsBloc = context.read<SettingsBloc>();
    final selectedLocale = settingsBloc.state.appSettings.locale;

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      separatorBuilder: (_, _) => const SizedBox(height: 20),
      itemCount: AppLocale.values.length,
      itemBuilder: (context, index) {
        final locale = AppLocale.values[index];

        return AppButton(
          label: locale.displayName(context),
          icon: LanguageIcon(locale: locale),
          isPressed: selectedLocale == locale,
          pressedColor: colors.white,
          pressedTextColor: colors.secondary,
          onPressed: () {
            settingsBloc.add(ChangeLocale(locale));
            afterSelection?.call();
          },
          color: colors.white20,
        );
      },
    );
  }
}
