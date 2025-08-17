part of 'gameplay_bloc.dart';

abstract class PlayState {
  const PlayState();
}

class GameplayInitial extends PlayState {
  const GameplayInitial();
}

class PlayLoaded extends PlayState {
  final AliasGameStateEntity gameState;

  const PlayLoaded(this.gameState);
}
