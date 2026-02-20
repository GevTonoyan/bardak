part of 'round_review_bloc.dart';

sealed class RoundReviewEvent extends Equatable {
  const RoundReviewEvent();

  @override
  List<Object?> get props => [];
}

class WordToggled extends RoundReviewEvent {
  const WordToggled({required this.index});

  final int index;

  @override
  List<Object?> get props => [index];
}

class GuessedWordsUpdated extends RoundReviewEvent {
  const GuessedWordsUpdated({required this.guessedWords});

  final Set<String> guessedWords;

  @override
  List<Object?> get props => [guessedWords];
}
