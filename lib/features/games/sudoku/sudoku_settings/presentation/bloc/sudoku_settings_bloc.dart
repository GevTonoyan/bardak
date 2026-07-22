import 'package:bardak/features/games/sudoku/sudoku_game/domain/usecases/has_saved_sudoku_game_usecase.dart';
import 'package:bardak/features/games/sudoku/sudoku_settings/domain/usecases/get_sudoku_settings_usecase.dart';
import 'package:bardak/features/games/sudoku/sudoku_settings/domain/usecases/update_show_timer_usecase.dart';
import 'package:bardak/features/games/sudoku/sudoku_settings/domain/usecases/update_sudoku_difficulty_usecase.dart';
import 'package:bardak/features/games/sudoku/sudoku_settings/presentation/bloc/sudoku_settings_event.dart';
import 'package:bardak/features/games/sudoku/sudoku_settings/presentation/bloc/sudoku_settings_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SudokuSettingsBloc
    extends Bloc<SudokuSettingsEvent, SudokuSettingsState> {
  SudokuSettingsBloc({
    required GetSudokuSettingsUseCase getSudokuSettingsUseCase,
    required this._updateSudokuDifficultyUseCase,
    required this._updateShowTimerUseCase,
    required this._hasSavedSudokuGameUseCase,
  }) : super(
         SudokuSettingsState(
           sudokuSettings: getSudokuSettingsUseCase(),
           hasSavedGame: _hasSavedSudokuGameUseCase(),
         ),
       ) {
    on<ChangeDifficulty>(_onChangeDifficulty);
    on<ChangeShowTimer>(_onChangeShowTimer);
    on<RefreshSavedGame>(_onRefreshSavedGame);
  }

  final UpdateSudokuDifficultyUseCase _updateSudokuDifficultyUseCase;
  final UpdateShowTimerUseCase _updateShowTimerUseCase;
  final HasSavedSudokuGameUseCase _hasSavedSudokuGameUseCase;

  Future<void> _onChangeDifficulty(
    ChangeDifficulty event,
    Emitter<SudokuSettingsState> emit,
  ) async {
    if (state.sudokuSettings.difficulty == event.difficulty) return;

    emit(
      state.copyWith(
        sudokuSettings: state.sudokuSettings.copyWith(
          difficulty: event.difficulty,
        ),
      ),
    );

    await _updateSudokuDifficultyUseCase(event.difficulty);
  }

  Future<void> _onChangeShowTimer(
    ChangeShowTimer event,
    Emitter<SudokuSettingsState> emit,
  ) async {
    emit(
      state.copyWith(
        sudokuSettings: state.sudokuSettings.copyWith(
          showTimer: event.showTimer,
        ),
      ),
    );

    await _updateShowTimerUseCase(showTimer: event.showTimer);
  }

  void _onRefreshSavedGame(
    RefreshSavedGame event,
    Emitter<SudokuSettingsState> emit,
  ) {
    emit(state.copyWith(hasSavedGame: _hasSavedSudokuGameUseCase()));
  }
}
