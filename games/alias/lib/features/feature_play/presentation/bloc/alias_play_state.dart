part of 'alias_play_bloc.dart';

abstract class AliasPlayState {
  const AliasPlayState();
}

class AliasPlayInitial extends AliasPlayState {
  const AliasPlayInitial();
}

class AliasPlayLoaded extends AliasPlayState {
  final AliasGameStateEntity gameState;

  const AliasPlayLoaded(this.gameState);
}
