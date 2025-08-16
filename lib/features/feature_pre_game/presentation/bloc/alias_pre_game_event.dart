part of 'alias_pre_game_bloc.dart';

/// AliasPreGameEvent is the base class for all events in the [AliasPreGameBloc].
sealed class AliasPreGameEvent {
  const AliasPreGameEvent();
}

/// Event to get the alias pre game config.
class GetAliasPreGameConfig extends AliasPreGameEvent {
  final List<String> teamNames;

  const GetAliasPreGameConfig({required this.teamNames});
}

/// Change game mode event.
class ChangeGameModeEvent extends AliasPreGameEvent {
  final AliasGameMode gameMode;

  const ChangeGameModeEvent(this.gameMode);
}

/// Change round duration event.
class ChangeRoundDurationEvent extends AliasPreGameEvent {
  final int roundDuration;

  const ChangeRoundDurationEvent(this.roundDuration);
}

/// Change points to win event.
class ChangePointsToWinEvent extends AliasPreGameEvent {
  final int pointsToWin;

  const ChangePointsToWinEvent(this.pointsToWin);
}

///  Change words per card event.
class ChangeWordsPerCardEvent extends AliasPreGameEvent {
  final int wordsPerCard;

  const ChangeWordsPerCardEvent(this.wordsPerCard);
}

/// Change allow skipping event.
class ChangeAllowSkippingEvent extends AliasPreGameEvent {
  final bool allowSkipping;

  const ChangeAllowSkippingEvent(this.allowSkipping);
}

/// Change penalty for skipping event.
class ChangePenaltyForSkippingEvent extends AliasPreGameEvent {
  final bool penaltyForSkipping;

  const ChangePenaltyForSkippingEvent(this.penaltyForSkipping);
}

/// Add new team event.
class AddTeamEvent extends AliasPreGameEvent {
  final String teamName;

  const AddTeamEvent(this.teamName);
}

/// Remove team event.
class RemoveTeamEvent extends AliasPreGameEvent {
  final int index;

  const RemoveTeamEvent(this.index);
}
