import 'package:alias/core/alias_route.dart';
import 'package:alias/core/alias_constants.dart';
import 'package:alias/features/feature_pre_game/domain/usecases/alias_pre_game_config.dart';
import 'package:alias/features/feature_pre_game/presentation/bloc/alias_pre_game_bloc.dart';
import 'package:app_core/extensions/context_extension.dart';
import 'package:app_core/ui_kit/widgets/alias_setting_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

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
                                    maxLength: 20,
                                    decoration: InputDecoration(
                                      hintText:
                                          '${context.localizations.alias_preGameTeam} ${index + 1}',
                                      border: const OutlineInputBorder(),
                                      counterText: '',
                                    ),
                                  ),
                                ),
                                if (_teamControllers.length > 2)
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
                            AliasRouteNames.roundOverview,
                            extra: state.preGameConfig,
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
