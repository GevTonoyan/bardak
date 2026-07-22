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
    this.mistakes = 0,
  });

  /// How many wrong entries end the game.
  static const maxMistakes = 3;

  final SudokuBoardEntity board;

  /// How mistakes are flagged while playing.
  final SudokuMistakesMode mistakesMode;

  /// Whether the elapsed time is shown.
  final bool showTimer;

  /// Cell currently targeted by the digit pad; null before the first tap.
  final int? selectedIndex;

  /// When true, tapping a digit toggles a pencil-mark instead of placing it.
  final bool notesMode;

  /// Previous board states, oldest first; the last entry is what an undo
  /// restores. Only board-changing actions push onto it.
  final List<SudokuBoardEntity> history;

  /// How many mistakes the player has made so far. Only tracked when the
  /// mistakes mode flags them; capped by [maxMistakes].
  final int mistakes;

  bool get isSolved => board.isSolved;

  /// Whether there is a previous action to undo.
  bool get canUndo => history.isNotEmpty;

  /// Whether the player has used up all mistakes and the game has ended.
  bool get isGameOver => mistakes >= maxMistakes;

  /// Whether mistakes are being tracked at all (a limit is only enforced
  /// when the mode flags mistakes).
  bool get tracksMistakes => mistakesMode != SudokuMistakesMode.off;

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
    int? mistakes,
  }) {
    return SudokuState(
      board: board ?? this.board,
      mistakesMode: mistakesMode,
      showTimer: showTimer,
      selectedIndex: selectedIndex ?? this.selectedIndex,
      notesMode: notesMode ?? this.notesMode,
      history: history ?? this.history,
      mistakes: mistakes ?? this.mistakes,
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
    mistakes,
  ];
}
