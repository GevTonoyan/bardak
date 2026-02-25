import 'dart:async';

import 'package:boardify/app_ui/widgets/app_button.dart';
import 'package:boardify/app_ui/widgets/app_spacings.dart';
import 'package:boardify/app_ui/widgets/app_switch.dart';
import 'package:boardify/app_ui/widgets/bottom_sheet.dart';
import 'package:boardify/pre_game/domain/entities/pre_game_entity.dart';
import 'package:boardify/pre_game/presentation/bloc/pre_game_bloc.dart';
import 'package:boardify/pre_game/presentation/ui/setup_team_names_screen.dart';
import 'package:boardify/settings/presentation/bloc/settings_bloc.dart';
import 'package:boardify/settings/presentation/bloc/settings_event.dart';
import 'package:boardify/utils/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class PreGameSettingsScreen extends Page<void> {
  const PreGameSettingsScreen({required this.selectedMode, super.key});

  static const routePath = 'preGameSettings';
  static const gameModeKey = 'gameMode';

  final GameMode selectedMode;

  @override
  Route<void> createRoute(BuildContext context) {
    return buildAppBottomSheetRoute<void>(
      context: context,
      settings: this,
      child: _PreGameSettingsBody(selectedMode),
      title: context.l10n.settings,
    );
  }
}

class _PreGameSettingsBody extends StatefulWidget {
  const _PreGameSettingsBody(this.selectedMode);

  final GameMode selectedMode;

  @override
  State<_PreGameSettingsBody> createState() => _PreGameSettingsBodyState();
}

class _PreGameSettingsBodyState extends State<_PreGameSettingsBody> {
  late GameMode gameMode = widget.selectedMode;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;

    final settingsBloc = context.watch<SettingsBloc>();
    final gameSettings = settingsBloc.state.gameSettings;

    final roundDuration = gameSettings.roundDuration;
    final pointsToWin = gameSettings.pointsToWin;

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.8,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  height40,
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
                  AppButton(
                    label: '$roundDuration վրկ',
                    color: colors.white20,
                    animateOnPress: false,
                    icon: IconButton(
                      onPressed: () {
                        settingsBloc.add(
                          ChangeGameDuration(gameDuration: roundDuration - 5),
                        );
                      },
                      icon: Icon(Icons.remove, color: colors.white),
                    ),
                    suffix: IconButton(
                      onPressed: () {
                        settingsBloc.add(
                          ChangeGameDuration(gameDuration: roundDuration + 5),
                        );
                      },
                      icon: Icon(Icons.add, color: colors.white),
                    ),
                  ),
                  height40,
                  Text(
                    'Միավոր հաղթելու համար՝',
                    style: typography.regular24.copyWith(color: colors.white),
                  ),
                  height20,
                  AppButton(
                    label: '$pointsToWin միավոր',
                    color: colors.white20,
                    animateOnPress: false,
                    icon: IconButton(
                      onPressed: () {
                        settingsBloc.add(
                          ChangePointsToWin(pointsToWin: pointsToWin - 5),
                        );
                      },
                      icon: Icon(Icons.remove, color: colors.white),
                    ),
                    suffix: IconButton(
                      onPressed: () {
                        settingsBloc.add(
                          ChangePointsToWin(pointsToWin: pointsToWin + 5),
                        );
                      },
                      icon: Icon(Icons.add, color: colors.white),
                    ),
                  ),
                  if (gameMode == .singleWord) ...[
                    height40,
                    AppButton(
                      label: 'Կարելի է բաց թողել',
                      animateOnPress: false,
                      onPressed: () {
                        settingsBloc.add(
                          ChangeAllowSkipping(
                            allowSkipping: !gameSettings.allowSkipping,
                          ),
                        );
                      },
                      color: colors.white20,
                      suffix: AppSwitch(
                        value: gameSettings.allowSkipping,
                        onChanged: (value) {
                          settingsBloc.add(
                            ChangeAllowSkipping(allowSkipping: value),
                          );
                        },
                      ),
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
