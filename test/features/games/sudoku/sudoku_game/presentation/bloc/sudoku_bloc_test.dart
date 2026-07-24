import 'dart:math';

import 'package:bardak/features/games/sudoku/sudoku_game/domain/entities/sudoku_board_entity.dart';
import 'package:bardak/features/games/sudoku/sudoku_game/domain/entities/sudoku_saved_game_entity.dart';
import 'package:bardak/features/games/sudoku/sudoku_game/domain/entities/sudoku_stats_entity.dart';
import 'package:bardak/features/games/sudoku/sudoku_game/domain/entities/sudoku_win_record_entity.dart';
import 'package:bardak/features/games/sudoku/sudoku_game/domain/usecases/clear_saved_sudoku_game_usecase.dart';
import 'package:bardak/features/games/sudoku/sudoku_game/domain/usecases/generate_sudoku_board_usecase.dart';
import 'package:bardak/features/games/sudoku/sudoku_game/domain/usecases/record_sudoku_win_usecase.dart';
import 'package:bardak/features/games/sudoku/sudoku_game/domain/usecases/update_saved_sudoku_game_usecase.dart';
import 'package:bardak/features/games/sudoku/sudoku_game/presentation/bloc/sudoku_bloc.dart';
import 'package:bardak/features/games/sudoku/sudoku_game/presentation/bloc/sudoku_event.dart';
import 'package:bardak/features/games/sudoku/sudoku_game/presentation/bloc/sudoku_state.dart';
import 'package:bardak/features/games/sudoku/sudoku_settings/domain/entities/sudoku_difficulty.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockGenerateSudokuBoardUseCase extends Mock
    implements GenerateSudokuBoardUseCase {}

class _MockUpdateSavedSudokuGameUseCase extends Mock
    implements UpdateSavedSudokuGameUseCase {}

class _MockClearSavedSudokuGameUseCase extends Mock
    implements ClearSavedSudokuGameUseCase {}

class _MockRecordSudokuWinUseCase extends Mock
    implements RecordSudokuWinUseCase {}

void main() {
  late SudokuBoardEntity board;
  late int editable;
  late int locked;
  late _MockGenerateSudokuBoardUseCase generateUseCase;
  late _MockUpdateSavedSudokuGameUseCase updateSavedUseCase;
  late _MockClearSavedSudokuGameUseCase clearSavedUseCase;
  late _MockRecordSudokuWinUseCase recordWinUseCase;

  setUpAll(() {
    registerFallbackValue(
      SudokuSavedGameEntity(
        board: SudokuBoardEntity.generate(random: Random(0)),
        difficulty: SudokuDifficulty.medium,
        mistakes: 0,
        score: 0,
        scoredCells: const {},
        elapsedSeconds: 0,
      ),
    );
    registerFallbackValue(
      const RecordSudokuWinParams(
        difficulty: SudokuDifficulty.medium,
        score: 0,
        timeSeconds: 0,
      ),
    );
  });

  setUp(() {
    board = SudokuBoardEntity.generate(random: Random(1));
    editable = board.given.indexOf(false);
    locked = board.given.indexOf(true);
    generateUseCase = _MockGenerateSudokuBoardUseCase();
    updateSavedUseCase = _MockUpdateSavedSudokuGameUseCase();
    clearSavedUseCase = _MockClearSavedSudokuGameUseCase();
    recordWinUseCase = _MockRecordSudokuWinUseCase();

    when(() => updateSavedUseCase(any())).thenAnswer((_) async => true);
    when(() => clearSavedUseCase()).thenAnswer((_) async => true);
    when(() => recordWinUseCase(any())).thenAnswer(
      (_) async => const SudokuWinRecordEntity(
        stats: SudokuDifficultyStats(gamesWon: 1, bestScore: 1),
        isNewBestScore: true,
        isNewBestTime: true,
      ),
    );
  });

  SudokuBloc buildBloc({SudokuSavedGameEntity? savedGame}) => SudokuBloc(
    difficulty: SudokuDifficulty.medium,
    showTimer: true,
    generateSudokuBoardUseCase: generateUseCase,
    updateSavedSudokuGameUseCase: updateSavedUseCase,
    clearSavedSudokuGameUseCase: clearSavedUseCase,
    recordSudokuWinUseCase: recordWinUseCase,
    board: savedGame == null ? board : null,
    savedGame: savedGame,
  );

  test('SelectCell targets the cell for input', () async {
    final bloc = buildBloc()..add(SelectCell(editable));
    addTearDown(bloc.close);
    await pumpEventQueue();

    expect(bloc.state.selectedIndex, editable);
  });

  test('Deselect clears the current selection', () async {
    final bloc = buildBloc()
      ..add(SelectCell(editable))
      ..add(const Deselect());
    addTearDown(bloc.close);
    await pumpEventQueue();

    expect(bloc.state.selectedIndex, isNull);
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

  int wrongDigitFor(int index) => board.solution[index] == 1 ? 2 : 1;

  test('placing a wrong value counts a mistake', () async {
    final bloc = buildBloc()
      ..add(SelectCell(editable))
      ..add(EnterDigit(wrongDigitFor(editable)));
    addTearDown(bloc.close);
    await pumpEventQueue();

    expect(bloc.state.mistakes, 1);
    expect(bloc.state.isGameOver, isFalse);
  });

  test('placing the correct value counts no mistake', () async {
    final bloc = buildBloc()
      ..add(SelectCell(editable))
      ..add(EnterDigit(board.solution[editable]));
    addTearDown(bloc.close);
    await pumpEventQueue();

    expect(bloc.state.mistakes, 0);
  });

  test('a pencil mark never counts as a mistake', () async {
    final bloc = buildBloc()
      ..add(const ToggleNotesMode())
      ..add(SelectCell(editable))
      ..add(EnterDigit(wrongDigitFor(editable)));
    addTearDown(bloc.close);
    await pumpEventQueue();

    expect(bloc.state.mistakes, 0);
  });

  test('three mistakes end the game and lock further input', () async {
    final editables = [
      for (var i = 0; i < SudokuBoardEntity.cellCount; i++)
        if (!board.given[i]) i,
    ];
    final bloc = buildBloc();
    addTearDown(bloc.close);

    for (final i in editables.take(SudokuState.maxMistakes)) {
      bloc
        ..add(SelectCell(i))
        ..add(EnterDigit(wrongDigitFor(i)));
    }
    await pumpEventQueue();
    expect(bloc.state.mistakes, SudokuState.maxMistakes);
    expect(bloc.state.isGameOver, isTrue);

    // Input is locked after game over.
    final fresh = editables[SudokuState.maxMistakes];
    bloc
      ..add(SelectCell(fresh))
      ..add(EnterDigit(board.solution[fresh]));
    await pumpEventQueue();
    expect(bloc.state.board.values[fresh], SudokuBoardEntity.empty);
  });

  test('correctly finishing a row marks its cells for celebration', () async {
    final row = editable ~/ SudokuBoardEntity.size;
    final rowCells = [
      for (var col = 0; col < SudokuBoardEntity.size; col++)
        row * SudokuBoardEntity.size + col,
    ];
    final bloc = buildBloc();
    addTearDown(bloc.close);

    for (final i in rowCells) {
      if (!board.given[i]) {
        bloc
          ..add(SelectCell(i))
          ..add(EnterDigit(board.solution[i]));
      }
    }
    await pumpEventQueue();

    expect(bloc.state.completedCells, containsAll(rowCells));
    expect(bloc.state.completionTick, greaterThan(0));
  });

  test('an incomplete placement triggers no celebration', () async {
    final bloc = buildBloc()
      ..add(SelectCell(editable))
      ..add(EnterDigit(board.solution[editable]));
    addTearDown(bloc.close);
    await pumpEventQueue();

    expect(bloc.state.completionTick, 0);
  });

  test(
    'completing the board emits solved exactly once and locks input',
    () async {
      final bloc = buildBloc();
      addTearDown(bloc.close);

      // The win record lands exactly once; it is the navigation trigger.
      final recordEmissions = <SudokuState>[];
      final subscription = bloc.stream
          .where((s) => s.winRecord != null)
          .listen(recordEmissions.add);
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

      expect(recordEmissions, hasLength(1));
      expect(bloc.state.isSolved, isTrue);

      // The win was recorded once and the resumable snapshot discarded.
      verify(() => recordWinUseCase(any())).called(1);
      verify(() => clearSavedUseCase()).called(1);
      expect(bloc.state.winRecord, isNotNull);
    },
  );

  int rowPeerOf(int index) => [
    for (var col = 0; col < SudokuBoardEntity.size; col++)
      if (!board.given[index ~/
                  SudokuBoardEntity.size *
                  SudokuBoardEntity.size +
              col] &&
          index ~/ SudokuBoardEntity.size * SudokuBoardEntity.size + col !=
              index)
        index ~/ SudokuBoardEntity.size * SudokuBoardEntity.size + col,
  ].first;

  test('a correct placement strips the digit from peer notes', () async {
    // Two empty cells in the same row: pencil the digit into the second,
    // then correctly place it in the first.
    final peer = rowPeerOf(editable);
    final digit = board.solution[editable];

    final bloc = buildBloc()
      ..add(const ToggleNotesMode())
      ..add(SelectCell(peer))
      ..add(EnterDigit(digit))
      ..add(const ToggleNotesMode())
      ..add(SelectCell(editable))
      ..add(EnterDigit(digit));
    addTearDown(bloc.close);
    await pumpEventQueue();

    expect(bloc.state.board.values[editable], digit);
    expect(bloc.state.board.notes[peer], isEmpty);
  });

  test('a wrong placement leaves peer notes intact', () async {
    // Pencil the wrong digit into a peer, then place that same (wrong)
    // digit here: the peer note must survive, as it may still be correct.
    final peer = rowPeerOf(editable);
    final wrong = wrongDigitFor(editable);

    final bloc = buildBloc()
      ..add(const ToggleNotesMode())
      ..add(SelectCell(peer))
      ..add(EnterDigit(wrong))
      ..add(const ToggleNotesMode())
      ..add(SelectCell(editable))
      ..add(EnterDigit(wrong));
    addTearDown(bloc.close);
    await pumpEventQueue();

    expect(bloc.state.board.values[editable], wrong);
    expect(bloc.state.board.notes[peer], contains(wrong));
  });

  test('a correct placement scores once per cell', () async {
    final bloc = buildBloc()
      ..add(SelectCell(editable))
      ..add(EnterDigit(board.solution[editable]));
    addTearDown(bloc.close);
    await pumpEventQueue();
    expect(bloc.state.score, SudokuDifficulty.medium.pointsPerCell);

    // Erasing and re-entering the same cell must not double the points.
    bloc
      ..add(const EraseCell())
      ..add(EnterDigit(board.solution[editable]));
    await pumpEventQueue();
    expect(bloc.state.score, SudokuDifficulty.medium.pointsPerCell);
  });

  test('a wrong placement scores nothing', () async {
    final bloc = buildBloc()
      ..add(SelectCell(editable))
      ..add(EnterDigit(wrongDigitFor(editable)));
    addTearDown(bloc.close);
    await pumpEventQueue();

    expect(bloc.state.score, 0);
  });

  test('remainingOf tracks how many of a digit are left', () async {
    final digit = board.solution[editable];
    final placed = board.countOf(digit);

    final bloc = buildBloc();
    addTearDown(bloc.close);
    expect(bloc.state.remainingOf(digit), SudokuBoardEntity.size - placed);

    bloc
      ..add(SelectCell(editable))
      ..add(EnterDigit(digit));
    await pumpEventQueue();
    expect(
      bloc.state.remainingOf(digit),
      SudokuBoardEntity.size - placed - 1,
    );
  });

  test('every placement updates the resumable snapshot', () async {
    final bloc = buildBloc()
      ..add(SelectCell(editable))
      ..add(EnterDigit(board.solution[editable]));
    addTearDown(bloc.close);
    await pumpEventQueue();

    final saved =
        verify(() => updateSavedUseCase(captureAny())).captured.last
            as SudokuSavedGameEntity;
    expect(saved.board.values[editable], board.solution[editable]);
    expect(saved.score, SudokuDifficulty.medium.pointsPerCell);
  });

  test('game over discards the resumable snapshot', () async {
    final editables = [
      for (var i = 0; i < SudokuBoardEntity.cellCount; i++)
        if (!board.given[i]) i,
    ];
    final bloc = buildBloc();
    addTearDown(bloc.close);

    for (final i in editables.take(SudokuState.maxMistakes)) {
      bloc
        ..add(SelectCell(i))
        ..add(EnterDigit(wrongDigitFor(i)));
    }
    await pumpEventQueue();

    expect(bloc.state.isGameOver, isTrue);
    verify(() => clearSavedUseCase()).called(1);
  });

  test('a saved game restores board, progress and clock', () async {
    final playedBoard = board.withValue(editable, board.solution[editable]);
    final savedGame = SudokuSavedGameEntity(
      board: playedBoard,
      difficulty: SudokuDifficulty.expert,
      mistakes: 2,
      score: 450,
      scoredCells: {editable},
      elapsedSeconds: 321,
    );

    final bloc = buildBloc(savedGame: savedGame);
    addTearDown(bloc.close);

    expect(bloc.state.isGenerating, isFalse);
    expect(bloc.state.board, playedBoard);
    expect(bloc.state.difficulty, SudokuDifficulty.expert);
    expect(bloc.state.mistakes, 2);
    expect(bloc.state.score, 450);
    expect(bloc.state.elapsedSeconds, 321);
  });

  test('timer ticks advance the clock only during play', () async {
    final bloc = buildBloc()
      ..add(const TimerTicked())
      ..add(const TimerTicked());
    addTearDown(bloc.close);
    await pumpEventQueue();

    expect(bloc.state.elapsedSeconds, 2);
  });
}
