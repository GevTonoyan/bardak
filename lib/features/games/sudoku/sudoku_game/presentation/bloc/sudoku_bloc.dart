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
    if (index == null || state.board.given[index]) return;

    emit(state.copyWith(board: state.board.withValue(index, event.digit)));
  }

  void _onEraseCell(EraseCell event, Emitter<SudokuState> emit) {
    if (state.isSolved) return;

    final index = state.selectedIndex;
    if (index == null || state.board.given[index]) return;

    emit(
      state.copyWith(
        board: state.board.withValue(index, SudokuBoardEntity.empty),
      ),
    );
  }
}
