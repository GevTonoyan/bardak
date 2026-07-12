import 'dart:async';

import 'package:bardak/core/app_ui/widgets/app_button/app_button.dart';
import 'package:bardak/core/app_ui/widgets/app_button/app_stepper_button.dart';
import 'package:bardak/core/app_ui/widgets/app_icon_button.dart';
import 'package:bardak/core/app_ui/widgets/app_spacings.dart';
import 'package:bardak/core/app_ui/widgets/bottom_sheet.dart';
import 'package:bardak/core/extensions/context_extension.dart';
import 'package:bardak/features/games/spy/spy_packs/presentation/ui/spy_packs_screen.dart';
import 'package:bardak/features/games/spy/spy_rules/presentation/ui/spy_rules_screen.dart';
import 'package:bardak/features/games/spy/spy_settings/presentation/bloc/spy_settings_bloc.dart';
import 'package:bardak/features/games/spy/spy_settings/presentation/bloc/spy_settings_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SpySettingsScreen extends Page<void> {
  const SpySettingsScreen({super.key});

  static const routePath = 'spySettings';

  @override
  Route<void> createRoute(BuildContext context) {
    return buildAppBottomSheet<void>(
      context: context,
      settings: this,
      child: FullBottomSheet(
        titleBuilder: (context) => context.l10n.settings,
        trailing: AppIconButton.info(
          onTap: () => unawaited(context.pushNamed(SpyRulesScreen.routePath)),
        ),
        child: const _SpySettingsBody(),
      ),
    );
  }
}

class _SpySettingsBody extends StatelessWidget {
  const _SpySettingsBody();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;
    final l10n = context.l10n;

    final spySettingsBloc = context.watch<SpySettingsBloc>();
    final spySettings = spySettingsBloc.state.spySettings;

    final playerCount = spySettings.playerCount;
    final spyCount = spySettings.spyCount;
    final roundDuration = spySettings.roundDuration;

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                height30,
                Text(
                  l10n.settings_players,
                  style: typography.regular24,
                ),
                height20,
                AppStepperButton(
                  label: '$playerCount',
                  onDecrement: spySettings.canDecreasePlayerCount
                      ? () => spySettingsBloc.add(
                          ChangePlayerCount(playerCount - 1),
                        )
                      : null,
                  onIncrement: spySettings.canIncreasePlayerCount
                      ? () => spySettingsBloc.add(
                          ChangePlayerCount(playerCount + 1),
                        )
                      : null,
                ),
                height40,
                Text(
                  l10n.settings_spies,
                  style: typography.regular24,
                ),
                height20,
                AppStepperButton(
                  label: '$spyCount',
                  onDecrement: spySettings.canDecreaseSpyCount
                      ? () => spySettingsBloc.add(
                          ChangeSpyCount(spyCount - 1),
                        )
                      : null,
                  onIncrement: spySettings.canIncreaseSpyCount
                      ? () => spySettingsBloc.add(
                          ChangeSpyCount(spyCount + 1),
                        )
                      : null,
                ),
                height40,
                Text(
                  l10n.settings_round_time,
                  style: typography.regular24,
                ),
                height20,
                AppStepperButton(
                  label: l10n.unit_min(spySettings.roundDurationInMinutes),
                  onDecrement: spySettings.canDecreaseRoundDuration
                      ? () => spySettingsBloc.add(
                          ChangeRoundDuration(roundDuration - 60),
                        )
                      : null,
                  onIncrement: spySettings.canIncreaseRoundDuration
                      ? () => spySettingsBloc.add(
                          ChangeRoundDuration(roundDuration + 60),
                        )
                      : null,
                ),
              ],
            ),
          ),
        ),
        height20,
        AppButton(
          label: l10n.proceed,
          color: colors.green,
          onPressed: () =>
              unawaited(context.pushNamed(SpyPacksScreen.routePath)),
        ),
      ],
    );
  }
}
