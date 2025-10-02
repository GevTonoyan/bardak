// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get settings______________________________________________ =>
      'settings----------------------------------------------------------------------';

  @override
  String get settings => 'Settings';

  @override
  String get app_settings => 'App Settings';

  @override
  String get settings_darkMode => 'Dark Mode';

  @override
  String get settings_localeName => 'English';

  @override
  String get settings_localeArmenian => 'Հայերեն';

  @override
  String get settings_localeRussian => 'Русский';

  @override
  String get settings_localeEnglish => 'English';

  @override
  String get alias________________________________________________ =>
      'alias----------------------------------------------------------------------';

  @override
  String get mode1 => 'Single Word';

  @override
  String get mode2 => 'Card Mode';

  @override
  String get singleWordMode => 'Single Word Mode';

  @override
  String get selectMode => 'Select Game Mode';

  @override
  String get wordPack => 'Word Pack';

  @override
  String get round => 'Round';

  @override
  String get rulesTitle => 'Rules';

  @override
  String get singleModeRule1 => 'One player explains a single word at a time.';

  @override
  String get singleModeRule2 =>
      'The team tries to guess as many words as possible before the timer runs out.';

  @override
  String get singleModeRule3 =>
      'The explainer cannot use the word itself, any part of it, a translation, a rhyme, or spelling hints.';

  @override
  String get singleModeRule4 =>
      'Teammates can guess as many times as they want.';

  @override
  String get singleModeRule5 => 'When guessed correctly, a new word appears.';

  @override
  String get singleModeRule6 =>
      'If the word is skipped, 1 point is deducted (can be changed in settings).';

  @override
  String get cardModeRule1 =>
      'The explainer receives a card with multiple words (usually 5–7).';

  @override
  String get cardModeRule2 =>
      'All words on the card must be guessed before the timer runs out.';

  @override
  String get cardModeRule3 => 'Players can guess the words in any order.';

  @override
  String get cardModeRule4 =>
      'Skipping is not allowed — you must guess every word on the card.';

  @override
  String get cardModeRule5 =>
      'The explainer cannot use the word itself, any part of it, a translation, a rhyme, or spelling hints.';

  @override
  String get cardModeRule6 => 'Score is based on the number guessed words';

  @override
  String get settings_general => 'General';

  @override
  String get settings_roundDuration => 'Round Duration (sec)';

  @override
  String get settings_pointsToWin => 'Points to Win';

  @override
  String get settings_soundEffects => 'Sound Effects';

  @override
  String get settings_allowSkipping => 'Allow Skipping';

  @override
  String get settings_penaltyForSkipping => 'Penalty for Skipping';

  @override
  String get settings_wordsPerCard => 'Words per Card';

  @override
  String get settings_reset => 'Reset Settings';

  @override
  String get word_packs_fail => 'Failed to load word packs';

  @override
  String get failedLoadWords => 'Couldn\'t load words';

  @override
  String get preGameTitle => 'Get Ready';

  @override
  String get preGameTeamSetup => 'Team Setup';

  @override
  String get preGameTeam => 'Team';

  @override
  String get preGameAddTeam => 'Add Team';

  @override
  String roundOverview_teamTurn(Object teamName) {
    return 'It\'s $teamName\'s turn!';
  }

  @override
  String roundOverview_point(num points) {
    String _temp0 = intl.Intl.pluralLogic(
      points,
      locale: localeName,
      other: '$points points',
      one: '$points point',
    );
    return '$_temp0';
  }

  @override
  String get roundOverview_roundScores => 'Round Scores:';

  @override
  String get roundOverview_confirmExit_title => 'Exit Game?';

  @override
  String get roundOverview_confirmExit_message =>
      'If you close this screen, all game progress will be lost. Are you sure you want to exit?';

  @override
  String get countdown_go => 'Go!';

  @override
  String get general________________________________________________ =>
      'general----------------------------------------------------------------------';

  @override
  String get general_startGame => 'Start Game';

  @override
  String get general_checkInternet => 'Check your internet connection';

  @override
  String get general_tryAgain => 'Try Again';

  @override
  String get general_yes => 'Yes';

  @override
  String get general_no => 'No';
}
