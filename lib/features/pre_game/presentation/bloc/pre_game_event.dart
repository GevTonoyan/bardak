part of 'pre_game_bloc.dart';

/// AliasPreGameEvent is the base class for all events in the [PreGameBloc].
sealed class PreGameEvent {
  const PreGameEvent();
}

/// Event to get the alias pre game config.
class GetPreGameConfig extends PreGameEvent {
  final List<String> teamNames;

  const GetPreGameConfig({required this.teamNames});
}

/// Change game mode event.
class ChangeGameModeEvent extends PreGameEvent {
  final GameMode gameMode;

  const ChangeGameModeEvent(this.gameMode);
}

/// Change round duration event.
class ChangeRoundDurationEvent extends PreGameEvent {
  final int roundDuration;

  const ChangeRoundDurationEvent(this.roundDuration);
}

/// Change points to win event.
class ChangePointsToWinEvent extends PreGameEvent {
  final int pointsToWin;

  const ChangePointsToWinEvent(this.pointsToWin);
}

///  Change words per card event.
class ChangeWordsPerCardEvent extends PreGameEvent {
  final int wordsPerCard;

  const ChangeWordsPerCardEvent(this.wordsPerCard);
}

/// Change allow skipping event.
class ChangeAllowSkippingEvent extends PreGameEvent {
  final bool allowSkipping;

  const ChangeAllowSkippingEvent(this.allowSkipping);
}

/// Change penalty for skipping event.
class ChangePenaltyForSkippingEvent extends PreGameEvent {
  final bool penaltyForSkipping;

  const ChangePenaltyForSkippingEvent(this.penaltyForSkipping);
}

/// Add new team event.
class AddTeamEvent extends PreGameEvent {
  final String teamName;

  const AddTeamEvent(this.teamName);
}

/// Remove team event.
class RemoveTeamEvent extends PreGameEvent {
  final int index;

  const RemoveTeamEvent(this.index);
}
