part of 'alias_pre_game_bloc.dart';

/// AliasPreGameState is the base class for all states in the [AliasPreGameBloc].
sealed class AliasPreGameState {
  const AliasPreGameState();
}

/// Initial state of the [AliasPreGameBloc].
class AliasPreGameInitialState extends AliasPreGameState {
  const AliasPreGameInitialState();
}

/// State when the alias settings are loading.
class AliasPreGameLoadingState extends AliasPreGameState {
  const AliasPreGameLoadingState();
}

/// State when the alias settings are loaded.
class AliasPreGameLoadedState extends AliasPreGameState {
  final AliasPreGameConfig preGameConfig;

  const AliasPreGameLoadedState(this.preGameConfig);
}
