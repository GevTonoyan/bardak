/// Base class for all events related to alias settings.
sealed class AliasSettingsEvent {
  const AliasSettingsEvent();
}

class GetAliasSettings extends AliasSettingsEvent {
  const GetAliasSettings();
}

class ChangeGameDuration extends AliasSettingsEvent {
  /// The new game duration in seconds.
  final int gameDuration;

  /// Determines if the new value should be saved in the Shared Preferences.
  final bool persist;

  const ChangeGameDuration({required this.gameDuration, this.persist = true});
}

class ChangePointsToWin extends AliasSettingsEvent {
  /// The new points to win value.
  final int pointsToWin;

  /// Determines if the new value should be saved in the Shared Preferences.
  final bool persist;

  const ChangePointsToWin({required this.pointsToWin, this.persist = true});
}

class ChangeSoundEffects extends AliasSettingsEvent {
  final bool soundEffects;

  const ChangeSoundEffects(this.soundEffects);
}

class ChangeAllowSkipping extends AliasSettingsEvent {
  final bool allowSkipping;

  const ChangeAllowSkipping(this.allowSkipping);
}

class ChangePenaltyForSkipping extends AliasSettingsEvent {
  final bool penaltyForSkipping;

  const ChangePenaltyForSkipping(this.penaltyForSkipping);
}

class ChangeWordsPerCard extends AliasSettingsEvent {
  /// The new number of words per card.
  final int wordsPerCard;

  /// Determines if the new value should be saved in the Shared Preferences.
  final bool persist;

  const ChangeWordsPerCard({required this.wordsPerCard, this.persist = true});
}
