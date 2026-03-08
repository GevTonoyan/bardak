import 'dart:async';

import 'package:alias_pro/app_ui/widgets/app_button/app_button.dart';
import 'package:alias_pro/app_ui/widgets/app_button/app_stepper_button.dart';
import 'package:alias_pro/app_ui/widgets/app_button/app_switch_button.dart';
import 'package:alias_pro/app_ui/widgets/app_spacings.dart';
import 'package:alias_pro/app_ui/widgets/bottom_sheet.dart';
import 'package:alias_pro/pre_game/domain/entities/pre_game_entity.dart';
import 'package:alias_pro/pre_game/presentation/bloc/pre_game_bloc.dart';
import 'package:alias_pro/pre_game/presentation/ui/setup_team_names_screen.dart';
import 'package:alias_pro/settings/presentation/bloc/settings_bloc.dart';
import 'package:alias_pro/settings/presentation/bloc/settings_event.dart';
import 'package:alias_pro/utils/constants/constants.dart';
import 'package:alias_pro/utils/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class GameSettingsScreen extends Page<void> {
  const GameSettingsScreen({required this.selectedMode, super.key});

  static const routePath = 'gameSettings';
  static const gameModeKey = 'gameMode';

  final GameMode selectedMode;

  @override
  Route<void> createRoute(BuildContext context) {
    return buildAppBottomSheetRoute<void>(
      context: context,
      settings: this,
      child: _GameSettingsBody(selectedMode),
      title: context.l10n.settings,
    );
  }
}

class _GameSettingsBody extends StatefulWidget {
  const _GameSettingsBody(this.selectedMode);

  final GameMode selectedMode;

  @override
  State<_GameSettingsBody> createState() => _GameSettingsBodyState();
}

class _GameSettingsBodyState extends State<_GameSettingsBody> {
  late GameMode gameMode = widget.selectedMode;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;

    final settingsBloc = context.watch<SettingsBloc>();
    final gameSettings = settingsBloc.state.gameSettings;

    final roundDuration = gameSettings.roundDuration;
    final pointsToWin = gameSettings.pointsToWin;

    final canDecreaseRoundDuration =
        roundDuration > AppConstants.minRoundDuration;
    final canIncreaseRoundDuration =
        roundDuration < AppConstants.maxRoundDuration;
    final canDecrementPointsToWin = pointsToWin > AppConstants.minPointsToWin;
    final canIncrementPointsToWin = pointsToWin < AppConstants.maxPointsToWin;

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.8,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  height30,
                  Text(
                    'Ռեժիմ',
                    style: typography.regular24.copyWith(color: colors.white),
                  ),
                  height20,
                  Row(
                    spacing: 10,
                    children: [
                      Expanded(
                        child: AppButton(
                          label: 'Կլասիկ',
                          color: colors.white20,
                          isPressed: gameMode == GameMode.card,
                          pressedColor: colors.white,
                          pressedTextColor: colors.secondary,
                          onPressed: () {
                            setState(() {
                              gameMode = GameMode.card;
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: AppButton(
                          label: 'Մեկ բառ',
                          color: colors.white20,
                          isPressed: gameMode == GameMode.singleWord,
                          pressedColor: colors.white,
                          pressedTextColor: colors.secondary,
                          onPressed: () {
                            setState(() {
                              gameMode = GameMode.singleWord;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  height40,
                  Text(
                    'Փուլի տևողությունը՝',
                    style: typography.regular24.copyWith(color: colors.white),
                  ),
                  height20,
                  AppStepperButton(
                    label: '$roundDuration վրկ',
                    onDecrement: canDecreaseRoundDuration
                        ? () {
                            settingsBloc.add(
                              ChangeGameDuration(
                                gameDuration: roundDuration - 5,
                              ),
                            );
                          }
                        : null,
                    onIncrement: canIncreaseRoundDuration
                        ? () {
                            settingsBloc.add(
                              ChangeGameDuration(
                                gameDuration: roundDuration + 5,
                              ),
                            );
                          }
                        : null,
                  ),
                  height40,
                  Text(
                    'Միավոր հաղթելու համար՝',
                    style: typography.regular24.copyWith(color: colors.white),
                  ),
                  height20,
                  AppStepperButton(
                    label: '$pointsToWin միավոր',
                    onDecrement: canDecrementPointsToWin
                        ? () {
                            settingsBloc.add(
                              ChangePointsToWin(pointsToWin: pointsToWin - 5),
                            );
                          }
                        : null,
                    onIncrement: canIncrementPointsToWin
                        ? () {
                            settingsBloc.add(
                              ChangePointsToWin(pointsToWin: pointsToWin + 5),
                            );
                          }
                        : null,
                  ),
                  if (gameMode == .singleWord) ...[
                    height40,
                    AppSwitchButton(
                      label: 'Կարելի է բաց թողել',
                      value: gameSettings.allowSkipping,
                      onPressed: () {
                        settingsBloc.add(
                          ChangeAllowSkipping(
                            allowSkipping: !gameSettings.allowSkipping,
                          ),
                        );
                      },
                      onChanged: (value) {
                        settingsBloc.add(
                          ChangeAllowSkipping(allowSkipping: value),
                        );
                      },
                    ),
                  ],
                ],
              ),
            ),
          ),
          height20,
          AppButton(
            label: 'Շարունակել',
            color: colors.green,
            onPressed: () {
              context.read<PreGameBloc>().add(ChangeGameModeEvent(gameMode));
              unawaited(context.pushNamed(SetupTeamNamesScreen.routePath));
            },
          ),
        ],
      ),
    );
  }
}
