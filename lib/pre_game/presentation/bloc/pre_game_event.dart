part of 'pre_game_bloc.dart';

/// AliasPreGameEvent is the base class for all events in the [PreGameBloc].
sealed class PreGameEvent {
  const PreGameEvent();
}

/// Change game mode event.
class ChangeGameModeEvent extends PreGameEvent {
  const ChangeGameModeEvent(this.gameMode);

  final GameMode gameMode;
}

/// Add new team event.
class AddTeamsEvent extends PreGameEvent {
  const AddTeamsEvent(this.teamNames);

  final List<String> teamNames;
}
