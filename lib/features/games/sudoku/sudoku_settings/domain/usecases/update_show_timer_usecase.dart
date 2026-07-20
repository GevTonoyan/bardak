import 'package:bardak/features/games/sudoku/sudoku_settings/domain/repositories/sudoku_settings_repository.dart';

/// Persists whether the elapsed time is shown during the game.
class UpdateShowTimerUseCase {
  const UpdateShowTimerUseCase(this._sudokuSettingsRepository);

  final SudokuSettingsRepository _sudokuSettingsRepository;

  Future<bool> call({required bool showTimer}) =>
      _sudokuSettingsRepository.updateShowTimer(showTimer: showTimer);
}
