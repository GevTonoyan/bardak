import 'package:bardak/features/games/sudoku/sudoku_settings/domain/entities/sudoku_difficulty.dart';
import 'package:equatable/equatable.dart';

/// Settings for the Sudoku game (difficulty).
///
/// Persisted, so choices are remembered across sessions.
class SudokuSettingsEntity extends Equatable {
  const SudokuSettingsEntity({
    this.difficulty = SudokuDifficulty.medium,
  });

  final SudokuDifficulty difficulty;

  SudokuSettingsEntity copyWith({
    SudokuDifficulty? difficulty,
  }) {
    return SudokuSettingsEntity(
      difficulty: difficulty ?? this.difficulty,
    );
  }

  @override
  List<Object?> get props => [difficulty];
}
