import 'package:bardak/features/games/sudoku/sudoku_game/domain/entities/sudoku_board_entity.dart';
import 'package:bardak/features/games/sudoku/sudoku_settings/domain/entities/sudoku_mistakes_mode.dart';
import 'package:equatable/equatable.dart';

class SudokuState extends Equatable {
  const SudokuState({
    required this.board,
    required this.mistakesMode,
    required this.showTimer,
    this.selectedIndex,
    this.notesMode = false,
    this.history = const [],
  });

  final SudokuBoardEntity board;

  /// How mistakes are flagged while playing.
  final SudokuMistakesMode mistakesMode;

  /// Whether the elapsed time is shown.
  final bool showTimer;

  /// Cell currently targeted by the digit pad; null before the first tap.
  final int? selectedIndex;

  /// When true, tapping a digit toggles a pencil-mark instead of placing it.
  final bool notesMode;

  /// Previous board states, oldest first; the last entry is what [Undo]
  /// restores. Only board-changing actions push onto it.
  final List<SudokuBoardEntity> history;

  bool get isSolved => board.isSolved;

  /// Whether there is a previous action to undo.
  bool get canUndo => history.isNotEmpty;

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

  SudokuState copyWith({
    SudokuBoardEntity? board,
    int? selectedIndex,
    bool? notesMode,
    List<SudokuBoardEntity>? history,
  }) {
    return SudokuState(
      board: board ?? this.board,
      mistakesMode: mistakesMode,
      showTimer: showTimer,
      selectedIndex: selectedIndex ?? this.selectedIndex,
      notesMode: notesMode ?? this.notesMode,
      history: history ?? this.history,
    );
  }

  @override
  List<Object?> get props => [
    board,
    mistakesMode,
    showTimer,
    selectedIndex,
    notesMode,
    history,
  ];
}
