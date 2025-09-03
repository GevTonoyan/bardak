import 'package:boardify/alias_constants.dart';
import 'package:boardify/core/extensions/context_extension.dart';
import 'package:boardify/core/extensions/state_extension.dart';
import 'package:boardify/core/localizations/common/supported_locales.dart';
import 'package:boardify/core/ui_kit/widgets/circular_flag_icon.dart';
import 'package:boardify/core/ui_kit/widgets/setting_option_chips.dart';
import 'package:boardify/core/ui_kit/widgets/setting_stepper.dart';
import 'package:boardify/core/ui_kit/widgets/setting_switch_tile.dart';
import 'package:boardify/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:boardify/features/settings/presentation/bloc/settings_event.dart';
import 'package:boardify/features/settings/presentation/bloc/settings_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  static const routePath = 'settings';

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<SettingsBloc>().add(const GetSettings());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.settings, style: typography.titleLarge),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: BlocBuilder<SettingsBloc, SettingsState>(
            builder: (context, state) {
              final bloc = context.read<SettingsBloc>();
              final gameSettings = state.gameSettings;

              final appSettings = state.appSettings;

              return ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(
                      context.l10n.app_settings,
                      style: typography.titleMedium.copyWith(
                        color: colors.primary,
                      ),
                    ),
                  ),

                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: SwitchListTile(
                      title: Text(
                        context.l10n.settings_darkMode,
                        style: typography.titleMedium.copyWith(
                          color: colors.onSurface,
                        ),
                      ),
                      value: appSettings.isDarkMode,
                      onChanged:
                          (value) => bloc.add(ChangeTheme(isDarkMode: value)),
                      secondary: Icon(
                        appSettings.isDarkMode
                            ? Icons.dark_mode
                            : Icons.light_mode,
                        color: colors.primary,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                    ),
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      leading: CircularFlagIcon(
                        assetPath: appSettings.locale.flagAssetPath,
                      ),
                      title: Text(
                        context.l10n.settings_localeName,
                        style: typography.titleMedium.copyWith(
                          color: colors.onSurface,
                        ),
                      ),
                      trailing: Icon(
                        Icons.arrow_drop_down,
                        color: colors.primary,
                      ),
                      onTap: () => _showLocaleSelector(context),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(
                      context.l10n.settings_general,
                      style: typography.titleMedium.copyWith(
                        color: colors.primary,
                      ),
                    ),
                  ),

                  SettingOptionChips(
                    title: context.l10n.settings_roundDuration,
                    options: const [30, 60, 90, 120],
                    currentValue: gameSettings.roundDuration,
                    onOptionChanged: (duration) {
                      context.read<SettingsBloc>().add(
                        ChangeGameDuration(gameDuration: duration),
                      );
                    },
                  ),

                  SettingOptionChips(
                    title: context.l10n.settings_pointsToWin,
                    options: const [30, 60, 90, 120],
                    currentValue: gameSettings.pointsToWin,
                    onOptionChanged: (points) {
                      context.read<SettingsBloc>().add(
                        ChangePointsToWin(pointsToWin: points),
                      );
                    },
                  ),
                  SettingSwitchTile(
                    title: context.l10n.settings_soundEffects,
                    value: gameSettings.soundEnabled,
                    onChanged: (value) {
                      bloc.add(ChangeSoundEffects(soundEffects: value));
                    },
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(
                      context.l10n.singleWordMode,
                      style: typography.titleMedium.copyWith(
                        color: colors.primary,
                      ),
                    ),
                  ),

                  SettingSwitchTile(
                    title: context.l10n.settings_allowSkipping,
                    value: gameSettings.allowSkipping,
                    onChanged: (value) {
                      bloc.add(ChangeAllowSkipping(allowSkipping: value));
                    },
                  ),
                  SettingSwitchTile(
                    title: context.l10n.settings_penaltyForSkipping,
                    value: gameSettings.penaltyForSkipping,
                    onChanged: (value) {
                      bloc.add(
                        ChangePenaltyForSkipping(penaltyForSkipping: value),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(
                      context.l10n.mode2,
                      style: typography.titleMedium.copyWith(
                        color: colors.primary,
                      ),
                    ),
                  ),
                  SettingStepper(
                    label: context.l10n.settings_wordsPerCard,
                    value: gameSettings.wordsPerCard,
                    min: AliasConstants.minWordsPerCard,
                    max: AliasConstants.maxWordsPerCard,
                    onChanged: (int value, {bool persist = true}) {
                      bloc.add(
                        ChangeWordsPerCard(
                          wordsPerCard: value,
                          persist: persist,
                        ),
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void _showLocaleSelector(BuildContext context) {
    final bloc = context.read<SettingsBloc>();
    final currentLocale = bloc.state.appSettings.locale;

    final theme = context.appTheme;

    showModalBottomSheet<void>(
      context: context,
      backgroundColor: theme.colors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return ListView(
          shrinkWrap: true,
          children:
              AppLocales.values.map((locale) {
                final isSelected = locale == currentLocale;
                return ListTile(
                  leading: CircularFlagIcon(assetPath: locale.flagAssetPath),
                  title: Text(
                    locale.name(context),
                    style: theme.typography.bodyMedium.copyWith(
                      color: theme.colors.onSurface,
                    ),
                  ),
                  trailing:
                      isSelected
                          ? Icon(Icons.check, color: theme.colors.primary)
                          : null,
                  onTap: () {
                    context.pop();
                    bloc.add(ChangeLocale(locale));
                  },
                );
              }).toList(),
        );
      },
    );
  }
}
