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
  String get review => 'Review';

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
  String get theme_turquoise => 'Turquoise';

  @override
  String get theme_orange => 'Orange';

  @override
  String get theme_brown => 'Brown';

  @override
  String get theme_navy => 'Navy Blue';

  @override
  String get theme_mint => 'Mint Green';

  @override
  String get theme_plum => 'Plum';

  @override
  String get theme_dark => 'Dark';

  @override
  String get theme_grey => 'Grey';

  @override
  String get languages => 'Languages';

  @override
  String get sounds => 'Sounds';

  @override
  String get rewards => 'Rewards';

  @override
  String get rewardsSelectThree => 'Select three';

  @override
  String rewards_success(int count) {
    return '+$count points! See you tomorrow.';
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
  String get singleModeRule1 =>
      'Players explain words one after another in sequence';

  @override
  String get singleModeRule2 =>
      'When a word is guessed correctly, the next word appears';

  @override
  String get singleModeRule3 =>
      'Skipping a word results in a one point penalty';

  @override
  String get cardModeRule1 =>
      'The explainer receives a card containing 6 words';

  @override
  String get cardModeRule2 =>
      'All words on the current card must be guessed before moving to the next one';

  @override
  String get cardModeRule3 =>
      'Players can explain words on the card in any order';

  @override
  String get generalRule1 =>
      'Using word roots, translations, or phonetic hints is prohibited';

  @override
  String get generalRule2 =>
      'After each round, players can review and edit the list of guessed words';

  @override
  String get generalRule3 =>
      'The game ends when the target score is reached, but all teams must complete the current round';

  @override
  String get scoreboard => 'Score';

  @override
  String get next_team => 'Next team';

  @override
  String get winner_reveal => 'And the winner is...';

  @override
  String get no_words_left_error =>
      'Sorry, words are finished. You can try with another topic.';

  @override
  String get downloadWordsNetworkError =>
      'You need to download the words first. Please check your internet connection and try again.';

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

  @override
  String get errorEmptyTeamNames =>
      'Wait, who\'s playing? Enter all team names!';

  @override
  String get feedback => 'Feedback';

  @override
  String get feedback_email_error =>
      'No email app found. Please send feedback to bardak.support@gmail.com';
}
