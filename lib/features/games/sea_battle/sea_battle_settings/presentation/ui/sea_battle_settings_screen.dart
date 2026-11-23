import 'dart:async';

import 'package:bardak/core/app_ui/widgets/app_button/app_button.dart';
import 'package:bardak/core/app_ui/widgets/app_icon_button.dart';
import 'package:bardak/core/app_ui/widgets/app_spacings.dart';
import 'package:bardak/core/app_ui/widgets/bottom_sheet.dart';
import 'package:bardak/core/extensions/context_extension.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_online/presentation/ui/sea_battle_waiting_room_screen.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_placement/presentation/ui/sea_battle_placement_screen.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_rules/presentation/ui/sea_battle_rules_screen.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_settings/domain/entities/sea_battle_bot_difficulty.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_settings/domain/entities/sea_battle_mode.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_settings/presentation/bloc/sea_battle_settings_bloc.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_settings/presentation/bloc/sea_battle_settings_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SeaBattleSettingsScreen extends Page<void> {
  const SeaBattleSettingsScreen({super.key});

  static const routePath = 'seaBattleSettings';

  @override
  Route<void> createRoute(BuildContext context) {
    return buildAppBottomSheet<void>(
      context: context,
      settings: this,
      child: FullBottomSheet(
        titleBuilder: (context) => context.l10n.settings,
        trailing: AppIconButton.info(
          onTap: () =>
              unawaited(context.pushNamed(SeaBattleRulesScreen.routePath)),
        ),
        child: const _SeaBattleSettingsBody(),
      ),
    );
  }
}

class _SeaBattleSettingsBody extends StatelessWidget {
  const _SeaBattleSettingsBody();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;
    final l10n = context.l10n;

    final settings = context
        .watch<SeaBattleSettingsBloc>()
        .state
        .seaBattleSettings;

    // Online play has no bot, so the section is greyed out and ignores
    // taps while it is selected.
    final difficultyEnabled = settings.mode.usesBotDifficulty;
    final isOnline = settings.mode == SeaBattleMode.online;

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                height30,
                Text(l10n.sea_battle_mode, style: typography.regular24),
                height20,
                Row(
                  spacing: 10,
                  children: [
                    for (final mode in SeaBattleMode.values)
                      Expanded(
                        child: _ModeButton(
                          mode: mode,
                          isSelected: settings.mode == mode,
                        ),
                      ),
                  ],
                ),
                height40,
                IgnorePointer(
                  ignoring: !difficultyEnabled,
                  child: Opacity(
                    opacity: difficultyEnabled ? 1 : 0.4,
                    child: Column(
                      crossAxisAlignment: .start,
                      children: [
                        Text(
                          l10n.sea_battle_bot_difficulty,
                          style: typography.regular24,
                        ),
                        height20,
                        Row(
                          spacing: 10,
                          children: [
                            for (final botDifficulty
                                in SeaBattleBotDifficulty.values)
                              Expanded(
                                child: _BotDifficultyButton(
                                  botDifficulty: botDifficulty,
                                  isSelected:
                                      settings.botDifficulty == botDifficulty,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        height20,
        AppButton(
          label: l10n.proceed,
          color: colors.green,
          // Solo goes straight to placement; online first finds an
          // opponent by inviting a friend.
          onPressed: () => unawaited(
            isOnline
                ? context.pushNamed(SeaBattleWaitingRoomScreen.routePath)
                : context.pushNamed(
                    SeaBattlePlacementScreen.routePath,
                    extra: SeaBattlePlacementArgs(mode: settings.mode),
                  ),
          ),
        ),
      ],
    );
  }
}

/// A mode option button; pressed-looking while [isSelected].
class _ModeButton extends StatelessWidget {
  const _ModeButton({required this.mode, required this.isSelected});

  final SeaBattleMode mode;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return AppButton(
      label: _label(context),
      color: colors.white20,
      size: .medium,
      isPressed: isSelected,
      pressedColor: colors.white,
      pressedTextColor: colors.secondary,
      onPressed: () =>
          context.read<SeaBattleSettingsBloc>().add(ChangeSeaBattleMode(mode)),
    );
  }

  String _label(BuildContext context) {
    final l10n = context.l10n;
    return switch (mode) {
      .solo => l10n.sea_battle_mode_solo,
      .online => l10n.sea_battle_mode_online,
    };
  }
}

/// A bot difficulty option button; pressed-looking while [isSelected].
class _BotDifficultyButton extends StatelessWidget {
  const _BotDifficultyButton({
    required this.botDifficulty,
    required this.isSelected,
  });

  final SeaBattleBotDifficulty botDifficulty;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return AppButton(
      label: _label(context),
      color: colors.white20,
      size: .medium,
      isPressed: isSelected,
      pressedColor: colors.white,
      pressedTextColor: colors.secondary,
      onPressed: () => context.read<SeaBattleSettingsBloc>().add(
        ChangeBotDifficulty(botDifficulty),
      ),
    );
  }

  String _label(BuildContext context) {
    final l10n = context.l10n;
    return switch (botDifficulty) {
      .easy => l10n.sea_battle_difficulty_easy,
      .medium => l10n.sea_battle_difficulty_medium,
      .hard => l10n.sea_battle_difficulty_hard,
    };
  }
}
