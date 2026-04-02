// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appVersion => 'App version';

  @override
  String get proceed => 'Continue';

  @override
  String get cancel => 'Cancel';

  @override
  String get add => 'Add';

  @override
  String get skip => 'Skip';

  @override
  String get correct => 'Correct';

  @override
  String get check => 'Check';

  @override
  String unit_sec(int count) {
    return '$count sec';
  }

  @override
  String unit_pts(int count) {
    return '$count pts';
  }

  @override
  String points_value(String value) {
    return '$value pts';
  }

  @override
  String get settings => 'Settings';

  @override
  String get settings_localeArmenian => 'Հայերեն';

  @override
  String get settings_localeRussian => 'Русский';

  @override
  String get settings_localeEnglish => 'English';

  @override
  String get settings_game_mode => 'Game Mode';

  @override
  String get settings_round_time => 'Round Time';

  @override
  String get settings_points_to_win => 'Points to Win';

  @override
  String get settings_allow_skipping => 'Allow Skipping';

  @override
  String get themes => 'Themes';

  @override
  String get theme_main => 'Main';

  @override
  String get theme_purple => 'Purple';

  @override
  String get theme_yellow => 'Yellow';

  @override
  String get theme_blue => 'Blue';

  @override
  String get theme_green => 'Green';

  @override
  String get theme_pink => 'Pink';

  @override
  String get theme_red => 'Red';

  @override
  String get theme_black => 'Black';

  @override
  String get sounds => 'Sounds';

  @override
  String get rewards => 'Rewards';

  @override
  String get rewardsSelectThree => 'Select three';

  @override
  String rewards_success(int count) {
    return 'Awesome!\nYou got $count points';
  }

  @override
  String get teams => 'Teams';

  @override
  String team_with_count(int number) {
    return 'Team $number';
  }

  @override
  String get classicMode => 'Classic';

  @override
  String get oneWordMode => 'One Word';

  @override
  String get game_rules => 'Game Rules';

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
  String get cardModeRule6 => 'Score is based on the number of guessed words.';

  @override
  String get scoreboard => 'Scoreboard';

  @override
  String get next_team => 'Next team';

  @override
  String get winner_reveal => 'And the winner is...';

  @override
  String get no_words_left_error =>
      'Sorry, words are finished. You can try with another topic.';

  @override
  String get exit_game_title => 'Leave the game?';

  @override
  String get exit_game_description =>
      'Are you sure you want to finish the current game?';

  @override
  String get exit_game_confirm => 'Yes, leave';

  @override
  String get round_stop_title => 'Finish Round?';

  @override
  String get round_stop_description =>
      'Stop the timer and see results? Your points will be saved.';

  @override
  String get round_stop_confirm => 'Finish';

  @override
  String get round_stop_resume => 'Resume';

  @override
  String get unlock_theme_title => 'Unlock Theme';

  @override
  String get unlock_theme_description =>
      'Are you sure you want to unlock this theme and change the game\'s look?';

  @override
  String get unlock_theme_confirm => 'Unlock';

  @override
  String get not_enough_coins => 'Not enough coins';
}
