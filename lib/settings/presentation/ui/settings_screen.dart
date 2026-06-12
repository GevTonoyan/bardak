import 'dart:async';

import 'package:bardak/app_ui/widgets/app_notification.dart';
import 'package:bardak/app_ui/widgets/app_spacings.dart';
import 'package:bardak/app_ui/widgets/app_switch.dart';
import 'package:bardak/app_ui/widgets/bottom_sheet.dart';
import 'package:bardak/app_ui/widgets/language_icon.dart';
import 'package:bardak/app_ui/widgets/smart_number_text.dart';
import 'package:bardak/localizations/common/supported_locales.dart';
import 'package:bardak/settings/presentation/bloc/settings_bloc.dart';
import 'package:bardak/settings/presentation/bloc/settings_event.dart';
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
    final l10n = context.l10n;

    return Column(
      mainAxisSize: .min,
      crossAxisAlignment: .stretch,
      children: [
        height30,
        _SettingsCard(
          children: [
            for (final locale in AppLocales.values)
              _LanguageOptionRow(
                locale: locale,
                name: _localeName(context, locale),
                isSelected: locale == appSettings.locale,
                onTap: () => settingsBloc.add(ChangeLocale(locale)),
              ),
          ],
        ),
        height20,
        _SettingsCard(
          children: [
            _SettingsTile(
              icon: Icons.volume_up_rounded,
              iconColor: colors.green,
              label: l10n.sounds,
              onTap: () => settingsBloc.add(
                ChangeSoundEffects(soundEffects: !appSettings.soundEnabled),
              ),
              trailing: AppSwitch(
                value: appSettings.soundEnabled,
                onChanged: (value) {
                  settingsBloc.add(ChangeSoundEffects(soundEffects: value));
                },
              ),
            ),
          ],
        ),
        height20,
        _SettingsCard(
          children: [
            _SettingsTile(
              icon: Icons.mail_outline_rounded,
              iconColor: colors.orange,
              label: l10n.feedback,
              trailing: const _Chevron(),
              onTap: () => _sendFeedback(context),
            ),
            _SettingsTile(
              icon: Icons.star_outline_rounded,
              iconColor: colors.purple,
              label: l10n.rateApp,
              trailing: const _Chevron(),
              onTap: () {
                settingsBloc.add(const OpenStoreListingRequested());
              },
            ),
          ],
        ),
        height40,
        const _AppVersionText(),
      ],
    );
  }

  String _localeName(BuildContext context, AppLocales locale) {
    final l10n = context.l10n;
    return switch (locale) {
      AppLocales.en => l10n.settings_localeEnglish,
      AppLocales.ru => l10n.settings_localeRussian,
      AppLocales.am => l10n.settings_localeArmenian,
    };
  }

  Future<void> _sendFeedback(BuildContext context) async {
    final uri = Uri(
      scheme: 'mailto',
      path: 'bardak.feedback@gmail.com',
      queryParameters: {'subject': 'Bardak Feedback'},
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

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];
    for (var i = 0; i < children.length; i++) {
      rows.add(children[i]);
      if (i != children.length - 1) rows.add(const _TileDivider());
    }

    return Container(
      decoration: BoxDecoration(
        color: context.colors.black.withValues(alpha: 0.18),
        borderRadius: .circular(16),
      ),
      clipBehavior: .antiAlias,
      child: Column(mainAxisSize: .min, children: rows),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.iconColor,
    required this.label,
    this.trailing,
    this.onTap,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const .symmetric(horizontal: 14, vertical: 14),
          child: Row(
            children: [
              _IconTile(icon: icon, color: iconColor),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: context.typography.regular20,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (trailing != null) ...[
                const SizedBox(width: 8),
                trailing!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _LanguageOptionRow extends StatelessWidget {
  const _LanguageOptionRow({
    required this.locale,
    required this.name,
    required this.isSelected,
    required this.onTap,
  });

  final AppLocales locale;
  final String name;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              SizedBox(
                width: 32,
                child: Center(child: LanguageIcon(locale: locale, size: 30)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  name,
                  style: context.typography.regular20.copyWith(
                    color: isSelected ? colors.white : colors.white50,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (isSelected)
                Icon(Icons.check_rounded, color: colors.white, size: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _IconTile extends StatelessWidget {
  const _IconTile({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(9),
      ),
      child: Icon(icon, color: context.colors.white, size: 19),
    );
  }
}

class _TileDivider extends StatelessWidget {
  const _TileDivider();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 58),
      child: Container(
        height: 1,
        color: context.colors.white.withValues(alpha: 0.12),
      ),
    );
  }
}

class _Chevron extends StatelessWidget {
  const _Chevron();

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.chevron_right_rounded,
      color: context.colors.white50,
      size: 24,
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
