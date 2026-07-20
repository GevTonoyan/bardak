import 'package:equatable/equatable.dart';

sealed class SudokuEvent extends Equatable {
  const SudokuEvent();

  @override
  List<Object?> get props => [];
}

/// Selects the cell at [index] as the input target.
class SelectCell extends SudokuEvent {
  const SelectCell(this.index);

  final int index;

  @override
  List<Object?> get props => [index];
}

/// Places [digit] into the selected cell.
class EnterDigit extends SudokuEvent {
  const EnterDigit(this.digit);

  final int digit;

  @override
  List<Object?> get props => [digit];
}

/// Clears the selected cell.
class EraseCell extends SudokuEvent {
  const EraseCell();
}
