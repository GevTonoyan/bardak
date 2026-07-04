import 'package:bardak/features/games/alias/game_session/domain/entities/reviewed_word.dart';
import 'package:equatable/equatable.dart';

sealed class GameSessionEvent extends Equatable {
  const GameSessionEvent();

  @override
  List<Object?> get props => [];
}

/// Records the finished round: scores it and advances to the next team.
class FinishRound extends GameSessionEvent {
  const FinishRound({required this.reviewedWords});

  final List<ReviewedWord> reviewedWords;

  @override
  List<Object?> get props => [reviewedWords];
}

/// Applies review corrections to the last played round's score.
class FinishRoundReview extends GameSessionEvent {
  const FinishRoundReview({required this.reviewedWords});

  final List<ReviewedWord> reviewedWords;

  @override
  List<Object?> get props => [reviewedWords];
}
