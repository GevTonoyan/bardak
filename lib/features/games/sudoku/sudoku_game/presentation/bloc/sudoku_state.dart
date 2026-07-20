import 'package:bardak/features/games/sudoku/sudoku_game/domain/entities/sudoku_board_entity.dart';
import 'package:bardak/features/games/sudoku/sudoku_settings/domain/entities/sudoku_mistakes_mode.dart';
import 'package:equatable/equatable.dart';

class SudokuState extends Equatable {
  const SudokuState({
    required this.board,
    required this.mistakesMode,
    required this.showTimer,
    this.selectedIndex,
  });

  final SudokuBoardEntity board;

  /// How mistakes are flagged while playing.
  final SudokuMistakesMode mistakesMode;

  /// Whether the elapsed time is shown.
  final bool showTimer;

  /// Cell currently targeted by the digit pad; null before the first tap.
  final int? selectedIndex;

  bool get isSolved => board.isSolved;

  /// Full board that is not a solution — the player is stuck without
  /// knowing why unless we tell them something is wrong.
  bool get isFullButWrong => board.isFull && !board.isSolved;

  /// Whether the cell at [index] should be flagged as a mistake, honouring
  /// the configured [mistakesMode].
  bool isMistake(int index) => switch (mistakesMode) {
    SudokuMistakesMode.off => false,
    SudokuMistakesMode.conflicts =>
      !board.given[index] && board.hasConflict(index),
    SudokuMistakesMode.errors => board.isWrong(index),
  };

  SudokuState copyWith({SudokuBoardEntity? board, int? selectedIndex}) {
    return SudokuState(
      board: board ?? this.board,
      mistakesMode: mistakesMode,
      showTimer: showTimer,
      selectedIndex: selectedIndex ?? this.selectedIndex,
    );
  }

  @override
  List<Object?> get props => [board, mistakesMode, showTimer, selectedIndex];
}
