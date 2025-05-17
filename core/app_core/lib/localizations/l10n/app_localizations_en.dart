// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get games_________________________________________________ => 'games----------------------------------------------------------------------';

  @override
  String get games_availableGames => 'Available Games';

  @override
  String get games_aliasDescription => 'Guess words with your team';

  @override
  String get settings______________________________________________ => 'settings----------------------------------------------------------------------';

  @override
  String get settings => 'Settings';

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
  String get alias________________________________________________ => 'alias----------------------------------------------------------------------';

  @override
  String get alias_title => 'Alias';

  @override
  String get alias_mode1 => 'Single Word';

  @override
  String get alias_mode2 => 'Card Mode';

  @override
  String get alias_singleWordMode => 'Single Word Mode';

  @override
  String get alias_selectMode => 'Select Game Mode';

  @override
  String get alias_wordPack => 'Word Pack';

  @override
  String get alias_round => 'Round';

  @override
  String get alias_rulesTitle => 'Alias Rules';

  @override
  String get alias_singleModeRule1 => 'One player explains a single word at a time.';

  @override
  String get alias_singleModeRule2 => 'The team tries to guess as many words as possible before the timer runs out.';

  @override
  String get alias_singleModeRule3 => 'The explainer cannot use the word itself, any part of it, a translation, a rhyme, or spelling hints.';

  @override
  String get alias_singleModeRule4 => 'Teammates can guess as many times as they want.';

  @override
  String get alias_singleModeRule5 => 'When guessed correctly, a new word appears.';

  @override
  String get alias_singleModeRule6 => 'If the word is skipped, 1 point is deducted (can be changed in settings).';

  @override
  String get alias_cardModeRule1 => 'The explainer receives a card with multiple words (usually 5–7).';

  @override
  String get alias_cardModeRule2 => 'All words on the card must be guessed before the timer runs out.';

  @override
  String get alias_cardModeRule3 => 'Players can guess the words in any order.';

  @override
  String get alias_cardModeRule4 => 'Skipping is not allowed — you must guess every word on the card.';

  @override
  String get alias_cardModeRule5 => 'The explainer cannot use the word itself, any part of it, a translation, a rhyme, or spelling hints.';

  @override
  String get alias_cardModeRule6 => 'Score is based on the number guessed words';

  @override
  String get alias_settings => 'Alias Settings';

  @override
  String get alias_settings_general => 'General';

  @override
  String get alias_settings_roundDuration => 'Round Duration (sec)';

  @override
  String get alias_settings_pointsToWin => 'Points to Win';

  @override
  String get alias_settings_soundEffects => 'Sound Effects';

  @override
  String get alias_settings_allowSkipping => 'Allow Skipping';

  @override
  String get alias_settings_penaltyForSkipping => 'Penalty for Skipping';

  @override
  String get alias_settings_wordsPerCard => 'Words per Card';

  @override
  String get alias_settings_reset => 'Reset Settings';

  @override
  String get alias_word_packs_fail => 'Failed to load word packs';

  @override
  String get alias_failedLoadWords => 'Couldn\'t load words';

  @override
  String get alias_preGameTitle => 'Get Ready';

  @override
  String get alias_preGameTeamSetup => 'Team Setup';

  @override
  String get alias_preGameTeam => 'Team';

  @override
  String get alias_preGameAddTeam => 'Add Team';

  @override
  String alias_roundOverview_teamTurn(Object teamName) {
    return 'It\'s $teamName\'s turn!';
  }

  @override
  String alias_roundOverview_point(num points) {
    String _temp0 = intl.Intl.pluralLogic(
      points,
      locale: localeName,
      other: '$points points',
      one: '$points point',
    );
    return '$_temp0';
  }

  @override
  String get alias_roundOverview_roundScores => 'Round Scores:';

  @override
  String get general________________________________________________ => 'general----------------------------------------------------------------------';

  @override
  String get general_startGame => 'Start Game';

  @override
  String get general_checkInternet => 'Check your internet connection';

  @override
  String get general_tryAgain => 'Try Again';
}
