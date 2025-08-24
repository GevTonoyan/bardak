import 'package:boardify/alias_constants.dart';
import 'package:boardify/core/localizations/common/supported_locales.dart';
import 'package:boardify/core/ui_kit/widgets/circular_flag_icon.dart';
import 'package:boardify/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:boardify/features/settings/presentation/bloc/settings_event.dart';
import 'package:boardify/features/settings/presentation/bloc/settings_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:boardify/core/extensions/context_extension.dart';
import 'package:boardify/core/ui_kit/widgets/alias_setting_stepper.dart';
import 'package:flutter/material.dart';
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
    context.read<SettingsBloc>().add(GetSettings());
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    final colors = theme.colors;
    final text = theme.typography;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.localizations.alias_settings,
          style: text.titleLarge,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: BlocBuilder<SettingsBloc, SettingsState>(
            builder: (context, state) {
              final bloc = context.read<SettingsBloc>();
              final aliasSettings = state.gameSettings;

              final settings = state.appSettings;

              return ListView(
                children: [
                  // Alias Settings
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(
                      context.localizations.alias_settings_general,
                      style: text.titleMedium.copyWith(color: colors.primary),
                    ),
                  ),
                  AliasSettingStepper(
                    label: context.localizations.alias_settings_roundDuration,
                    value: aliasSettings.roundDuration,
                    min: AliasConstants.minRoundDuration,
                    max: AliasConstants.maxRoundDuration,
                    onChanged: (int value, {bool persist = true}) {
                      bloc.add(
                        ChangeGameDuration(
                          gameDuration: value,
                          persist: persist,
                        ),
                      );
                    },
                  ),
                  AliasSettingStepper(
                    label: context.localizations.alias_settings_pointsToWin,
                    value: aliasSettings.pointsToWin,
                    min: AliasConstants.minPointsToWin,
                    max: AliasConstants.maxPointsToWin,
                    onChanged: (int value, {bool persist = true}) {
                      bloc.add(
                        ChangePointsToWin(pointsToWin: value, persist: persist),
                      );
                    },
                  ),
                  Card(
                    child: SwitchListTile(
                      title: Text(
                        context.localizations.alias_settings_soundEffects,
                        style: text.bodyMedium.copyWith(
                          color: colors.onSurface,
                        ),
                      ),
                      value: aliasSettings.soundEnabled,
                      onChanged: (v) {
                        bloc.add(ChangeSoundEffects(v));
                      },
                      activeColor: colors.primary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(
                      context.localizations.alias_singleWordMode,
                      style: text.titleMedium.copyWith(color: colors.primary),
                    ),
                  ),
                  Card(
                    child: SwitchListTile(
                      title: Text(
                        context.localizations.alias_settings_allowSkipping,
                        style: text.bodyMedium.copyWith(
                          color: colors.onSurface,
                        ),
                      ),
                      value: aliasSettings.allowSkipping,
                      onChanged: (v) {
                        bloc.add(ChangeAllowSkipping(v));
                      },
                      activeColor: colors.primary,
                    ),
                  ),
                  Card(
                    child: SwitchListTile(
                      title: Text(
                        context.localizations.alias_settings_penaltyForSkipping,
                        style: text.bodyMedium.copyWith(
                          color: colors.onSurface,
                        ),
                      ),
                      value: aliasSettings.penaltyForSkipping,
                      onChanged: (v) {
                        bloc.add(ChangePenaltyForSkipping(v));
                      },
                      activeColor: colors.primary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(
                      context.localizations.alias_mode2,
                      style: text.titleMedium.copyWith(color: colors.primary),
                    ),
                  ),
                  AliasSettingStepper(
                    label: context.localizations.alias_settings_wordsPerCard,
                    value: aliasSettings.wordsPerCard,
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

                  const SizedBox(height: 24),

                  // General Settings
                  // 🔘 Dark Mode Toggle
                  Card(
                    color: colors.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: colors.outline),
                    ),
                    child: SwitchListTile(
                      title: Text(
                        context.localizations.settings_darkMode,
                        style: text.titleMedium.copyWith(
                          color: colors.onSurface,
                        ),
                      ),
                      value: settings.isDarkMode,
                      onChanged: (value) => bloc.add(ChangeTheme(value)),
                      secondary: Icon(
                        settings.isDarkMode
                            ? Icons.dark_mode
                            : Icons.light_mode,
                        color: colors.primary,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // 🌐 Language Selector Card
                  Card(
                    color: colors.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: colors.outline),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      leading: CircularFlagIcon(
                        assetPath: settings.locale.flagAssetPath,
                      ),
                      title: Text(
                        context.localizations.settings_localeName,
                        style: text.titleMedium.copyWith(
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

    showModalBottomSheet(
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
