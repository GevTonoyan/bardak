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
    if (state.isSolved) return;
    if (event.index < 0 || event.index >= SudokuBoardEntity.cellCount) return;

    emit(state.copyWith(selectedIndex: event.index));
  }

  void _onEnterDigit(EnterDigit event, Emitter<SudokuState> emit) {
    // No further input once solved: the UI navigates away on the solved
    // emission, and a duplicate would re-trigger it.
    if (state.isSolved) return;
    if (event.digit < 1 || event.digit > SudokuBoardEntity.size) return;

    final index = state.selectedIndex;
    final board = state.board;
    if (index == null || board.given[index]) return;

    // In notes mode a digit is a pencil-mark; otherwise it is the answer,
    // which clears any notes already in the cell.
    final next = state.notesMode
        ? board.withNote(index, event.digit)
        : board.withValue(index, event.digit);

    _commitBoard(next, emit);
  }

  void _onToggleNotesMode(ToggleNotesMode event, Emitter<SudokuState> emit) {
    if (state.isSolved) return;
    emit(state.copyWith(notesMode: !state.notesMode));
  }

  void _onEraseCell(EraseCell event, Emitter<SudokuState> emit) {
    if (state.isSolved) return;

    final index = state.selectedIndex;
    if (index == null || state.board.given[index]) return;

    _commitBoard(
      state.board.withValue(index, SudokuBoardEntity.empty),
      emit,
    );
  }

  void _onUndo(Undo event, Emitter<SudokuState> emit) {
    if (state.isSolved || state.history.isEmpty) return;

    final previous = state.history.last;
    emit(
      state.copyWith(
        board: previous,
        history: state.history.sublist(0, state.history.length - 1),
      ),
    );
  }
}
