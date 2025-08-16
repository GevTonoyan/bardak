import 'package:boardify/alias_constants.dart';
import 'package:boardify/alias_constants.dart';
import 'package:boardify/features/feature_alias_settings/presentation/bloc/alias_settings_bloc.dart';
import 'package:boardify/features/feature_alias_settings/presentation/bloc/alias_settings_event.dart';
import 'package:boardify/features/feature_alias_settings/presentation/bloc/alias_settings_state.dart';
import 'package:boardify/features/feature_alias_settings/presentation/ui/alias_settings_screen.dart';
import 'package:boardify/features/feature_gameplay/presentation/bloc/blocs/alias_gameplay_bloc/alias_gameplay_bloc.dart';
import 'package:boardify/features/feature_gameplay/presentation/ui/alias_card_round_screen.dart';
import 'package:boardify/features/feature_gameplay/presentation/ui/alias_countdown_screen.dart';
import 'package:boardify/features/feature_gameplay/presentation/ui/alias_gameplay_screen.dart';
import 'package:boardify/features/feature_gameplay/presentation/ui/alias_round_overview_screen.dart';
import 'package:boardify/features/feature_main/presentation/bloc/alias_main_bloc.dart';
import 'package:boardify/features/feature_pre_game/domain/usecases/alias_pre_game_config.dart';
import 'package:boardify/features/feature_pre_game/presentation/bloc/alias_pre_game_bloc.dart';
import 'package:boardify/features/feature_pre_game/presentation/ui/alias_pre_game_screen.dart';
import 'package:boardify/features/feature_rules/presentation/ui/alias_rules_screen.dart';
import 'package:boardify/features/feature_word_pack/presentation/bloc/alias_word_packs_bloc.dart';
import 'package:boardify/features/feature_word_pack/presentation/ui/alias_word_packs_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:boardify/core/extensions/context_extension.dart';
import 'package:boardify/core/ui_kit/widgets/alias_setting_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AliasSettingsScreen extends StatefulWidget {
  const AliasSettingsScreen({super.key});

  @override
  State<AliasSettingsScreen> createState() => _AliasSettingsScreenState();
}

class _AliasSettingsScreenState extends State<AliasSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    final colors = theme.colors;
    final text = theme.typography;

    return Scaffold(
      appBar: AppBar(title: Text(context.localizations.alias_settings, style: text.titleLarge)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: BlocBuilder<AliasSettingsBloc, AliasSettingsLoaded>(
            bloc: context.read<AliasSettingsBloc>()..add(GetAliasSettings()),
            builder: (context, state) {
              final bloc = context.read<AliasSettingsBloc>();
              final aliasSettings = state.aliasSettings;

              return ListView(
                children: [
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
                      bloc.add(ChangeGameDuration(gameDuration: value, persist: persist));
                    },
                  ),
                  AliasSettingStepper(
                    label: context.localizations.alias_settings_pointsToWin,
                    value: aliasSettings.pointsToWin,
                    min: AliasConstants.minPointsToWin,
                    max: AliasConstants.maxPointsToWin,
                    onChanged: (int value, {bool persist = true}) {
                      bloc.add(ChangePointsToWin(pointsToWin: value, persist: persist));
                    },
                  ),
                  Card(
                    child: SwitchListTile(
                      title: Text(
                        context.localizations.alias_settings_soundEffects,
                        style: text.bodyMedium.copyWith(color: colors.onSurface),
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
                        style: text.bodyMedium.copyWith(color: colors.onSurface),
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
                        style: text.bodyMedium.copyWith(color: colors.onSurface),
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
                      bloc.add(ChangeWordsPerCard(wordsPerCard: value, persist: persist));
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
}
