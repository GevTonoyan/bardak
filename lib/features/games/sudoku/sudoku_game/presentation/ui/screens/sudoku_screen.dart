import 'dart:async';

import 'package:bardak/core/app_ui/widgets/app_icon_button.dart';
import 'package:bardak/core/app_ui/widgets/app_notification.dart';
import 'package:bardak/core/app_ui/widgets/round_timer.dart';
import 'package:bardak/core/app_ui/widgets/screen_background.dart';
import 'package:bardak/core/app_ui/widgets/show_confirm_sheet.dart';
import 'package:bardak/core/extensions/context_extension.dart';
import 'package:bardak/features/games/sudoku/sudoku_game/presentation/bloc/sudoku_bloc.dart';
import 'package:bardak/features/games/sudoku/sudoku_game/presentation/bloc/sudoku_event.dart';
import 'package:bardak/features/games/sudoku/sudoku_game/presentation/bloc/sudoku_state.dart';
import 'package:bardak/features/games/sudoku/sudoku_game/presentation/ui/screens/sudoku_game_over_screen.dart';
import 'package:bardak/features/games/sudoku/sudoku_game/presentation/ui/screens/sudoku_win_screen.dart';
import 'package:bardak/features/games/sudoku/sudoku_game/presentation/ui/widgets/sudoku_board.dart';
import 'package:bardak/features/games/sudoku/sudoku_game/presentation/ui/widgets/sudoku_digit_pad.dart';
import 'package:bardak/features/games/sudoku/sudoku_game/presentation/ui/widgets/sudoku_game_info_bar.dart';
import 'package:bardak/features/games/sudoku/sudoku_game/presentation/ui/widgets/sudoku_mistakes_indicator.dart';
import 'package:bardak/features/games/sudoku/sudoku_settings/presentation/bloc/sudoku_settings_bloc.dart';
import 'package:bardak/features/games/sudoku/sudoku_settings/presentation/bloc/sudoku_settings_event.dart';
import 'package:bardak/features/home/presentation/ui/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// A single Sudoku game: the header, the board, and a digit pad below.
class SudokuScreen extends StatefulWidget {
  const SudokuScreen({super.key});

  static const routePath = 'sudoku';

  @override
  State<SudokuScreen> createState() => _SudokuScreenState();
}

class _SudokuScreenState extends State<SudokuScreen> {
  Timer? _timer;
  SudokuBloc? _sudokuBloc;
  SudokuSettingsBloc? _settingsBloc;

  @override
  void initState() {
    super.initState();
    _sudokuBloc = context.read<SudokuBloc>();
    _settingsBloc = context.read<SudokuSettingsBloc>();
    // The bloc owns the elapsed time (so it survives a resume); the
    // screen only supplies the heartbeat.
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _sudokuBloc?.add(const TimerTicked());
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    // The settings sheet shows a Continue button when a game can be
    // resumed; leaving this screen is when that answer changes.
    _settingsBloc?.add(const RefreshSavedGame());
    super.dispose();
  }

  /// Confirms before abandoning the puzzle — same semantics as the exit
  /// confirmation in the other games.
  Future<void> _confirmExitGame() async {
    final l10n = context.l10n;
    final colors = context.colors;

    await showConfirmSheet(
      context: context,
      title: l10n.exit_game_title,
      description: l10n.exit_game_description,
      confirmText: l10n.exit_game_confirm,
      cancelText: l10n.cancel,
      confirmColor: colors.red,
      cancelColor: colors.green,
      onConfirm: () => context.goNamed(HomeScreen.routePath),
    );
  }

  @override
  Widget build(BuildContext context) {
    final showTimer = context.read<SudokuBloc>().state.showTimer;

    return MultiBlocListener(
      listeners: [
        BlocListener<SudokuBloc, SudokuState>(
          // The win record lands right after the solved emission and only
          // once, so it is the navigation trigger.
          listenWhen: (previous, current) =>
              previous.winRecord == null && current.winRecord != null,
          listener: (context, state) {
            _timer?.cancel();
            context.pushReplacementNamed(
              SudokuWinScreen.routePath,
              extra: SudokuWinArgs(
                solveSeconds: state.showTimer ? state.elapsedSeconds : null,
                score: state.score,
                record: state.winRecord,
              ),
            );
          },
        ),
        BlocListener<SudokuBloc, SudokuState>(
          // Running out of mistakes ends the game.
          listenWhen: (previous, current) =>
              !previous.isGameOver && current.isGameOver,
          listener: (context, state) {
            _timer?.cancel();
            context.pushReplacementNamed(
              SudokuGameOverScreen.routePath,
              extra: state.score,
            );
          },
        ),
        BlocListener<SudokuBloc, SudokuState>(
          // Filling the last cell without winning would otherwise be
          // silent, leaving the player stuck.
          listenWhen: (previous, current) =>
              !previous.isFullButWrong && current.isFullButWrong,
          listener: (context, state) {
            unawaited(
              showAppNotification(
                context,
                message: context.l10n.sudoku_board_has_mistakes,
              ),
            );
          },
        ),
      ],
      child: GradientBackground(
        child: SafeArea(
          // A tap that lands outside the cells (and the buttons, which win
          // the gesture arena) clears the selection and its highlighting.
          child: GestureDetector(
            behavior: .translucent,
            onTap: () => context.read<SudokuBloc>().add(const Deselect()),
            child: Column(
              children: [
                Padding(
                  padding: const .only(left: 20, top: 20, right: 20),
                  child: Stack(
                    alignment: .center,
                    children: [
                      Align(
                        alignment: .centerLeft,
                        child: AppIconButton.close(
                          onTap: () => unawaited(_confirmExitGame()),
                        ),
                      ),
                      if (showTimer)
                        BlocSelector<SudokuBloc, SudokuState, int>(
                          selector: (state) => state.elapsedSeconds,
                          builder: (context, elapsed) {
                            // Counting up, so the countdown warning colors
                            // are pushed below zero and the pill stays green.
                            return RoundTimer(
                              seconds: elapsed,
                              formatAsMinutes: true,
                              orangeBelow: -1,
                              redBelow: -1,
                            );
                          },
                        ),
                      const Align(
                        alignment: .centerRight,
                        child: SudokuMistakesIndicator(),
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: .fromLTRB(20, 12, 20, 0),
                  child: SudokuGameInfoBar(),
                ),
                // The board fills the space between the header and the pad,
                // sized to the largest square that fits (bounded by width on
                // tall screens), so it is as large as possible.
                const Expanded(
                  child: Padding(
                    padding: .symmetric(horizontal: 6, vertical: 8),
                    child: Center(child: SudokuBoard()),
                  ),
                ),
                const Padding(
                  padding: .fromLTRB(20, 0, 20, 20),
                  child: SudokuDigitPad(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
