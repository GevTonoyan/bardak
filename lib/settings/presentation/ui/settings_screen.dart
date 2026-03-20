import 'package:alias_pro/app_ui/widgets/app_button/app_switch_button.dart';
import 'package:alias_pro/app_ui/widgets/app_spacings.dart';
import 'package:alias_pro/app_ui/widgets/bottom_sheet.dart';
import 'package:alias_pro/app_ui/widgets/smart_number_text.dart';
import 'package:alias_pro/assets/assets.gen.dart';
import 'package:alias_pro/settings/presentation/bloc/settings_bloc.dart';
import 'package:alias_pro/settings/presentation/bloc/settings_event.dart';
import 'package:alias_pro/settings/presentation/ui/app_languages_list.dart';
import 'package:alias_pro/utils/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';

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
    final settingsBloc = context.watch<SettingsBloc>();
    final appSettings = settingsBloc.state.appSettings;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        height30,
        const AppLanguagesList(),
        const SizedBox(height: 40),
        AppSwitchButton(
          label: context.l10n.sounds,
          value: appSettings.soundEnabled,
          icon: Assets.icons.volume.svg(width: 24, height: 24),
          onPressed: () {
            final enabled = appSettings.soundEnabled;
            settingsBloc.add(ChangeSoundEffects(soundEffects: !enabled));
          },
          onChanged: (value) {
            settingsBloc.add(ChangeSoundEffects(soundEffects: value));
          },
        ),
        height40,
        const _AppVersionText(),
      ],
    );
  }
}

class _AppVersionText extends StatelessWidget {
  const _AppVersionText();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final typography = context.typography;
    final colors = context.colors;

    return FutureBuilder<PackageInfo>(
      future: PackageInfo.fromPlatform(),
      builder: (_, snapshot) {
        final versionLabel = l10n.appVersion;
        final version = snapshot.hasData
            ? '${snapshot.data!.version} (${snapshot.data!.buildNumber})'
            : '';

        return SmartNumberText(
          '$versionLabel $version',
          style: typography.regular18.copyWith(color: colors.white30),
          textAlign: .center,
        );
      },
    );
  }
}
