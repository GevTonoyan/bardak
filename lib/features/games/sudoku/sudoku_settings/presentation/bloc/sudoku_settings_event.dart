import 'package:bardak/features/games/sudoku/sudoku_settings/domain/entities/sudoku_difficulty.dart';
import 'package:bardak/features/games/sudoku/sudoku_settings/domain/entities/sudoku_mistakes_mode.dart';
import 'package:equatable/equatable.dart';

sealed class SudokuSettingsEvent extends Equatable {
  const SudokuSettingsEvent();

  @override
  List<Object?> get props => [];
}

/// Changes and persists the puzzle difficulty.
class ChangeDifficulty extends SudokuSettingsEvent {
  const ChangeDifficulty(this.difficulty);

  final SudokuDifficulty difficulty;

  @override
  List<Object?> get props => [difficulty];
}

/// Changes and persists how mistakes are flagged.
class ChangeMistakesMode extends SudokuSettingsEvent {
  const ChangeMistakesMode(this.mistakesMode);

  final SudokuMistakesMode mistakesMode;

  @override
  List<Object?> get props => [mistakesMode];
}

/// Toggles and persists the timer visibility.
class ChangeShowTimer extends SudokuSettingsEvent {
  const ChangeShowTimer({required this.showTimer});

  final bool showTimer;

  @override
  List<Object?> get props => [showTimer];
}
