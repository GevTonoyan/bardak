import 'package:bardak/features/games/sudoku/sudoku_settings/domain/entities/sudoku_difficulty.dart';
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

/// Re-checks whether an unfinished game can be resumed (dispatched when
/// the settings sheet opens and when the game screen is left).
class RefreshSavedGame extends SudokuSettingsEvent {
  const RefreshSavedGame();
}
