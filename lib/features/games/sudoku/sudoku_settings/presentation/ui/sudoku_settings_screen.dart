import 'dart:async';

import 'package:bardak/core/app_ui/widgets/app_button/app_button.dart';
import 'package:bardak/core/app_ui/widgets/app_button/app_switch_button.dart';
import 'package:bardak/core/app_ui/widgets/app_spacings.dart';
import 'package:bardak/core/app_ui/widgets/bottom_sheet.dart';
import 'package:bardak/core/extensions/context_extension.dart';
import 'package:bardak/features/games/sudoku/sudoku_game/presentation/ui/sudoku_screen.dart';
import 'package:bardak/features/games/sudoku/sudoku_settings/domain/entities/sudoku_difficulty.dart';
import 'package:bardak/features/games/sudoku/sudoku_settings/presentation/bloc/sudoku_settings_bloc.dart';
import 'package:bardak/features/games/sudoku/sudoku_settings/presentation/bloc/sudoku_settings_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SudokuSettingsScreen extends Page<void> {
  const SudokuSettingsScreen({super.key});

  static const routePath = 'sudokuSettings';

  @override
  Route<void> createRoute(BuildContext context) {
    return buildAppBottomSheet<void>(
      context: context,
      settings: this,
      child: FullBottomSheet(
        titleBuilder: (context) => context.l10n.settings,
        child: const _SudokuSettingsBody(),
      ),
    );
  }
}

class _SudokuSettingsBody extends StatelessWidget {
  const _SudokuSettingsBody();

  String _difficultyLabel(BuildContext context, SudokuDifficulty difficulty) {
    final l10n = context.l10n;
    return switch (difficulty) {
      SudokuDifficulty.easy => l10n.sudoku_difficulty_easy,
      SudokuDifficulty.medium => l10n.sudoku_difficulty_medium,
      SudokuDifficulty.hard => l10n.sudoku_difficulty_hard,
    };
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final typography = context.typography;
    final l10n = context.l10n;

    final settingsBloc = context.watch<SudokuSettingsBloc>();
    final settings = settingsBloc.state.sudokuSettings;

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: .start,
              children: [
                height30,
                Text(
                  l10n.sudoku_difficulty,
                  style: typography.regular24,
                ),
                height20,
                Row(
                  spacing: 10,
                  children: [
                    for (final difficulty in SudokuDifficulty.values)
                      Expanded(
                        child: AppButton(
                          label: _difficultyLabel(context, difficulty),
                          color: colors.white20,
                          size: .medium,
                          isPressed: settings.difficulty == difficulty,
                          pressedColor: colors.white,
                          pressedTextColor: colors.secondary,
                          onPressed: () => settingsBloc.add(
                            ChangeDifficulty(difficulty),
                          ),
                        ),
                      ),
                  ],
                ),
                height40,
                AppSwitchButton(
                  label: l10n.sudoku_show_timer,
                  value: settings.showTimer,
                  onChanged: (value) => settingsBloc.add(
                    ChangeShowTimer(showTimer: value),
                  ),
                  onPressed: () => settingsBloc.add(
                    ChangeShowTimer(showTimer: !settings.showTimer),
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
          onPressed: () => unawaited(context.pushNamed(SudokuScreen.routePath)),
        ),
      ],
    );
  }
}
