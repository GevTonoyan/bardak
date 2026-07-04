import 'package:equatable/equatable.dart';

sealed class RoundReviewEvent extends Equatable {
  const RoundReviewEvent();

  @override
  List<Object?> get props => [];
}

/// Cycles the review status of the word at [index].
class ToggleWord extends RoundReviewEvent {
  const ToggleWord({required this.index});

  final int index;

  @override
  List<Object?> get props => [index];
}

/// Marks exactly the given words as guessed, all others as not guessed.
class UpdateGuessedWords extends RoundReviewEvent {
  const UpdateGuessedWords({required this.guessedWords});

  final Set<String> guessedWords;

  @override
  List<Object?> get props => [guessedWords];
}
