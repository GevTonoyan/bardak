import 'dart:async';
import 'dart:math';

import 'package:bardak/core/app_ui/theme/text_styles/app_text_styles.dart';
import 'package:bardak/core/app_ui/widgets/app_icon_button.dart';
import 'package:bardak/core/app_ui/widgets/app_notification.dart';
import 'package:bardak/core/app_ui/widgets/app_spacings.dart';
import 'package:bardak/core/app_ui/widgets/round_timer.dart';
import 'package:bardak/core/app_ui/widgets/screen_background.dart';
import 'package:bardak/core/app_ui/widgets/show_confirm_sheet.dart';
import 'package:bardak/core/extensions/context_extension.dart';
import 'package:bardak/features/games/sudoku/sudoku_game/domain/entities/sudoku_board_entity.dart';
import 'package:bardak/features/games/sudoku/sudoku_game/presentation/bloc/sudoku_bloc.dart';
import 'package:bardak/features/games/sudoku/sudoku_game/presentation/bloc/sudoku_event.dart';
import 'package:bardak/features/games/sudoku/sudoku_game/presentation/bloc/sudoku_state.dart';
import 'package:bardak/features/games/sudoku/sudoku_game/presentation/ui/sudoku_game_over_screen.dart';
import 'package:bardak/features/games/sudoku/sudoku_game/presentation/ui/sudoku_win_screen.dart';
import 'package:bardak/features/games/sudoku/sudoku_settings/domain/entities/sudoku_difficulty.dart';
import 'package:bardak/features/games/sudoku/sudoku_settings/presentation/bloc/sudoku_settings_bloc.dart';
import 'package:bardak/features/games/sudoku/sudoku_settings/presentation/bloc/sudoku_settings_event.dart';
import 'package:bardak/features/home/presentation/ui/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

/// A single Sudoku game: the grid on top, a digit pad below.
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
    // The settings sheet below shows a Continue button when a game can
    // be resumed; leaving this screen is when that answer changes.
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
          // silent when mistakes are hidden, leaving the player stuck.
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
                      child: _MistakesIndicator(),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: .fromLTRB(20, 12, 20, 0),
                child: _GameInfoBar(),
              ),
              // The board fills all the space between the header and the
              // pad, sized to the largest square that fits (bounded by width
              // on tall screens), so it is as large as possible.
              const Expanded(
                child: Padding(
                  padding: .symmetric(horizontal: 6, vertical: 8),
                  child: Center(child: _SudokuGrid()),
                ),
              ),
              const Padding(
                padding: .fromLTRB(20, 0, 20, 20),
                child: _DigitPad(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Formats elapsed seconds as m:ss for the in-game and win screens.
String formatSudokuTime(int totalSeconds) {
  final minutes = totalSeconds ~/ 60;
  final seconds = totalSeconds % 60;
  return '$minutes:${seconds.toString().padLeft(2, '0')}';
}

/// The localized name of a difficulty level.
String sudokuDifficultyLabel(
  BuildContext context,
  SudokuDifficulty difficulty,
) {
  final l10n = context.l10n;
  return switch (difficulty) {
    SudokuDifficulty.easy => l10n.sudoku_difficulty_easy,
    SudokuDifficulty.medium => l10n.sudoku_difficulty_medium,
    SudokuDifficulty.hard => l10n.sudoku_difficulty_hard,
    SudokuDifficulty.expert => l10n.sudoku_difficulty_expert,
    SudokuDifficulty.extreme => l10n.sudoku_difficulty_extreme,
  };
}

/// Difficulty on the left, live score on the right.
class _GameInfoBar extends StatelessWidget {
  const _GameInfoBar();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return BlocSelector<
      SudokuBloc,
      SudokuState,
      ({SudokuDifficulty difficulty, int score})
    >(
      selector: (state) => (difficulty: state.difficulty, score: state.score),
      builder: (context, data) {
        return Row(
          mainAxisAlignment: .spaceBetween,
          children: [
            Text(
              sudokuDifficultyLabel(context, data.difficulty),
              style: context.typography.regular18.copyWith(
                color: colors.white50,
              ),
            ),
            Row(
              spacing: 6,
              children: [
                Icon(Icons.star_rounded, size: 20, color: colors.orange),
                Text(
                  '${data.score}',
                  style: context.typography.regular18.withNumericFont,
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

/// The player's remaining lives as hearts in a glass pill. Losing one
/// shakes the pill and breaks the heart so the mistake registers at a
/// glance.
class _MistakesIndicator extends StatelessWidget {
  const _MistakesIndicator();

  @override
  Widget build(BuildContext context) {
    return BlocSelector<SudokuBloc, SudokuState, int>(
      selector: (state) => state.mistakes,
      builder: (context, mistakes) {
        final colors = context.colors;
        final lives = SudokuState.maxMistakes - mistakes;

        // Keyed by the mistake count: each lost life restarts the shake,
        // which decays as the tween runs 1 -> 0.
        return TweenAnimationBuilder<double>(
          key: ValueKey('sudoku_lives_$mistakes'),
          tween: Tween(begin: mistakes == 0 ? 0.0 : 1.0, end: 0),
          duration: const Duration(milliseconds: 700),
          builder: (context, t, child) => Transform.translate(
            offset: Offset(sin(t * pi * 5) * 6 * t, 0),
            child: Transform.scale(scale: 1 + t * 0.15, child: child),
          ),
          child: Container(
            padding: const .symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: colors.white10,
              borderRadius: .circular(20),
              border: Border.all(color: colors.white30, width: 0.5),
            ),
            child: Row(
              mainAxisSize: .min,
              spacing: 4,
              children: [
                for (var i = 0; i < SudokuState.maxMistakes; i++)
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 350),
                    switchInCurve: Curves.easeOutBack,
                    transitionBuilder: (child, animation) =>
                        ScaleTransition(scale: animation, child: child),
                    child: i < lives
                        ? Icon(
                            Icons.favorite_rounded,
                            key: ValueKey('sudoku_heart_full_$i'),
                            size: 18,
                            color: colors.red,
                          )
                        : Icon(
                            Icons.heart_broken_rounded,
                            key: ValueKey('sudoku_heart_broken_$i'),
                            size: 18,
                            color: colors.white30,
                          ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SudokuGrid extends StatelessWidget {
  const _SudokuGrid();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final dpr = MediaQuery.devicePixelRatioOf(context);

    return AspectRatio(
      aspectRatio: 1,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.secondary,
          borderRadius: .circular(12),
          border: Border.all(color: colors.white, width: 2),
        ),
        // Highlight fills are straight rectangles; without clipping they
        // paint over the rounded corners.
        child: ClipRRect(
          borderRadius: .circular(10),
          child: BlocBuilder<SudokuBloc, SudokuState>(
            builder: (context, state) {
              if (state.isGenerating) {
                return Center(
                  child: CircularProgressIndicator(color: colors.white),
                );
              }

              // Cells paint only their fills; the grid lines are drawn once
              // on top by a single pixel-snapped painter so every divider is
              // crisp and uniform regardless of the board's fractional size.
              return Stack(
                children: [
                  Positioned.fill(
                    child: Column(
                      children: [
                        for (var row = 0; row < SudokuBoardEntity.size; row++)
                          Expanded(
                            child: Row(
                              // Stretch cells to the full row height so empty
                              // cells (whose child is zero-sized) still fill
                              // the square and remain tappable.
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                for (
                                  var col = 0;
                                  col < SudokuBoardEntity.size;
                                  col++
                                )
                                  Expanded(
                                    child: _SudokuCell(
                                      key: ValueKey(
                                        row * SudokuBoardEntity.size + col,
                                      ),
                                      index: row * SudokuBoardEntity.size + col,
                                      state: state,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                  Positioned.fill(
                    child: IgnorePointer(
                      child: CustomPaint(
                        painter: _GridLinesPainter(
                          thin: colors.white30,
                          thick: colors.white,
                          devicePixelRatio: dpr,
                        ),
                      ),
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
}

/// Paints the 8 internal vertical and horizontal dividers of the 9x9 grid.
/// Line centres are snapped to whole device pixels so hairlines never drop
/// out or blur — the failure mode of per-cell fractional borders.
class _GridLinesPainter extends CustomPainter {
  const _GridLinesPainter({
    required this.thin,
    required this.thick,
    required this.devicePixelRatio,
  });

  final Color thin;
  final Color thick;
  final double devicePixelRatio;

  @override
  void paint(Canvas canvas, Size size) {
    // Work in whole device pixels so every line lands on the physical grid;
    // drawn as filled rects (not strokes) which stay crisp under Impeller.
    final dpr = devicePixelRatio;
    final thinPx = dpr.roundToDouble(); // ~1 logical px, whole physical px
    final thickPx = thinPx * 2;

    for (var i = 1; i < SudokuBoardEntity.size; i++) {
      final isBoxEdge = i % SudokuBoardEntity.boxSize == 0;
      final paint = Paint()..color = isBoxEdge ? thick : thin;
      final widthPx = isBoxEdge ? thickPx : thinPx;

      final cx = (size.width * i / SudokuBoardEntity.size * dpr)
          .roundToDouble();
      canvas.drawRect(
        Rect.fromLTRB(
          (cx - widthPx / 2) / dpr,
          0,
          (cx + widthPx / 2) / dpr,
          size.height,
        ),
        paint,
      );

      final cy = (size.height * i / SudokuBoardEntity.size * dpr)
          .roundToDouble();
      canvas.drawRect(
        Rect.fromLTRB(
          0,
          (cy - widthPx / 2) / dpr,
          size.width,
          (cy + widthPx / 2) / dpr,
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_GridLinesPainter oldDelegate) =>
      oldDelegate.thin != thin ||
      oldDelegate.thick != thick ||
      oldDelegate.devicePixelRatio != devicePixelRatio;
}

class _SudokuCell extends StatelessWidget {
  const _SudokuCell({required this.index, required this.state, super.key});

  final int index;
  final SudokuState state;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    final board = state.board;
    final row = index ~/ SudokuBoardEntity.size;
    final col = index % SudokuBoardEntity.size;
    final value = board.values[index];

    final isSelected = state.selectedIndex == index;
    final selected = state.selectedIndex;

    // The selected cell's row, column AND 3x3 box are the regions where its
    // digit may not repeat, so all three get the soft highlight.
    var sharesRegion = false;
    var sameDigit = false;
    if (selected != null) {
      final selectedRow = selected ~/ SudokuBoardEntity.size;
      final selectedCol = selected % SudokuBoardEntity.size;
      final sharesBox =
          row ~/ SudokuBoardEntity.boxSize ==
              selectedRow ~/ SudokuBoardEntity.boxSize &&
          col ~/ SudokuBoardEntity.boxSize ==
              selectedCol ~/ SudokuBoardEntity.boxSize;
      sharesRegion = row == selectedRow || col == selectedCol || sharesBox;

      final selectedValue = board.values[selected];
      sameDigit =
          !isSelected &&
          selectedValue != SudokuBoardEntity.empty &&
          value == selectedValue;
    }

    final content = value == SudokuBoardEntity.empty
        ? _CellNotes(notes: board.notes[index])
        : Center(
            child: Text(
              '$value',
              style: context.typography.regular24.withNumericFont.copyWith(
                color: state.isMistake(index)
                    ? colors.red
                    : board.given[index]
                    ? colors.white
                    : colors.orange,
              ),
            ),
          );

    return GestureDetector(
      behavior: .opaque,
      onTap: () => context.read<SudokuBloc>().add(SelectCell(index)),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: isSelected
              ? colors.white30
              : sameDigit
              ? colors.white20
              : sharesRegion
              ? colors.white10
              : Colors.transparent,
        ),
        child: state.completedCells.contains(index)
            ? Stack(
                fit: .expand,
                children: [
                  content,
                  _CompletionRipple(
                    tick: state.completionTick,
                    origin: state.completionOrigin,
                    index: index,
                  ),
                ],
              )
            : content,
      ),
    );
  }
}

/// A green wave played over the cells of a correctly completed row,
/// column or box, rippling outwards from the cell that completed it.
class _CompletionRipple extends StatelessWidget {
  const _CompletionRipple({
    required this.tick,
    required this.origin,
    required this.index,
  });

  /// Restarts the animation whenever a new unit completes.
  final int tick;

  /// The placed cell the wave spreads from.
  final int origin;

  /// The cell this ripple instance is drawn in.
  final int index;

  @override
  Widget build(BuildContext context) {
    // Distance to the origin decides when this cell lights up, so the
    // glow travels along the completed unit instead of blinking at once.
    final rowDistance =
        (index ~/ SudokuBoardEntity.size - origin ~/ SudokuBoardEntity.size)
            .abs();
    final colDistance =
        (index % SudokuBoardEntity.size - origin % SudokuBoardEntity.size)
            .abs();
    final distance = max(rowDistance, colDistance);

    // Each step of distance delays the wave; the cell then brightens and
    // fades within its own window of the shared timeline.
    final delay = distance * 0.09;
    const window = 0.4;

    return IgnorePointer(
      child: TweenAnimationBuilder<double>(
        key: ValueKey('sudoku_ripple_$tick'),
        tween: Tween(begin: 0, end: 1),
        duration: const Duration(milliseconds: 1400),
        builder: (context, t, _) {
          final phase = ((t - delay) / window).clamp(0.0, 1.0);
          final intensity = sin(phase * pi);

          return ColoredBox(
            color: context.colors.green.withValues(alpha: intensity * 0.55),
          );
        },
      ),
    );
  }
}

/// The nine candidate slots of an empty cell: each digit 1..9 sits in its
/// own fixed mini-cell, shown only when pencilled in.
class _CellNotes extends StatelessWidget {
  const _CellNotes({required this.notes});

  final Set<int> notes;

  @override
  Widget build(BuildContext context) {
    if (notes.isEmpty) return const SizedBox.shrink();

    final style = context.typography.labelSmall.withNumericFont.copyWith(
      color: context.colors.white50,
      fontSize: 10,
      height: 1,
    );

    return Padding(
      padding: const EdgeInsets.all(1),
      child: Column(
        children: [
          for (var noteRow = 0; noteRow < SudokuBoardEntity.boxSize; noteRow++)
            Expanded(
              child: Row(
                children: [
                  for (
                    var noteCol = 0;
                    noteCol < SudokuBoardEntity.boxSize;
                    noteCol++
                  )
                    Expanded(
                      child: Center(
                        child: Text(
                          notes.contains(noteRow * 3 + noteCol + 1)
                              ? '${noteRow * 3 + noteCol + 1}'
                              : '',
                          style: style,
                        ),
                      ),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _DigitPad extends StatelessWidget {
  const _DigitPad();

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<SudokuBloc>();

    return Column(
      children: [
        Row(
          spacing: 6,
          children: [
            for (var digit = 1; digit <= SudokuBoardEntity.size; digit++)
              Expanded(child: _DigitButton(digit: digit)),
          ],
        ),
        height20,
        Row(
          spacing: 10,
          children: [
            Expanded(
              child: BlocSelector<SudokuBloc, SudokuState, bool>(
                selector: (state) => state.canUndo,
                builder: (context, canUndo) {
                  return _PadButton(
                    key: const ValueKey('sudoku_undo'),
                    onTap: canUndo ? () => bloc.add(const Undo()) : null,
                    child: const Icon(Icons.undo, size: 22),
                  );
                },
              ),
            ),
            Expanded(
              child: _PadButton(
                onTap: () => bloc.add(const EraseCell()),
                child: const Icon(Icons.backspace_outlined, size: 22),
              ),
            ),
            Expanded(
              child: BlocSelector<SudokuBloc, SudokuState, bool>(
                selector: (state) => state.notesMode,
                builder: (context, notesMode) {
                  return _PadButton(
                    isActive: notesMode,
                    onTap: () => bloc.add(const ToggleNotesMode()),
                    child: const Icon(Icons.edit_outlined, size: 22),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// A digit key showing how many of that digit are still to be placed;
/// dimmed and disabled once all nine are on the board.
class _DigitButton extends StatelessWidget {
  const _DigitButton({required this.digit});

  final int digit;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<SudokuBloc>();

    return BlocSelector<SudokuBloc, SudokuState, int>(
      selector: (state) => state.remainingOf(digit),
      builder: (context, remaining) {
        return _PadButton(
          key: ValueKey('sudoku_digit_$digit'),
          onTap: remaining > 0 ? () => bloc.add(EnterDigit(digit)) : null,
          child: Column(
            mainAxisSize: .min,
            children: [
              Text(
                '$digit',
                style: context.typography.regular24.withNumericFont,
              ),
              Text(
                '$remaining',
                style: context.typography.bodySmall.withNumericFont.copyWith(
                  color: context.colors.white50,
                  height: 1,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _PadButton extends StatelessWidget {
  const _PadButton({
    required this.onTap,
    required this.child,
    this.isActive = false,
    super.key,
  });

  /// Null renders the button in a disabled (dimmed, non-tappable) state.
  final VoidCallback? onTap;
  final Widget child;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isDisabled = onTap == null;

    return Opacity(
      opacity: isDisabled ? 0.4 : 1,
      child: Material(
        color: isActive ? colors.white : colors.white20,
        borderRadius: .circular(10),
        child: InkWell(
          onTap: onTap,
          borderRadius: .circular(10),
          child: IconTheme.merge(
            data: IconThemeData(
              color: isActive ? colors.secondary : colors.white,
            ),
            child: SizedBox(height: 56, child: Center(child: child)),
          ),
        ),
      ),
    );
  }
}
