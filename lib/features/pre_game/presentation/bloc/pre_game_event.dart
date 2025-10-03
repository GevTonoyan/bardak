part of 'pre_game_bloc.dart';

/// AliasPreGameEvent is the base class for all events in the [PreGameBloc].
sealed class PreGameEvent {
  const PreGameEvent();
}

/// Event to get the alias pre game config.
class GetPreGameConfig extends PreGameEvent {
  const GetPreGameConfig({required this.teamNames, required this.localeCode});

  final List<String> teamNames;
  final String localeCode;
}

/// Change game mode event.
class ChangeGameModeEvent extends PreGameEvent {
  const ChangeGameModeEvent(this.gameMode);

  final GameMode gameMode;
}

/// Change card_round duration event.
class ChangeRoundDurationEvent extends PreGameEvent {
  const ChangeRoundDurationEvent(this.roundDuration);

  final int roundDuration;
}

/// Change points to win event.
class ChangePointsToWinEvent extends PreGameEvent {
  const ChangePointsToWinEvent(this.pointsToWin);

  final int pointsToWin;
}

///  Change words per card event.
class ChangeWordsPerCardEvent extends PreGameEvent {
  const ChangeWordsPerCardEvent(this.wordsPerCard);

  final int wordsPerCard;
}

/// Change allow skipping event.
class ChangeAllowSkippingEvent extends PreGameEvent {
  const ChangeAllowSkippingEvent({required this.allowSkipping});

  final bool allowSkipping;
}

/// Change penalty for skipping event.
class ChangePenaltyForSkippingEvent extends PreGameEvent {
  const ChangePenaltyForSkippingEvent({required this.penaltyForSkipping});

  final bool penaltyForSkipping;
}

/// Add new team event.
class AddTeamEvent extends PreGameEvent {
  const AddTeamEvent(this.teamName);

  final String teamName;
}

/// Remove team event.
class RemoveTeamEvent extends PreGameEvent {
  const RemoveTeamEvent(this.index);

  final int index;
}
