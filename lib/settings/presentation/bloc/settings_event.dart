import 'package:boardify/localizations/common/supported_locales.dart';

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
  const ChangeTheme({required this.isDarkMode});

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
  const ChangeGameDuration({required this.gameDuration, this.persist = true});

  /// The new game duration in seconds.
  final int gameDuration;

  /// Determines if the new value should be saved in the Shared Preferences.
  final bool persist;
}

class ChangePointsToWin extends SettingsEvent {
  const ChangePointsToWin({required this.pointsToWin, this.persist = true});

  /// The new points to win value.
  final int pointsToWin;

  /// Determines if the new value should be saved in the Shared Preferences.
  final bool persist;
}

class ChangeSoundEffects extends SettingsEvent {
  const ChangeSoundEffects({required this.soundEffects});

  final bool soundEffects;
}

class ChangeAllowSkipping extends SettingsEvent {
  const ChangeAllowSkipping({required this.allowSkipping});

  final bool allowSkipping;
}

class ChangePenaltyForSkipping extends SettingsEvent {
  const ChangePenaltyForSkipping({required this.penaltyForSkipping});

  final bool penaltyForSkipping;
}

class ChangeWordsPerCard extends SettingsEvent {
  const ChangeWordsPerCard({required this.wordsPerCard, this.persist = true});

  /// The new number of words per card.
  final int wordsPerCard;

  /// Determines if the new value should be saved in the Shared Preferences.
  final bool persist;
}
