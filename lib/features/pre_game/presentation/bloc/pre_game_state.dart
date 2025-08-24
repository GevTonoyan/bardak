part of 'pre_game_bloc.dart';

/// AliasPreGameState is the base class for all states in the [PreGameBloc].
sealed class PreGameState {
  const PreGameState();
}

/// Initial state of the [PreGameBloc].
class PreGameInitialState extends PreGameState {
  const PreGameInitialState();
}

/// State when the alias settings are loading.
class PreGameLoadingState extends PreGameState {
  const PreGameLoadingState();
}

/// State when the alias settings are loaded.
class PreGameLoadedState extends PreGameState {
  final AliasPreGameEntity preGameConfig;

  const PreGameLoadedState(this.preGameConfig);
}
