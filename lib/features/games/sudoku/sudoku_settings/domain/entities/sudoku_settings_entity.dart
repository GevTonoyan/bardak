import 'package:bardak/features/games/sudoku/sudoku_settings/domain/entities/sudoku_board_size.dart';
import 'package:bardak/features/games/sudoku/sudoku_settings/domain/entities/sudoku_difficulty.dart';
import 'package:equatable/equatable.dart';

/// Settings for the Sudoku game (board size and difficulty).
///
/// Persisted, so choices are remembered across sessions.
class SudokuSettingsEntity extends Equatable {
  const SudokuSettingsEntity({
    this.boardSize = SudokuBoardSize.standard,
    this.difficulty = SudokuDifficulty.medium,
  });

  final SudokuBoardSize boardSize;
  final SudokuDifficulty difficulty;

  SudokuSettingsEntity copyWith({
    SudokuBoardSize? boardSize,
    SudokuDifficulty? difficulty,
  }) {
    return SudokuSettingsEntity(
      boardSize: boardSize ?? this.boardSize,
      difficulty: difficulty ?? this.difficulty,
    );
  }

  @override
  List<Object?> get props => [boardSize, difficulty];
}
