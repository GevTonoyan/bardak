part of 'card_round_bloc.dart';

sealed class CardRoundEvent {
  const CardRoundEvent();
}

class ToggleWord extends CardRoundEvent {
  const ToggleWord({required this.word, required this.isSelected});

  final String word;
  final bool isSelected;
}

class CompleteRoundRequested extends CardRoundEvent {
  const CompleteRoundRequested();
}
