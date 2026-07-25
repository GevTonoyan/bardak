import 'package:bardak/features/games/sudoku/sudoku_settings/domain/entities/sudoku_difficulty.dart';
import 'package:equatable/equatable.dart';

/// Settings for the Sudoku game (difficulty, timer).
///
/// Persisted, so choices are remembered across sessions.
class SudokuSettingsEntity extends Equatable {
  const SudokuSettingsEntity({
    this.difficulty = SudokuDifficulty.medium,
    this.showTimer = true,
  });

  final SudokuDifficulty difficulty;

  /// Whether the elapsed time is shown during the game and on the win screen.
  final bool showTimer;

  SudokuSettingsEntity copyWith({
    SudokuDifficulty? difficulty,
    bool? showTimer,
  }) {
    return SudokuSettingsEntity(
      difficulty: difficulty ?? this.difficulty,
      showTimer: showTimer ?? this.showTimer,
    );
  }

  @override
  List<Object?> get props => [difficulty, showTimer];
}
