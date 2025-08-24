part of 'game_session_bloc.dart';

abstract class GameSessionState {
  const GameSessionState();
}

class GameSessionInitial extends GameSessionState {
  const GameSessionInitial();
}

class GameSessionLoaded extends GameSessionState {
  final GameSessionEntity gameState;

  const GameSessionLoaded(this.gameState);
}
