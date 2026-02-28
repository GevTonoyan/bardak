import 'package:alias_pro/app_ui/widgets/app_button/app_switch_button.dart';
import 'package:alias_pro/app_ui/widgets/app_spacings.dart';
import 'package:alias_pro/app_ui/widgets/bottom_sheet.dart';
import 'package:alias_pro/assets/assets.gen.dart';
import 'package:alias_pro/settings/presentation/bloc/settings_bloc.dart';
import 'package:alias_pro/settings/presentation/bloc/settings_event.dart';
import 'package:alias_pro/settings/presentation/ui/app_languages_list.dart';
import 'package:alias_pro/utils/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsScreen extends Page<void> {
  const SettingsScreen({super.key});

  static const routePath = 'settings';

  @override
  Route<void> createRoute(BuildContext context) {
    return buildAppBottomSheetRoute<void>(
      context: context,
      settings: this,
      child: const SettingsScreenBody(),
      title: context.l10n.settings,
    );
  }
}

class SettingsScreenBody extends StatelessWidget {
  const SettingsScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;

    final settingsBloc = context.watch<SettingsBloc>();
    final appSettings = settingsBloc.state.appSettings;

    return Column(
      crossAxisAlignment: .start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 30),
        const AppLanguagesList(),
        const SizedBox(height: 40),
        AppSwitchButton(
          label: 'Ձայներ',
          value: appSettings.soundEnabled,
          icon: Assets.volume.svg(width: 24, height: 24),
          onPressed: () {
            final enabled = appSettings.soundEnabled;
            settingsBloc.add(ChangeSoundEffects(soundEffects: !enabled));
          },
          onChanged: (value) {
            settingsBloc.add(ChangeSoundEffects(soundEffects: value));
          },
        ),
        height40,
        Text(
          'Խաղի մասին',
          style: typography.regular24.copyWith(color: colors.white),
        ),
        const SizedBox(height: 20),
        Text(
          'Version 1.3.0',
          style: typography.regular24.copyWith(color: colors.white),
        ),
      ],
    );
  }
}
