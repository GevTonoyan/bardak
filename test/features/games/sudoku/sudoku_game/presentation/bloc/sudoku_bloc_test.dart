import 'dart:math';

import 'package:bardak/features/games/sudoku/sudoku_game/domain/entities/sudoku_board_entity.dart';
import 'package:bardak/features/games/sudoku/sudoku_game/presentation/bloc/sudoku_bloc.dart';
import 'package:bardak/features/games/sudoku/sudoku_game/presentation/bloc/sudoku_event.dart';
import 'package:bardak/features/games/sudoku/sudoku_game/presentation/bloc/sudoku_state.dart';
import 'package:bardak/features/games/sudoku/sudoku_settings/domain/entities/sudoku_mistakes_mode.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late SudokuBoardEntity board;
  late int editable;
  late int locked;

  setUp(() {
    board = SudokuBoardEntity.generate(random: Random(1));
    editable = board.given.indexOf(false);
    locked = board.given.indexOf(true);
  });

  SudokuBloc buildBloc() => SudokuBloc(
    board: board,
    mistakesMode: SudokuMistakesMode.errors,
    showTimer: true,
  );

  test('SelectCell targets the cell for input', () async {
    final bloc = buildBloc()..add(SelectCell(editable));
    addTearDown(bloc.close);
    await pumpEventQueue();

    expect(bloc.state.selectedIndex, editable);
  });

  test('EnterDigit fills the selected editable cell', () async {
    final bloc = buildBloc()
      ..add(SelectCell(editable))
      ..add(const EnterDigit(5));
    addTearDown(bloc.close);
    await pumpEventQueue();

    expect(bloc.state.board.values[editable], 5);
  });

  test('EnterDigit without a selection is ignored', () async {
    final bloc = buildBloc()..add(const EnterDigit(5));
    addTearDown(bloc.close);
    await pumpEventQueue();

    expect(bloc.state.board, board);
  });

  test('a given cell cannot be edited or erased', () async {
    final bloc = buildBloc()
      ..add(SelectCell(locked))
      ..add(const EnterDigit(5))
      ..add(const EraseCell());
    addTearDown(bloc.close);
    await pumpEventQueue();

    expect(bloc.state.board.values[locked], board.solution[locked]);
  });

  test('EraseCell clears the selected cell', () async {
    final bloc = buildBloc()
      ..add(SelectCell(editable))
      ..add(const EnterDigit(5))
      ..add(const EraseCell());
    addTearDown(bloc.close);
    await pumpEventQueue();

    expect(bloc.state.board.values[editable], SudokuBoardEntity.empty);
  });

  test('out of range digits and cells are ignored', () async {
    final bloc = buildBloc()
      ..add(const SelectCell(-1))
      ..add(const SelectCell(81))
      ..add(SelectCell(editable))
      ..add(const EnterDigit(0))
      ..add(const EnterDigit(10));
    addTearDown(bloc.close);
    await pumpEventQueue();

    expect(bloc.state.selectedIndex, editable);
    expect(bloc.state.board.values[editable], SudokuBoardEntity.empty);
  });

  test('notes mode toggles a candidate in an empty cell', () async {
    final bloc = buildBloc()
      ..add(const ToggleNotesMode())
      ..add(SelectCell(editable))
      ..add(const EnterDigit(4));
    addTearDown(bloc.close);
    await pumpEventQueue();

    expect(bloc.state.notesMode, isTrue);
    expect(bloc.state.board.notes[editable], {4});
    expect(bloc.state.board.values[editable], SudokuBoardEntity.empty);

    bloc.add(const EnterDigit(4));
    await pumpEventQueue();
    expect(bloc.state.board.notes[editable], isEmpty);
  });

  test('entering a value clears the cell notes', () async {
    final bloc = buildBloc()
      ..add(const ToggleNotesMode())
      ..add(SelectCell(editable))
      ..add(const EnterDigit(3))
      ..add(const EnterDigit(7))
      ..add(const ToggleNotesMode())
      ..add(const EnterDigit(5));
    addTearDown(bloc.close);
    await pumpEventQueue();

    expect(bloc.state.board.values[editable], 5);
    expect(bloc.state.board.notes[editable], isEmpty);
  });

  test('notes cannot be added to a given cell', () async {
    final bloc = buildBloc()
      ..add(const ToggleNotesMode())
      ..add(SelectCell(locked))
      ..add(const EnterDigit(4));
    addTearDown(bloc.close);
    await pumpEventQueue();

    expect(bloc.state.board.notes[locked], isEmpty);
  });

  test('undo reverts the last placed value', () async {
    final bloc = buildBloc()
      ..add(SelectCell(editable))
      ..add(const EnterDigit(5));
    addTearDown(bloc.close);
    await pumpEventQueue();
    expect(bloc.state.board.values[editable], 5);
    expect(bloc.state.canUndo, isTrue);

    bloc.add(const Undo());
    await pumpEventQueue();
    expect(bloc.state.board.values[editable], SudokuBoardEntity.empty);
    expect(bloc.state.canUndo, isFalse);
  });

  test('undo reverts the last pencil mark', () async {
    final bloc = buildBloc()
      ..add(const ToggleNotesMode())
      ..add(SelectCell(editable))
      ..add(const EnterDigit(4));
    addTearDown(bloc.close);
    await pumpEventQueue();
    expect(bloc.state.board.notes[editable], {4});

    bloc.add(const Undo());
    await pumpEventQueue();
    expect(bloc.state.board.notes[editable], isEmpty);
  });

  test('undo steps back one action at a time', () async {
    final bloc = buildBloc()
      ..add(SelectCell(editable))
      ..add(const EnterDigit(5))
      ..add(const EnterDigit(6));
    addTearDown(bloc.close);
    await pumpEventQueue();
    expect(bloc.state.board.values[editable], 6);

    bloc.add(const Undo());
    await pumpEventQueue();
    expect(bloc.state.board.values[editable], 5);

    bloc.add(const Undo());
    await pumpEventQueue();
    expect(bloc.state.board.values[editable], SudokuBoardEntity.empty);
  });

  test('undo with nothing to undo is a no-op', () async {
    final bloc = buildBloc()..add(const Undo());
    addTearDown(bloc.close);
    await pumpEventQueue();

    expect(bloc.state.board, board);
    expect(bloc.state.canUndo, isFalse);
  });

  test(
    'completing the board emits solved exactly once and locks input',
    () async {
      final bloc = buildBloc();
      addTearDown(bloc.close);

      final solvedEmissions = <SudokuState>[];
      final subscription = bloc.stream
          .where((s) => s.isSolved)
          .listen(solvedEmissions.add);
      addTearDown(subscription.cancel);

      for (var i = 0; i < SudokuBoardEntity.cellCount; i++) {
        if (!board.given[i]) {
          bloc
            ..add(SelectCell(i))
            ..add(EnterDigit(board.solution[i]));
        }
      }
      await pumpEventQueue();
      expect(bloc.state.isSolved, isTrue);

      // Late taps after the win must not emit again.
      bloc
        ..add(SelectCell(editable))
        ..add(const EnterDigit(1))
        ..add(const EraseCell());
      await pumpEventQueue();

      expect(solvedEmissions, hasLength(1));
      expect(bloc.state.isSolved, isTrue);
    },
  );
}
