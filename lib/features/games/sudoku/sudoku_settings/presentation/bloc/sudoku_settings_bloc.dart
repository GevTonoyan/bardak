import 'package:bardak/features/games/sudoku/sudoku_settings/domain/usecases/get_sudoku_settings_usecase.dart';
import 'package:bardak/features/games/sudoku/sudoku_settings/domain/usecases/update_mistakes_mode_usecase.dart';
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
    required this._updateMistakesModeUseCase,
    required this._updateShowTimerUseCase,
  }) : super(SudokuSettingsState(sudokuSettings: getSudokuSettingsUseCase())) {
    on<ChangeDifficulty>(_onChangeDifficulty);
    on<ChangeMistakesMode>(_onChangeMistakesMode);
    on<ChangeShowTimer>(_onChangeShowTimer);
  }

  final UpdateSudokuDifficultyUseCase _updateSudokuDifficultyUseCase;
  final UpdateMistakesModeUseCase _updateMistakesModeUseCase;
  final UpdateShowTimerUseCase _updateShowTimerUseCase;

  Future<void> _onChangeDifficulty(
    ChangeDifficulty event,
    Emitter<SudokuSettingsState> emit,
  ) async {
    if (state.sudokuSettings.difficulty == event.difficulty) return;

    emit(
      SudokuSettingsState(
        sudokuSettings: state.sudokuSettings.copyWith(
          difficulty: event.difficulty,
        ),
      ),
    );

    await _updateSudokuDifficultyUseCase(event.difficulty);
  }

  Future<void> _onChangeMistakesMode(
    ChangeMistakesMode event,
    Emitter<SudokuSettingsState> emit,
  ) async {
    if (state.sudokuSettings.mistakesMode == event.mistakesMode) return;

    emit(
      SudokuSettingsState(
        sudokuSettings: state.sudokuSettings.copyWith(
          mistakesMode: event.mistakesMode,
        ),
      ),
    );

    await _updateMistakesModeUseCase(event.mistakesMode);
  }

  Future<void> _onChangeShowTimer(
    ChangeShowTimer event,
    Emitter<SudokuSettingsState> emit,
  ) async {
    emit(
      SudokuSettingsState(
        sudokuSettings: state.sudokuSettings.copyWith(
          showTimer: event.showTimer,
        ),
      ),
    );

    await _updateShowTimerUseCase(showTimer: event.showTimer);
  }
}
