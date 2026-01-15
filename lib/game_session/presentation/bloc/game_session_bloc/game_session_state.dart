part of 'game_session_bloc.dart';

class GameSessionState {
  const GameSessionState({required this.gameState, this.pendingReviewWords});

  final GameSessionEntity gameState;

  /// Only used between RoundScreen -> ReviewScreen.
  final List<ReviewedWord>? pendingReviewWords;

  GameSessionState copyWith({
    GameSessionEntity? gameState,
    List<ReviewedWord>? pendingReviewWords,
  }) {
    return GameSessionState(
      gameState: gameState ?? this.gameState,
      pendingReviewWords: pendingReviewWords ?? this.pendingReviewWords,
    );
  }
}
