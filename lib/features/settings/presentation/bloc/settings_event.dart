import 'package:boardify/core/localizations/common/supported_locales.dart';

/// Base class for all events related to settings.
sealed class SettingsEvent {
  const SettingsEvent();
}

class GetSettings extends SettingsEvent {
  const GetSettings();
}

class GetAppSettings extends SettingsEvent {
  const GetAppSettings();
}

class ChangeTheme extends SettingsEvent {
  const ChangeTheme(this.isDarkMode);

  final bool isDarkMode;
}

class ChangeLocale extends SettingsEvent {
  const ChangeLocale(this.locale);

  final AppLocales locale;
}

class GetAliasSettings extends SettingsEvent {
  const GetAliasSettings();
}

class ChangeGameDuration extends SettingsEvent {
  /// The new game duration in seconds.
  final int gameDuration;

  /// Determines if the new value should be saved in the Shared Preferences.
  final bool persist;

  const ChangeGameDuration({required this.gameDuration, this.persist = true});
}

class ChangePointsToWin extends SettingsEvent {
  /// The new points to win value.
  final int pointsToWin;

  /// Determines if the new value should be saved in the Shared Preferences.
  final bool persist;

  const ChangePointsToWin({required this.pointsToWin, this.persist = true});
}

class ChangeSoundEffects extends SettingsEvent {
  final bool soundEffects;

  const ChangeSoundEffects(this.soundEffects);
}

class ChangeAllowSkipping extends SettingsEvent {
  final bool allowSkipping;

  const ChangeAllowSkipping(this.allowSkipping);
}

class ChangePenaltyForSkipping extends SettingsEvent {
  final bool penaltyForSkipping;

  const ChangePenaltyForSkipping(this.penaltyForSkipping);
}

class ChangeWordsPerCard extends SettingsEvent {
  /// The new number of words per card.
  final int wordsPerCard;

  /// Determines if the new value should be saved in the Shared Preferences.
  final bool persist;

  const ChangeWordsPerCard({required this.wordsPerCard, this.persist = true});
}
