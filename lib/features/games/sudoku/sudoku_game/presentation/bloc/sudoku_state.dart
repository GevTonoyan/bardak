import 'package:bardak/features/games/sudoku/sudoku_game/domain/entities/sudoku_board_entity.dart';
import 'package:equatable/equatable.dart';

class SudokuState extends Equatable {
  const SudokuState({
    required this.board,
    required this.showTimer,
    this.selectedIndex,
    this.notesMode = false,
    this.history = const [],
    this.mistakes = 0,
    this.completedCells = const {},
    this.completionOrigin = 0,
    this.completionTick = 0,
  });

  /// How many wrong entries end the game.
  static const maxMistakes = 3;

  final SudokuBoardEntity board;

  /// Whether the elapsed time is shown.
  final bool showTimer;

  /// Cell currently targeted by the digit pad; null before the first tap.
  final int? selectedIndex;

  /// When true, tapping a digit toggles a pencil-mark instead of placing it.
  final bool notesMode;

  /// Previous board states, oldest first; the last entry is what an undo
  /// restores. Only board-changing actions push onto it.
  final List<SudokuBoardEntity> history;

  /// How many wrong entries the player has made so far; the game ends at
  /// [maxMistakes].
  final int mistakes;

  /// Cells of the row/column/box units the last placement completed
  /// correctly — the UI plays a celebration ripple over them.
  final Set<int> completedCells;

  /// The cell whose placement triggered the celebration; the ripple
  /// spreads outwards from it.
  final int completionOrigin;

  /// Bumped every time a new unit completes, so the celebration animation
  /// retriggers even when the same cells complete again after an undo.
  final int completionTick;

  bool get isSolved => board.isSolved;

  /// Whether there is a previous action to undo.
  bool get canUndo => history.isNotEmpty;

  /// Whether the player has used up all mistakes and the game has ended.
  bool get isGameOver => mistakes >= maxMistakes;

  /// Full board that is not a solution — the player is stuck without
  /// knowing why unless we tell them something is wrong.
  bool get isFullButWrong => board.isFull && !board.isSolved;

  /// Whether the cell at [index] holds a wrong digit. The puzzle has a
  /// unique solution, so wrong-versus-solution is always well defined.
  bool isMistake(int index) => board.isWrong(index);

  SudokuState copyWith({
    SudokuBoardEntity? board,
    int? selectedIndex,
    bool? notesMode,
    List<SudokuBoardEntity>? history,
    int? mistakes,
    Set<int>? completedCells,
    int? completionOrigin,
    int? completionTick,
  }) {
    return SudokuState(
      board: board ?? this.board,
      showTimer: showTimer,
      selectedIndex: selectedIndex ?? this.selectedIndex,
      notesMode: notesMode ?? this.notesMode,
      history: history ?? this.history,
      mistakes: mistakes ?? this.mistakes,
      completedCells: completedCells ?? this.completedCells,
      completionOrigin: completionOrigin ?? this.completionOrigin,
      completionTick: completionTick ?? this.completionTick,
    );
  }

  @override
  List<Object?> get props => [
    board,
    showTimer,
    selectedIndex,
    notesMode,
    history,
    mistakes,
    completedCells,
    completionOrigin,
    completionTick,
  ];
}
