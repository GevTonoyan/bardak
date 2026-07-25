import 'package:bardak/core/extensions/context_extension.dart';
import 'package:bardak/features/games/sudoku/sudoku_settings/domain/entities/sudoku_difficulty.dart';
import 'package:flutter/widgets.dart';

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
