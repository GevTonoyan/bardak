import 'package:bardak/features/games/sudoku/sudoku_settings/domain/entities/sudoku_settings_entity.dart';
import 'package:equatable/equatable.dart';

class SudokuSettingsState extends Equatable {
  const SudokuSettingsState({
    required this.sudokuSettings,
    this.hasSavedGame = false,
  });

  final SudokuSettingsEntity sudokuSettings;

  /// Whether an unfinished game can be resumed.
  final bool hasSavedGame;

  SudokuSettingsState copyWith({
    SudokuSettingsEntity? sudokuSettings,
    bool? hasSavedGame,
  }) {
    return SudokuSettingsState(
      sudokuSettings: sudokuSettings ?? this.sudokuSettings,
      hasSavedGame: hasSavedGame ?? this.hasSavedGame,
    );
  }

  @override
  List<Object?> get props => [sudokuSettings, hasSavedGame];
}
