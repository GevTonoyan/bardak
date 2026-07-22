import 'package:bardak/features/games/sudoku/sudoku_game/domain/entities/sudoku_board_entity.dart';
import 'package:bardak/features/games/sudoku/sudoku_game/presentation/bloc/sudoku_event.dart';
import 'package:bardak/features/games/sudoku/sudoku_game/presentation/bloc/sudoku_state.dart';
import 'package:bardak/features/games/sudoku/sudoku_settings/domain/entities/sudoku_mistakes_mode.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SudokuBloc extends Bloc<SudokuEvent, SudokuState> {
  SudokuBloc({
    required SudokuBoardEntity board,
    required SudokuMistakesMode mistakesMode,
    required bool showTimer,
  }) : super(
         SudokuState(
           board: board,
           mistakesMode: mistakesMode,
           showTimer: showTimer,
         ),
       ) {
    on<SelectCell>(_onSelectCell);
    on<EnterDigit>(_onEnterDigit);
    on<EraseCell>(_onEraseCell);
    on<ToggleNotesMode>(_onToggleNotesMode);
    on<Undo>(_onUndo);
  }

  /// Input is ignored once the puzzle is solved (the UI navigates away on
  /// the solved emission) or the mistake limit is reached (game over).
  bool get _isLocked => state.isSolved || state.isGameOver;

  /// Emits [next] as the board, recording the current board on the undo
  /// history. A no-op change (identical board) is ignored so undo only
  /// steps back over actions that actually changed something.
  void _commitBoard(SudokuBoardEntity next, Emitter<SudokuState> emit) {
    if (next == state.board) return;
    emit(
      state.copyWith(board: next, history: [...state.history, state.board]),
    );
  }

  void _onSelectCell(SelectCell event, Emitter<SudokuState> emit) {
    if (_isLocked) return;
    if (event.index < 0 || event.index >= SudokuBoardEntity.cellCount) return;

    emit(state.copyWith(selectedIndex: event.index));
  }

  void _onEnterDigit(EnterDigit event, Emitter<SudokuState> emit) {
    if (_isLocked) return;
    if (event.digit < 1 || event.digit > SudokuBoardEntity.size) return;

    final index = state.selectedIndex;
    final board = state.board;
    if (index == null || board.given[index]) return;

    // In notes mode a digit is only a pencil-mark and never a mistake.
    if (state.notesMode) {
      _commitBoard(board.withNote(index, event.digit), emit);
      return;
    }

    // Placing an answer clears any notes in the cell. If the resulting
    // entry is flagged by the mistakes mode it counts against the limit.
    final next = board.withValue(index, event.digit);
    if (next == board) return;

    final isMistake = state.copyWith(board: next).isMistake(index);
    emit(
      state.copyWith(
        board: next,
        history: [...state.history, board],
        mistakes: isMistake ? state.mistakes + 1 : state.mistakes,
      ),
    );
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
  }
}
