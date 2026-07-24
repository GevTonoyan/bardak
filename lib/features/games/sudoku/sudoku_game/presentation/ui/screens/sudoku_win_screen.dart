import 'dart:async';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:bardak/core/app_ui/theme/text_styles/app_text_styles.dart';
import 'package:bardak/core/app_ui/widgets/app_button/app_button.dart';
import 'package:bardak/core/app_ui/widgets/app_spacings.dart';
import 'package:bardak/core/app_ui/widgets/screen_background.dart';
import 'package:bardak/core/extensions/context_extension.dart';
import 'package:bardak/core/generated/assets/assets.gen.dart';
import 'package:bardak/core/localizations/l10n/app_localizations.dart';
import 'package:bardak/features/games/sudoku/sudoku_game/domain/entities/sudoku_win_record_entity.dart';
import 'package:bardak/features/games/sudoku/sudoku_game/presentation/ui/screens/sudoku_screen.dart';
import 'package:bardak/features/games/sudoku/sudoku_game/presentation/ui/sudoku_formatters.dart';
import 'package:bardak/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// Navigation payload for [SudokuWinScreen].
class SudokuWinArgs {
  const SudokuWinArgs({
    required this.solveSeconds,
    required this.score,
    required this.record,
  });

  /// Time the puzzle took; null when the timer is disabled in settings.
  final int? solveSeconds;

  /// Points earned in the solved game.
  final int score;

  /// Updated lifetime stats and new-record flags; null if recording
  /// was unavailable.
  final SudokuWinRecordEntity? record;
}

/// Celebration screen shown when the Sudoku puzzle is solved.
class SudokuWinScreen extends StatefulWidget {
  const SudokuWinScreen({required this.args, super.key});

  static const routePath = 'sudokuWin';

  final SudokuWinArgs args;

  @override
  State<SudokuWinScreen> createState() => _SudokuWinScreenState();
}

class _SudokuWinScreenState extends State<SudokuWinScreen> {
  late final ConfettiController _controller = ConfettiController(
    duration: const Duration(seconds: 6),
  );
  late final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.play();

      final soundEnabled = context
          .read<SettingsBloc>()
          .state
          .appSettings
          .soundEnabled;
      if (soundEnabled) {
        unawaited(_audioPlayer.play(AssetSource(Assets.sounds.check)));
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    unawaited(_audioPlayer.dispose());
    super.dispose();
  }

  /// "Best score: N · Best time: m:ss" (time part only when recorded).
  String _bestStatsLine(AppLocalizations l10n, SudokuWinRecordEntity record) {
    final bestScore = '${l10n.sudoku_best_score}: ${record.stats.bestScore}';
    final bestTime = record.stats.bestTimeSeconds;
    if (bestTime == null) return bestScore;

    return '$bestScore  ·  '
        '${l10n.sudoku_best_time}: ${formatSudokuTime(bestTime)}';
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final l10n = context.l10n;
    final solveSeconds = widget.args.solveSeconds;
    final record = widget.args.record;

    return Material(
      child: Stack(
        children: [
          GradientBackground(child: Container()),
          Align(
            alignment: .topCenter,
            child: ConfettiWidget(
              confettiController: _controller,
              blastDirection: pi / 2,
              blastDirectionality: BlastDirectionality.explosive,
              maxBlastForce: 15,
              emissionFrequency: 0.05,
              numberOfParticles: 75,
            ),
          ),
          Column(
            mainAxisAlignment: .spaceBetween,
            children: [
              const SafeArea(bottom: false, child: SizedBox.shrink()),
              Padding(
                padding: const .symmetric(horizontal: 40),
                child: Column(
                  spacing: 16,
                  children: [
                    Text(
                      l10n.sudoku_solved,
                      textAlign: .center,
                      style: context.typography.regular28,
                    ),
                    Text(
                      '${l10n.sudoku_score}: ${widget.args.score}',
                      textAlign: .center,
                      style: context.typography.regular24.withNumericFont,
                    ),
                    if (solveSeconds != null)
                      Text(
                        '${l10n.sudoku_your_time} '
                        '${formatSudokuTime(solveSeconds)}',
                        textAlign: .center,
                        style: context.typography.regular24.withNumericFont
                            .copyWith(color: colors.white50),
                      ),
                    if (record != null &&
                        (record.isNewBestScore || record.isNewBestTime))
                      Text(
                        l10n.sudoku_new_record,
                        textAlign: .center,
                        style: context.typography.regular24.copyWith(
                          color: colors.orange,
                        ),
                      ),
                    if (record != null)
                      Text(
                        _bestStatsLine(l10n, record),
                        textAlign: .center,
                        style: context.typography.regular18.withNumericFont
                            .copyWith(color: colors.white50),
                      ),
                  ],
                ),
              ),
              SizedBox(
                height: 280,
                child: ShadowBackground(
                  child: Padding(
                    padding: const .all(20),
                    child: Column(
                      children: [
                        AppButton(
                          label: l10n.play_again,
                          color: colors.green,
                          onPressed: () => context.pushReplacementNamed(
                            SudokuScreen.routePath,
                          ),
                        ),
                        height20,
                        AppButton(
                          label: l10n.proceed,
                          color: colors.white20,
                          onPressed: () => context.pop(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
