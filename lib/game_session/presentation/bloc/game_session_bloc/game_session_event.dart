part of 'game_session_bloc.dart';

sealed class GameSessionEvent extends Equatable {
  const GameSessionEvent();
}

class RoundFinishedForReview extends GameSessionEvent {
  const RoundFinishedForReview({
    required this.reviewedWords,
  });

  final List<ReviewedWord> reviewedWords;

  @override
  List<Object?> get props => [reviewedWords];
}

class RoundFinished extends GameSessionEvent {
  const RoundFinished({required this.wordsShown, required this.guessedCount});

  final int wordsShown;
  final int guessedCount;

  @override
  List<Object?> get props => [wordsShown, guessedCount];
}

class RoundReviewFinished extends GameSessionEvent {
  const RoundReviewFinished({required this.guessedCount});

  final int guessedCount;

  @override
  List<Object?> get props => [guessedCount];
}
