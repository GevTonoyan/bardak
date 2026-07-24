import 'package:bardak/features/games/sudoku/sudoku_game/domain/entities/sudoku_board_entity.dart';
import 'package:bardak/features/games/sudoku/sudoku_game/domain/entities/sudoku_win_record_entity.dart';
import 'package:bardak/features/games/sudoku/sudoku_settings/domain/entities/sudoku_difficulty.dart';
import 'package:equatable/equatable.dart';

class SudokuState extends Equatable {
  const SudokuState({
    required this.board,
    required this.difficulty,
    required this.showTimer,
    this.isGenerating = false,
    this.selectedIndex,
    this.notesMode = false,
    this.history = const [],
    this.mistakes = 0,
    this.score = 0,
    this.scoredCells = const {},
    this.elapsedSeconds = 0,
    this.completedCells = const {},
    this.completionOrigin = 0,
    this.completionTick = 0,
    this.winRecord,
  });

  /// How many wrong entries end the game.
  static const maxMistakes = 3;

  final SudokuBoardEntity board;

  /// Difficulty the puzzle was generated with; drives scoring and stats.
  final SudokuDifficulty difficulty;

  /// Whether the elapsed time is shown.
  final bool showTimer;

  /// True while the puzzle is generated in the background; the board is a
  /// locked placeholder and input is ignored.
  final bool isGenerating;

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

  /// Points earned this game.
  final int score;

  /// Cells that already earned their placement points, so erasing and
  /// re-entering a digit cannot farm the same points twice.
  final Set<int> scoredCells;

  /// Seconds played so far, ticked by the screen's timer.
  final int elapsedSeconds;

  /// Cells of the row/column/box units the last placement completed
  /// correctly — the UI plays a celebration ripple over them.
  final Set<int> completedCells;

  /// The cell whose placement triggered the celebration; the ripple
  /// spreads outwards from it.
  final int completionOrigin;

  /// Bumped every time a new unit completes, so the celebration animation
  /// retriggers even when the same cells complete again after an undo.
  final int completionTick;

  /// Set on the solved emission: updated lifetime stats and whether this
  /// game set new records.
  final SudokuWinRecordEntity? winRecord;

  bool get isSolved => !isGenerating && board.isSolved;

  /// Whether there is a previous action to undo.
  bool get canUndo => history.isNotEmpty;

  /// Whether the player has used up all mistakes and the game has ended.
  bool get isGameOver => mistakes >= maxMistakes;

  /// Full board that is not a solution — the player is stuck without
  /// knowing why unless we tell them something is wrong.
  bool get isFullButWrong => !isGenerating && board.isFull && !board.isSolved;

  /// Whether the cell at [index] holds a wrong digit. The puzzle has a
  /// unique solution, so wrong-versus-solution is always well defined.
  bool isMistake(int index) => board.isWrong(index);

  /// How many of [digit] the player still has to place.
  int remainingOf(int digit) => SudokuBoardEntity.size - board.countOf(digit);

  SudokuState copyWith({
    SudokuBoardEntity? board,
    bool? isGenerating,
    int? selectedIndex,
    bool deselect = false,
    bool? notesMode,
    List<SudokuBoardEntity>? history,
    int? mistakes,
    int? score,
    Set<int>? scoredCells,
    int? elapsedSeconds,
    Set<int>? completedCells,
    int? completionOrigin,
    int? completionTick,
    SudokuWinRecordEntity? winRecord,
  }) {
    return SudokuState(
      board: board ?? this.board,
      difficulty: difficulty,
      showTimer: showTimer,
      isGenerating: isGenerating ?? this.isGenerating,
      // [selectedIndex] can only be cleared explicitly via [deselect],
      // since it is nullable and copyWith cannot distinguish "keep" from
      // "set to null".
      selectedIndex: deselect ? null : (selectedIndex ?? this.selectedIndex),
      notesMode: notesMode ?? this.notesMode,
      history: history ?? this.history,
      mistakes: mistakes ?? this.mistakes,
      score: score ?? this.score,
      scoredCells: scoredCells ?? this.scoredCells,
      elapsedSeconds: elapsedSeconds ?? this.elapsedSeconds,
      completedCells: completedCells ?? this.completedCells,
      completionOrigin: completionOrigin ?? this.completionOrigin,
      completionTick: completionTick ?? this.completionTick,
      winRecord: winRecord ?? this.winRecord,
    );
  }

  @override
  List<Object?> get props => [
    board,
    difficulty,
    showTimer,
    isGenerating,
    selectedIndex,
    notesMode,
    history,
    mistakes,
    score,
    scoredCells,
    elapsedSeconds,
    completedCells,
    completionOrigin,
    completionTick,
    winRecord,
  ];
}
