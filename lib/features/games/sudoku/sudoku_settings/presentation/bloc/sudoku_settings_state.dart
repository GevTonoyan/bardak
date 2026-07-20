import 'package:bardak/features/games/sudoku/sudoku_settings/domain/entities/sudoku_settings_entity.dart';
import 'package:equatable/equatable.dart';

class SudokuSettingsState extends Equatable {
  const SudokuSettingsState({required this.sudokuSettings});

  final SudokuSettingsEntity sudokuSettings;

  @override
  List<Object?> get props => [sudokuSettings];
}
