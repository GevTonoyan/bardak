part of 'alias_gameplay_bloc.dart';

abstract class AliasPlayState {
  const AliasPlayState();
}

class AliasGameplayInitial extends AliasPlayState {
  const AliasGameplayInitial();
}

class AliasPlayLoaded extends AliasPlayState {
  final AliasGameStateEntity gameState;

  const AliasPlayLoaded(this.gameState);
}
