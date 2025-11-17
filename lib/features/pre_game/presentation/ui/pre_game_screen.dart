import 'package:boardify/alias_constants.dart';
import 'package:boardify/core/extensions/context_extension.dart';
import 'package:boardify/core/extensions/state_extension.dart';
import 'package:boardify/core/ui_kit/widgets/setting_option_chips.dart';
import 'package:boardify/core/ui_kit/widgets/setting_stepper.dart';
import 'package:boardify/core/ui_kit/widgets/setting_switch_tile.dart';
import 'package:boardify/features/game_session/domain/entities/game_session_entity.dart';
import 'package:boardify/features/game_session/presentation/ui/game_session_screen.dart';
import 'package:boardify/features/pre_game/domain/entities/pre_game_entity.dart';
import 'package:boardify/features/pre_game/presentation/bloc/pre_game_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class PreGameScreen extends StatefulWidget {
  const PreGameScreen({super.key});

  static const routePath = 'pre_game';

  @override
  State<PreGameScreen> createState() => _PreGameScreenState();
}

class _PreGameScreenState extends State<PreGameScreen> {
  final List<TextEditingController> _teamControllers = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    context.read<PreGameBloc>().add(
      GetPreGameConfig(
        teamNames: [
          '${context.l10n.preGameTeam} 1',
          '${context.l10n.preGameTeam} 2',
        ],
        localeCode: context.locale.languageCode,
      ),
    );

    _teamControllers
      ..add(TextEditingController(text: '${context.l10n.preGameTeam} 1'))
      ..add(TextEditingController(text: '${context.l10n.preGameTeam} 2'));
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
    final bloc = context.read<PreGameBloc>();

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.preGameTitle)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
          child: BlocBuilder<PreGameBloc, PreGameState>(
            builder: (context, state) {
              final preGameConfig = state is PreGameLoadedState
                  ? state.preGameConfig
                  : PreGameEntity.initial();

              return Column(
                children: [
                  Expanded(
                    child: ListView(
                      children: [
                        Text(
                          context.l10n.selectMode,
                          style: typography.titleMedium.copyWith(
                            color: colors.onBackground,
                          ),
                        ),
                        const SizedBox(height: 8),
                        _GameModeSelector(
                          onChanged: (mode) {
                            bloc.add(ChangeGameModeEvent(mode));
                          },
                        ),
                        const SizedBox(height: 24),

                        Text(
                          context.l10n.preGameTeamSetup,
                          style: typography.titleMedium.copyWith(
                            color: colors.onBackground,
                          ),
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
                                          '${context.l10n.preGameTeam} '
                                          '${index + 1}',
                                      border: const OutlineInputBorder(),
                                      counterText: '',
                                    ),
                                  ),
                                ),
                                if (_teamControllers.length >
                                    AliasConstants.minTeamCount)
                                  IconButton(
                                    icon: const Icon(
                                      Icons.remove_circle_outline,
                                    ),
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
                        if (_teamControllers.length <
                            AliasConstants.maxTeamCount)
                          Align(
                            alignment: Alignment.centerLeft,
                            child: TextButton.icon(
                              onPressed: () {
                                final teamName =
                                    '${context.l10n.preGameTeam} '
                                    '${_teamControllers.length + 1}';
                                _teamControllers.add(
                                  TextEditingController(text: teamName),
                                );
                                bloc.add(AddTeamEvent(teamName));
                              },
                              icon: const Icon(Icons.add),
                              label: Text(context.l10n.preGameAddTeam),
                            ),
                          ),
                        const SizedBox(height: 20),

                        SettingOptionChips(
                          title: context.l10n.settings_roundDuration,
                          options: const [30, 60, 90, 120],
                          currentValue: preGameConfig.roundDuration,
                          onOptionChanged: (duration) {
                            bloc.add(ChangeRoundDurationEvent(duration));
                          },
                        ),

                        SettingOptionChips(
                          title: context.l10n.settings_pointsToWin,
                          options: const [30, 60, 90, 120],
                          currentValue: preGameConfig.pointsToWin,
                          onOptionChanged: (points) {
                            bloc.add(ChangePointsToWinEvent(points));
                          },
                        ),

                        if (preGameConfig.gameMode == GameMode.card)
                          SettingStepper(
                            label: context.l10n.settings_wordsPerCard,
                            value: preGameConfig.wordsPerCard,
                            min: AliasConstants.minWordsPerCard,
                            max: AliasConstants.maxWordsPerCard,
                            onChanged: (int value, {bool persist = true}) {
                              bloc.add(ChangeWordsPerCardEvent(value));
                            },
                          ),
                        if (preGameConfig.gameMode == GameMode.singleWord) ...[
                          SettingSwitchTile(
                            title: context.l10n.settings_allowSkipping,
                            value: preGameConfig.allowSkipping,
                            onChanged: (value) {
                              bloc.add(
                                ChangeAllowSkippingEvent(allowSkipping: value),
                              );
                            },
                          ),
                          SettingSwitchTile(
                            title: context.l10n.settings_penaltyForSkipping,
                            value: preGameConfig.penaltyForSkipping,
                            onChanged: (value) {
                              bloc.add(
                                ChangePenaltyForSkippingEvent(
                                  penaltyForSkipping: value,
                                ),
                              );
                            },
                          ),
                        ],
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: double.maxFinite,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        if (state is PreGameLoadedState) {
                          final preGameConfig = state.preGameConfig;
                          preGameConfig.words.shuffle();

                          final gameSession = GameSessionEntity(
                            gameMode: preGameConfig.gameMode,
                            teamStates: preGameConfig.teamNames.map((teamName) {
                              return AliasTeamStateEntity(
                                name: teamName,
                                roundScores: [],
                              );
                            }).toList(),
                            roundDuration: preGameConfig.roundDuration,
                            pointsToWin: preGameConfig.pointsToWin,
                            soundEnabled: preGameConfig.soundEnabled,
                            wordsPerCard: preGameConfig.wordsPerCard,
                            allowSkipping: preGameConfig.allowSkipping,
                            penaltyForSkipping:
                                preGameConfig.penaltyForSkipping,
                            currentTeamIndex: 0,
                            currentRoundIndex: 0,
                            words: preGameConfig.words,
                          );

                          _navigateToGameSession(gameSession);
                        }
                      },
                      icon: const Icon(Icons.play_arrow),
                      label: Text(context.l10n.general_startGame),
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

  void _navigateToGameSession(GameSessionEntity gameSession) {
    context.goNamed(GameSessionScreen.routePath, extra: gameSession);
  }
}

class _GameModeSelector extends StatelessWidget {
  const _GameModeSelector({required this.onChanged});

  final void Function(GameMode mode) onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = context.appTheme;
    final colors = theme.colors;
    final text = theme.typography;

    final bloc = context.read<PreGameBloc>();
    final selectedGameMode = bloc.state is PreGameLoadedState
        ? (bloc.state as PreGameLoadedState).preGameConfig.gameMode
        : GameMode.card;

    return Row(
      children: List.generate(GameMode.values.length, (index) {
        final isSelected = selectedGameMode == GameMode.values[index];

        final gameMode = GameMode.values[index];
        final title = switch (gameMode) {
          GameMode.card => context.l10n.mode2,
          GameMode.singleWord => context.l10n.mode1,
        };

        return GestureDetector(
          onTap: () {
            onChanged.call(GameMode.values[index]);
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
                  color: colors.shadow.withValues(
                    alpha: isSelected ? 0.3 : 0.1,
                  ),
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
