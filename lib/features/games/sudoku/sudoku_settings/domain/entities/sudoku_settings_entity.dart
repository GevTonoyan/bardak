import 'package:bardak/features/games/sudoku/sudoku_settings/domain/entities/sudoku_difficulty.dart';
import 'package:bardak/features/games/sudoku/sudoku_settings/domain/entities/sudoku_mistakes_mode.dart';
import 'package:equatable/equatable.dart';

/// Settings for the Sudoku game (difficulty, mistake flagging, timer).
///
/// Persisted, so choices are remembered across sessions.
class SudokuSettingsEntity extends Equatable {
  const SudokuSettingsEntity({
    this.difficulty = SudokuDifficulty.medium,
    this.mistakesMode = SudokuMistakesMode.errors,
    this.showTimer = true,
  });

  final SudokuDifficulty difficulty;

  /// How mistakes are flagged while playing.
  final SudokuMistakesMode mistakesMode;

  /// Whether the elapsed time is shown during the game and on the win screen.
  final bool showTimer;

  SudokuSettingsEntity copyWith({
    SudokuDifficulty? difficulty,
    SudokuMistakesMode? mistakesMode,
    bool? showTimer,
  }) {
    return SudokuSettingsEntity(
      difficulty: difficulty ?? this.difficulty,
      mistakesMode: mistakesMode ?? this.mistakesMode,
      showTimer: showTimer ?? this.showTimer,
    );
  }

  @override
  List<Object?> get props => [difficulty, mistakesMode, showTimer];
}
