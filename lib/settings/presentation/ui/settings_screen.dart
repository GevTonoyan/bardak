import 'dart:async';

import 'package:bardak/app_ui/widgets/app_button/app_button.dart';
import 'package:bardak/app_ui/widgets/app_button/app_switch_button.dart';
import 'package:bardak/app_ui/widgets/app_notification.dart';
import 'package:bardak/app_ui/widgets/app_spacings.dart';
import 'package:bardak/app_ui/widgets/bottom_sheet.dart';
import 'package:bardak/app_ui/widgets/smart_number_text.dart';
import 'package:bardak/assets/assets.gen.dart';
import 'package:bardak/settings/presentation/bloc/settings_bloc.dart';
import 'package:bardak/settings/presentation/bloc/settings_event.dart';
import 'package:bardak/settings/presentation/ui/app_languages_list.dart';
import 'package:bardak/utils/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends Page<void> {
  const SettingsScreen({super.key});

  static const routePath = 'settings';

  @override
  Route<void> createRoute(BuildContext context) {
    return buildAppBottomSheet<void>(
      context: context,
      settings: this,
      child: PartialBottomSheet(
        titleBuilder: (context) => context.l10n.settings,
        child: const SettingsScreenBody(),
      ),
    );
  }
}

class SettingsScreenBody extends StatelessWidget {
  const SettingsScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsBloc = context.watch<SettingsBloc>();
    final appSettings = settingsBloc.state.appSettings;
    final colors = context.colors;

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
        AppButton(
          label: context.l10n.feedback,
          color: colors.white20,
          onPressed: () async {
            final uri = Uri(
              scheme: 'mailto',
              path: 'bardak.feedback@gmail.com',
              queryParameters: {
                'subject': 'Bardak Feedback',
              },
            );

            try {
              final launched = await launchUrl(
                uri,
                mode: LaunchMode.externalApplication,
              );

              if (!launched && context.mounted) {
                _showFeedbackError(context);
              }
            } on Exception catch (_) {
              if (context.mounted) {
                _showFeedbackError(context);
              }
            }
          },
          child: Row(
            spacing: 14,
            children: [
              width20,
              Icon(Icons.mail_outline, color: colors.white, size: 24),
              Text(
                context.l10n.feedback,
                style: context.typography.regular24,
              ),
            ],
          ),
        ),
        height40,
        AppButton(
          label: context.l10n.rateApp,
          color: colors.white20,
          onPressed: () {
            settingsBloc.add(const OpenStoreListingRequested());
          },
          child: Row(
            spacing: 14,
            children: [
              width20,
              Icon(Icons.star_outline, color: colors.white, size: 24),
              Text(
                context.l10n.rateApp,
                style: context.typography.regular24,
              ),
            ],
          ),
        ),
        height40,
        const _AppVersionText(),
      ],
    );
  }

  void _showFeedbackError(BuildContext context) {
    unawaited(
      showAppNotification(
        context,
        message: context.l10n.feedback_email_error,
        duration: const Duration(seconds: 5),
      ),
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
