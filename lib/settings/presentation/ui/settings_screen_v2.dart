import 'package:boardify/app_ui/widgets/app_button.dart';
import 'package:boardify/app_ui/widgets/app_switch.dart';
import 'package:boardify/app_ui/widgets/bottom_sheet.dart';
import 'package:boardify/assets/assets.gen.dart';
import 'package:boardify/settings/presentation/bloc/settings_bloc.dart';
import 'package:boardify/settings/presentation/bloc/settings_event.dart';
import 'package:boardify/settings/presentation/ui/app_languages_list.dart';
import 'package:boardify/utils/extensions/context_extension.dart';
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
      child: const SettingsScreenV2Body(),
      title: context.l10n.settings,
    );
  }
}

class SettingsScreenV2Body extends StatelessWidget {
  const SettingsScreenV2Body({super.key});

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
        AppButton(
          label: 'Երաժշտություն',
          icon: Assets.volume.svg(width: 24, height: 24),
          animateOnPress: false,
          onPressed: () {
            final enabled = appSettings.soundEnabled;
            settingsBloc.add(ChangeSoundEffects(soundEffects: !enabled));
          },
          color: colors.white20,
          suffix: AppSwitch(
            value: appSettings.soundEnabled,
            onChanged: (value) {
              settingsBloc.add(ChangeSoundEffects(soundEffects: value));
            },
          ),
        ),
        const SizedBox(height: 40),
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
