import 'dart:async';

import 'package:bardak/features/games/sudoku/sudoku_game/domain/entities/sudoku_board_entity.dart';
import 'package:bardak/features/games/sudoku/sudoku_game/domain/entities/sudoku_saved_game_entity.dart';
import 'package:bardak/features/games/sudoku/sudoku_game/domain/usecases/clear_saved_sudoku_game_usecase.dart';
import 'package:bardak/features/games/sudoku/sudoku_game/domain/usecases/generate_sudoku_board_usecase.dart';
import 'package:bardak/features/games/sudoku/sudoku_game/domain/usecases/get_sudoku_stats_usecase.dart';
import 'package:bardak/features/games/sudoku/sudoku_game/domain/usecases/record_sudoku_win_usecase.dart';
import 'package:bardak/features/games/sudoku/sudoku_game/domain/usecases/update_saved_sudoku_game_usecase.dart';
import 'package:bardak/features/games/sudoku/sudoku_game/presentation/bloc/sudoku_event.dart';
import 'package:bardak/features/games/sudoku/sudoku_game/presentation/bloc/sudoku_state.dart';
import 'package:bardak/features/games/sudoku/sudoku_settings/domain/entities/sudoku_board_size.dart';
import 'package:bardak/features/games/sudoku/sudoku_settings/domain/entities/sudoku_difficulty.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SudokuBloc extends Bloc<SudokuEvent, SudokuState> {
  /// Resumes [savedGame] or uses an explicit [board] when given; otherwise
  /// starts a fresh puzzle. Fast difficulties are generated synchronously
  /// here so the board is ready on the first frame with no loading state;
  /// slow ones (expert/extreme) start as a placeholder and are generated
  /// off the main thread.
  SudokuBloc({
    required SudokuBoardSize boardSize,
    required SudokuDifficulty difficulty,
    required this._generateSudokuBoardUseCase,
    required this._updateSavedSudokuGameUseCase,
    required this._clearSavedSudokuGameUseCase,
    required this._recordSudokuWinUseCase,
    required GetSudokuStatsUseCase getSudokuStatsUseCase,
    SudokuSavedGameEntity? savedGame,
    SudokuBoardEntity? board,
  }) : super(
         SudokuState(
           board: _initialBoard(boardSize, difficulty, board, savedGame),
           boardSize: savedGame?.boardSize ?? boardSize,
           difficulty: savedGame?.difficulty ?? difficulty,
           bestTimeSeconds: getSudokuStatsUseCase()
               .statsFor(
                 (savedGame?.boardSize ?? boardSize).statsKey(
                   savedGame?.difficulty ?? difficulty,
                 ),
               )
               .bestTimeSeconds,
           isGenerating:
               board == null &&
               savedGame == null &&
               boardSize.needsBackgroundGeneration(difficulty),
           mistakes: savedGame?.mistakes ?? 0,
           elapsedSeconds: savedGame?.elapsedSeconds ?? 0,
         ),
       ) {
    // The two async handlers below deliberately use the default
    // (concurrent) transformer: GeneratePuzzle is dispatched exactly once
    // from this constructor, and RecordWin guards itself to run only once,
    // so neither can overlap and no concurrency control is needed.
    on<GeneratePuzzle>(_onGeneratePuzzle);
    on<SelectCell>(_onSelectCell);
    on<Deselect>(_onDeselect);
    on<EnterDigit>(_onEnterDigit);
    on<EraseCell>(_onEraseCell);
    on<ToggleNotesMode>(_onToggleNotesMode);
    on<Undo>(_onUndo);
    on<TimerTicked>(_onTimerTicked);
    on<RecordWin>(_onRecordWin);

    if (state.isGenerating) add(const GeneratePuzzle());
  }

  final GenerateSudokuBoardUseCase _generateSudokuBoardUseCase;
  final UpdateSavedSudokuGameUseCase _updateSavedSudokuGameUseCase;
  final ClearSavedSudokuGameUseCase _clearSavedSudokuGameUseCase;
  final RecordSudokuWinUseCase _recordSudokuWinUseCase;

  /// The board to start from: a resumed/explicit board when given, a fast
  /// difficulty generated synchronously, or a placeholder for a slow
  /// difficulty that will be generated in the background.
  static SudokuBoardEntity _initialBoard(
    SudokuBoardSize boardSize,
    SudokuDifficulty difficulty,
    SudokuBoardEntity? board,
    SudokuSavedGameEntity? savedGame,
  ) {
    if (board != null) return board;
    if (savedGame != null) return savedGame.board;
    if (boardSize.needsBackgroundGeneration(difficulty)) {
      return SudokuBoardEntity.placeholder(boxSize: boardSize.boxSize);
    }
    return SudokuBoardEntity.generate(
      boxSize: boardSize.boxSize,
      givensCount: boardSize.givensCountFor(difficulty),
    );
  }

  /// Input is ignored while the puzzle is generated, once it is solved
  /// (the UI navigates away on the solved emission) or after game over.
  bool get _isLocked =>
      state.isGenerating || state.isSolved || state.isGameOver;

  /// Persists the current state as the resumable game.
  void _saveGame() {
    unawaited(
      _updateSavedSudokuGameUseCase(
        SudokuSavedGameEntity(
          board: state.board,
          boardSize: state.boardSize,
          difficulty: state.difficulty,
          mistakes: state.mistakes,
          elapsedSeconds: state.elapsedSeconds,
        ),
      ),
    );
  }

  /// Emits [next] as the board, recording the current board on the undo
  /// history. A no-op change (identical board) is ignored so undo only
  /// steps back over actions that actually changed something.
  void _commitBoard(SudokuBoardEntity next, Emitter<SudokuState> emit) {
    if (next == state.board) return;
    emit(
      state.copyWith(board: next, history: [...state.history, state.board]),
    );
    _saveGame();
  }

  Future<void> _onGeneratePuzzle(
    GeneratePuzzle event,
    Emitter<SudokuState> emit,
  ) async {
    final board = await _generateSudokuBoardUseCase(
      GenerateSudokuBoardParams(
        boxSize: state.boardSize.boxSize,
        givensCount: state.boardSize.givensCountFor(state.difficulty),
      ),
    );
    emit(state.copyWith(board: board, isGenerating: false));
  }

  void _onSelectCell(SelectCell event, Emitter<SudokuState> emit) {
    if (_isLocked) return;
    if (event.index < 0 || event.index >= state.board.cellCount) return;

    emit(state.copyWith(selectedIndex: event.index));
  }

  void _onDeselect(Deselect event, Emitter<SudokuState> emit) {
    if (state.selectedIndex == null) return;
    emit(state.copyWith(deselect: true));
  }

  void _onEnterDigit(EnterDigit event, Emitter<SudokuState> emit) {
    if (_isLocked) return;
    if (event.digit < 1 || event.digit > state.board.size) return;

    final index = state.selectedIndex;
    final board = state.board;
    if (index == null || board.given[index]) return;

    // A cell already holding its correct answer is treated like a given:
    // another digit tap there is accidental, so ignore it instead of
    // overwriting a correct value and charging a mistake.
    if (board.isCorrect(index)) return;

    // In notes mode a digit is only a pencil-mark: no mistake.
    if (state.notesMode) {
      _commitBoard(board.withNote(index, event.digit), emit);
      return;
    }

    // Placing an answer clears the cell's notes and strips the digit from
    // peer notes. A wrong entry counts against the mistake limit.
    final next = board.withValue(index, event.digit);
    if (next == board) return;

    final isWrong = next.isWrong(index);

    // Units (row/column/box) this placement just solved get a
    // celebration ripple in the UI, spreading out from the placed cell.
    final completed = <int>{
      for (final unit in board.unitsOf(index))
        if (!board.isUnitSolved(unit) && next.isUnitSolved(unit)) ...unit,
    };

    emit(
      state.copyWith(
        board: next,
        history: [...state.history, board],
        mistakes: isWrong ? state.mistakes + 1 : state.mistakes,
        completedCells: completed.isEmpty ? null : completed,
        completionOrigin: completed.isEmpty ? null : index,
        completionTick: completed.isEmpty ? null : state.completionTick + 1,
      ),
    );

    // A solved board or a game over discards the unfinished game;
    // anything else stays resumable. The win is recorded by a follow-up
    // event so this handler stays synchronous and taps process in order.
    if (state.isSolved) {
      unawaited(_clearSavedSudokuGameUseCase());
      add(const RecordWin());
    } else if (state.isGameOver) {
      unawaited(_clearSavedSudokuGameUseCase());
    } else {
      _saveGame();
    }
  }

  Future<void> _onRecordWin(RecordWin event, Emitter<SudokuState> emit) async {
    if (!state.isSolved || state.winRecord != null) return;

    final record = await _recordSudokuWinUseCase(
      RecordSudokuWinParams(
        statsKey: state.boardSize.statsKey(state.difficulty),
        timeSeconds: state.elapsedSeconds,
      ),
    );
    emit(state.copyWith(winRecord: record));
  }

  void _onToggleNotesMode(ToggleNotesMode event, Emitter<SudokuState> emit) {
    if (_isLocked) return;
    emit(state.copyWith(notesMode: !state.notesMode));
  }

  void _onEraseCell(EraseCell event, Emitter<SudokuState> emit) {
    if (_isLocked) return;

    final index = state.selectedIndex;
    if (index == null || state.board.given[index]) return;

    _commitBoard(
      state.board.withValue(index, SudokuBoardEntity.empty),
      emit,
    );
  }

  void _onUndo(Undo event, Emitter<SudokuState> emit) {
    if (_isLocked || state.history.isEmpty) return;

    final previous = state.history.last;
    emit(
      state.copyWith(
        board: previous,
        history: state.history.sublist(0, state.history.length - 1),
      ),
    );
    _saveGame();
  }

  void _onTimerTicked(TimerTicked event, Emitter<SudokuState> emit) {
    if (_isLocked) return;

    emit(state.copyWith(elapsedSeconds: state.elapsedSeconds + 1));
    // Keeping the snapshot's clock current costs one small write per
    // second and makes a resumed game continue from the exact time.
    _saveGame();
  }
}
