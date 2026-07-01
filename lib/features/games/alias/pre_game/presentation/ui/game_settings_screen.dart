import 'dart:async';

import 'package:bardak/core/app_ui/widgets/app_button/app_button.dart';
import 'package:bardak/core/app_ui/widgets/app_button/app_stepper_button.dart';
import 'package:bardak/core/app_ui/widgets/app_button/app_switch_button.dart';
import 'package:bardak/core/app_ui/widgets/app_spacings.dart';
import 'package:bardak/core/app_ui/widgets/bottom_sheet.dart';
import 'package:bardak/core/constants/app_constants.dart';
import 'package:bardak/core/extensions/context_extension.dart';
import 'package:bardak/features/games/alias/game_settings/presentation/bloc/game_settings_bloc.dart';
import 'package:bardak/features/games/alias/game_settings/presentation/bloc/game_settings_event.dart';
import 'package:bardak/features/games/alias/pre_game/domain/entities/pre_game_entity.dart';
import 'package:bardak/features/games/alias/pre_game/presentation/bloc/pre_game_bloc.dart';
import 'package:bardak/features/games/alias/pre_game/presentation/ui/setup_team_names_screen.dart';
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
    return buildAppBottomSheet<void>(
      context: context,
      settings: this,
      child: FullBottomSheet(
        titleBuilder: (context) => context.l10n.settings,
        child: _GameSettingsBody(selectedMode),
      ),
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
    final l10n = context.l10n;

    final gameSettingsBloc = context.watch<GameSettingsBloc>();
    final gameSettings = gameSettingsBloc.state.gameSettings;

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
                    l10n.settings_game_mode,
                    style: typography.regular24,
                  ),
                  height20,
                  Row(
                    spacing: 10,
                    children: [
                      Expanded(
                        child: AppButton(
                          label: l10n.classicModeShort,
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
                          label: l10n.oneWordModeShort,
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
                    l10n.settings_round_time,
                    style: typography.regular24,
                  ),
                  height20,
                  AppStepperButton(
                    label: l10n.unit_sec(roundDuration),
                    onDecrement: canDecreaseRoundDuration
                        ? () {
                            gameSettingsBloc.add(
                              ChangeRoundDuration(roundDuration - 5),
                            );
                          }
                        : null,
                    onIncrement: canIncreaseRoundDuration
                        ? () {
                            gameSettingsBloc.add(
                              ChangeRoundDuration(roundDuration + 5),
                            );
                          }
                        : null,
                  ),
                  height40,
                  Text(
                    l10n.settings_points_to_win,
                    style: typography.regular24,
                  ),
                  height20,
                  AppStepperButton(
                    label: l10n.unit_pts(pointsToWin),
                    onDecrement: canDecrementPointsToWin
                        ? () {
                            gameSettingsBloc.add(
                              ChangePointsToWin(pointsToWin - 5),
                            );
                          }
                        : null,
                    onIncrement: canIncrementPointsToWin
                        ? () {
                            gameSettingsBloc.add(
                              ChangePointsToWin(pointsToWin + 5),
                            );
                          }
                        : null,
                  ),
                  if (gameMode == .singleWord) ...[
                    height40,
                    AppSwitchButton(
                      label: l10n.settings_allow_skipping,
                      value: gameSettings.allowSkipping,
                      onPressed: () {
                        gameSettingsBloc.add(
                          ChangeAllowSkipping(
                            allowSkipping: !gameSettings.allowSkipping,
                          ),
                        );
                      },
                      onChanged: (value) {
                        gameSettingsBloc.add(
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
            label: l10n.proceed,
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
