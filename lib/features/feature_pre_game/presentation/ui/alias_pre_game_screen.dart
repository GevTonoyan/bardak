import 'dart:async';

import 'package:boardify/alias_constants.dart';
import 'package:boardify/alias_constants.dart';
import 'package:boardify/alias_constants.dart';
import 'package:boardify/core/router/app_router.dart';
import 'package:boardify/features/settings/data/data_sources/settings_local_data_source.dart';
import 'package:boardify/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:boardify/features/settings/domain/entities/game_settings_entity.dart';
import 'package:boardify/features/settings/domain/repositories/settings_repository.dart';
import 'package:boardify/features/settings/domain/usecases/get_game_settings_usecase.dart';
import 'package:boardify/features/settings/domain/usecases/update_game_settings_usecase.dart';
import 'package:boardify/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:boardify/features/settings/presentation/bloc/settings_event.dart';
import 'package:boardify/features/settings/presentation/bloc/settings_state.dart';
import 'package:boardify/features/settings/presentation/ui/settings_screen.dart';
import 'package:boardify/features/feature_gameplay/domain/entities/alias_game_state_entity.dart';
import 'package:boardify/features/feature_gameplay/presentation/bloc/blocs/alias_gameplay_bloc/alias_gameplay_bloc.dart';
import 'package:boardify/features/feature_gameplay/presentation/ui/alias_card_round_screen.dart';
import 'package:boardify/features/feature_gameplay/presentation/ui/alias_countdown_screen.dart';
import 'package:boardify/features/feature_gameplay/presentation/ui/alias_gameplay_screen.dart';
import 'package:boardify/features/feature_gameplay/presentation/ui/alias_round_overview_screen.dart';
import 'package:boardify/features/feature_main/data/data_sources/alias_main_local_data_source.dart';
import 'package:boardify/features/feature_main/data/data_sources/alias_main_remote_data_source.dart';
import 'package:boardify/features/feature_main/data/repositories/alias_main_repository_impl.dart';
import 'package:boardify/features/feature_main/domain/entities/alias_word_pack_entity.dart';
import 'package:boardify/features/feature_main/domain/repositories/alias_main_repository.dart';
import 'package:boardify/features/feature_main/domain/usecases/are_word_packs_cached_usecase.dart';
import 'package:boardify/features/feature_main/domain/usecases/fetch_and_cache_word_packs_usecase.dart';
import 'package:boardify/features/feature_main/domain/usecases/get_selected_word_pack_name_usecase.dart';
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
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AliasPreGameScreen extends StatefulWidget {
  const AliasPreGameScreen({super.key});

  @override
  State<AliasPreGameScreen> createState() => _AliasPreGameScreenState();
}

class _AliasPreGameScreenState extends State<AliasPreGameScreen> {
  final List<TextEditingController> _teamControllers = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.read<AliasPreGameBloc>().add(
      GetAliasPreGameConfig(
        teamNames: [
          '${context.localizations.alias_preGameTeam} 1',
          '${context.localizations.alias_preGameTeam} 2',
        ],
      ),
    );

    _teamControllers.add(
      TextEditingController(text: '${context.localizations.alias_preGameTeam} 1'),
    );

    _teamControllers.add(
      TextEditingController(text: '${context.localizations.alias_preGameTeam} 2'),
    );
  }

  @override
  void dispose() {
    for (final controller in _teamControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    final colors = theme.colors;
    final text = theme.typography;

    final bloc = context.read<AliasPreGameBloc>();

    return Scaffold(
      appBar: AppBar(title: Text(context.localizations.alias_preGameTitle)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
          child: BlocBuilder<AliasPreGameBloc, AliasPreGameState>(
            builder: (context, state) {
              final preGameConfig =
                  state is AliasPreGameLoadedState
                      ? state.preGameConfig
                      : AliasPreGameConfig.initial();

              return Column(
                children: [
                  Expanded(
                    child: ListView(
                      children: [
                        Text(
                          context.localizations.alias_selectMode,
                          style: text.titleMedium.copyWith(color: colors.onBackground),
                        ),
                        const SizedBox(height: 8),
                        _GameModeSelector(
                          onChanged: (mode) {
                            bloc.add(ChangeGameModeEvent(mode));
                          },
                        ),
                        const SizedBox(height: 24),

                        Text(
                          context.localizations.alias_preGameTeamSetup,
                          style: text.titleMedium.copyWith(color: colors.onBackground),
                        ),
                        const SizedBox(height: 12),
                        ...List.generate(_teamControllers.length, (index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: _teamControllers[index],
                                    maxLength: AliasConstants.teamNameMaxLength,
                                    decoration: InputDecoration(
                                      hintText:
                                          '${context.localizations.alias_preGameTeam} ${index + 1}',
                                      border: const OutlineInputBorder(),
                                      counterText: '',
                                    ),
                                  ),
                                ),
                                if (_teamControllers.length > AliasConstants.minTeamCount)
                                  IconButton(
                                    icon: const Icon(Icons.remove_circle_outline),
                                    color: colors.error,
                                    onPressed: () {
                                      _teamControllers[index].dispose();
                                      _teamControllers.removeAt(index);
                                      bloc.add(RemoveTeamEvent(index));
                                    },
                                  ),
                              ],
                            ),
                          );
                        }),
                        if (_teamControllers.length < AliasConstants.maxTeamCount)
                          Align(
                            alignment: Alignment.centerLeft,
                            child: TextButton.icon(
                              onPressed: () {
                                final teamName =
                                    '${context.localizations.alias_preGameTeam} ${_teamControllers.length + 1}';
                                _teamControllers.add(TextEditingController(text: teamName));
                                bloc.add(AddTeamEvent(teamName));
                              },
                              icon: const Icon(Icons.add),
                              label: Text(context.localizations.alias_preGameAddTeam),
                            ),
                          ),
                        const SizedBox(height: 20),

                        AliasSettingStepper(
                          label: context.localizations.alias_settings_roundDuration,
                          value: preGameConfig.roundDuration,
                          min: AliasConstants.minRoundDuration,
                          max: AliasConstants.maxRoundDuration,
                          onChanged: (int value, {bool persist = true}) {
                            bloc.add(ChangeRoundDurationEvent(value));
                          },
                        ),
                        AliasSettingStepper(
                          label: context.localizations.alias_settings_pointsToWin,
                          value: preGameConfig.pointsToWin,
                          min: AliasConstants.minPointsToWin,
                          max: AliasConstants.maxPointsToWin,
                          onChanged: (int value, {bool persist = true}) {
                            bloc.add(ChangePointsToWinEvent(value));
                          },
                        ),
                        if (preGameConfig.gameMode == AliasGameMode.card)
                          AliasSettingStepper(
                            label: context.localizations.alias_settings_wordsPerCard,
                            value: preGameConfig.wordsPerCard,
                            min: AliasConstants.minWordsPerCard,
                            max: AliasConstants.maxWordsPerCard,
                            onChanged: (int value, {bool persist = true}) {
                              bloc.add(ChangeWordsPerCardEvent(value));
                            },
                          ),
                        if (preGameConfig.gameMode == AliasGameMode.singleWord) ...[
                          Card(
                            child: SwitchListTile(
                              title: Text(
                                context.localizations.alias_settings_allowSkipping,
                                style: text.bodyMedium.copyWith(color: colors.onSurface),
                              ),
                              value: preGameConfig.allowSkipping,
                              onChanged: (value) {
                                bloc.add(ChangeAllowSkippingEvent(value));
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
                              value: preGameConfig.penaltyForSkipping,
                              onChanged: (value) {
                                bloc.add(ChangePenaltyForSkippingEvent(value));
                              },
                              activeColor: colors.primary,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  SizedBox(
                    width: double.maxFinite,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        if (state is AliasPreGameLoadedState) {
                          context.goNamed(
                            RouteNames.roundOverview,
                            queryParameters: {
                              AliasConstants.preGameConfigKey:
                                  state.preGameConfig
                                      .copyWith(
                                        teamNames: _teamControllers.map((c) => c.text).toList(),
                                      )
                                      .toJson(),
                            },
                          );
                        }
                      },
                      icon: const Icon(Icons.play_arrow),
                      label: Text(context.localizations.general_startGame),
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
}

class _GameModeSelector extends StatelessWidget {
  final void Function(AliasGameMode mode) onChanged;

  const _GameModeSelector({required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    final colors = theme.colors;
    final text = theme.typography;

    final bloc = context.read<AliasPreGameBloc>();
    final selectedGameMode =
        bloc.state is AliasPreGameLoadedState
            ? (bloc.state as AliasPreGameLoadedState).preGameConfig.gameMode
            : AliasGameMode.card;

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: List.generate(AliasGameMode.values.length, (index) {
        final isSelected = selectedGameMode == AliasGameMode.values[index];

        final gameMode = AliasGameMode.values[index];
        final title = switch (gameMode) {
          AliasGameMode.card => context.localizations.alias_mode2,
          AliasGameMode.singleWord => context.localizations.alias_mode1,
        };

        return GestureDetector(
          onTap: () {
            onChanged.call(AliasGameMode.values[index]);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            margin: const EdgeInsets.symmetric(horizontal: 6),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected ? colors.primary : colors.surface,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: colors.shadow.withValues(alpha: isSelected ? 0.3 : 0.1),
                  offset: const Offset(0, 2),
                  blurRadius: 6,
                ),
              ],
            ),
            child: Text(
              title,
              style: text.bodyMedium.copyWith(
                color: isSelected ? colors.onPrimary : colors.onSurface,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
        );
      }),
    );
  }
}
