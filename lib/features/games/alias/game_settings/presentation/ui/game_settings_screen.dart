import 'dart:async';

import 'package:bardak/core/app_ui/widgets/app_button/app_button.dart';
import 'package:bardak/core/app_ui/widgets/app_button/app_stepper_button.dart';
import 'package:bardak/core/app_ui/widgets/app_button/app_switch_button.dart';
import 'package:bardak/core/app_ui/widgets/app_spacings.dart';
import 'package:bardak/core/app_ui/widgets/bottom_sheet.dart';
import 'package:bardak/core/extensions/context_extension.dart';
import 'package:bardak/features/games/alias/game_settings/domain/entities/game_mode.dart';
import 'package:bardak/features/games/alias/game_settings/presentation/bloc/game_settings_bloc.dart';
import 'package:bardak/features/games/alias/game_settings/presentation/bloc/game_settings_event.dart';
import 'package:bardak/features/games/alias/team_setup/presentation/ui/team_setup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class GameSettingsScreen extends Page<void> {
  const GameSettingsScreen({super.key});

  static const routePath = 'gameSettings';

  @override
  Route<void> createRoute(BuildContext context) {
    return buildAppBottomSheet<void>(
      context: context,
      settings: this,
      child: FullBottomSheet(
        titleBuilder: (context) => context.l10n.settings,
        child: const _GameSettingsBody(),
      ),
    );
  }
}

class _GameSettingsBody extends StatelessWidget {
  const _GameSettingsBody();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;
    final l10n = context.l10n;

    final gameSettingsBloc = context.watch<GameSettingsBloc>();
    final gameSettings = gameSettingsBloc.state.gameSettings;

    final gameMode = gameSettings.gameMode;
    final roundDuration = gameSettings.roundDuration;
    final pointsToWin = gameSettings.pointsToWin;

    final canDecreaseRoundDuration = gameSettings.canDecreaseRoundDuration;
    final canIncreaseRoundDuration = gameSettings.canIncreaseRoundDuration;
    final canDecrementPointsToWin = gameSettings.canDecreasePointsToWin;
    final canIncrementPointsToWin = gameSettings.canIncreasePointsToWin;

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
                          onPressed: () => gameSettingsBloc.add(
                            const ChangeGameMode(GameMode.card),
                          ),
                        ),
                      ),
                      Expanded(
                        child: AppButton(
                          label: l10n.oneWordModeShort,
                          color: colors.white20,
                          isPressed: gameMode == .singleWord,
                          pressedColor: colors.white,
                          pressedTextColor: colors.secondary,
                          onPressed: () => gameSettingsBloc.add(
                            const ChangeGameMode(.singleWord),
                          ),
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
                        ? () => gameSettingsBloc.add(
                            ChangeRoundDuration(roundDuration - 5),
                          )
                        : null,
                    onIncrement: canIncreaseRoundDuration
                        ? () => gameSettingsBloc.add(
                            ChangeRoundDuration(roundDuration + 5),
                          )
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
                        ? () => gameSettingsBloc.add(
                            ChangePointsToWin(pointsToWin - 5),
                          )
                        : null,
                    onIncrement: canIncrementPointsToWin
                        ? () => gameSettingsBloc.add(
                            ChangePointsToWin(pointsToWin + 5),
                          )
                        : null,
                  ),
                  if (gameMode == GameMode.singleWord) ...[
                    height40,
                    AppSwitchButton(
                      label: l10n.settings_allow_skipping,
                      value: gameSettings.allowSkipping,
                      onPressed: () => gameSettingsBloc.add(
                        ChangeAllowSkipping(
                          allowSkipping: !gameSettings.allowSkipping,
                        ),
                      ),
                      onChanged: (value) => gameSettingsBloc.add(
                        ChangeAllowSkipping(allowSkipping: value),
                      ),
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
            onPressed: () =>
                unawaited(context.pushNamed(TeamSetupScreen.routePath)),
          ),
        ],
      ),
    );
  }
}
