import 'package:equatable/equatable.dart';

sealed class CardRoundEvent extends Equatable {
  const CardRoundEvent();

  @override
  List<Object?> get props => [];
}

/// Marks a word on the visible card as guessed or not guessed.
class ToggleWord extends CardRoundEvent {
  const ToggleWord({required this.word, required this.isSelected});

  final String word;
  final bool isSelected;

  @override
  List<Object?> get props => [word, isSelected];
}

/// Ends the round (e.g. when the timer runs out).
class CompleteRound extends CardRoundEvent {
  const CompleteRound();
}
