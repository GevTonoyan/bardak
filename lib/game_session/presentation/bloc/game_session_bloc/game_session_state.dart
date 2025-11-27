part of 'game_session_bloc.dart';

class GameSessionState {
  const GameSessionState(this.gameState);

  final GameSessionEntity gameState;

  GameSessionState copyWith({GameSessionEntity? gameState}) {
    return GameSessionState(gameState ?? this.gameState);
  }
}
