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
  String get settings_players => 'Players';

  @override
  String get settings_spies => 'Spies';

  @override
  String unit_min(int count) {
    return '$count min';
  }

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
  String get teams => 'Teams';

  @override
  String team_with_count(int number) {
    return 'Team $number';
  }

  @override
  String get alias => 'Alias';

  @override
  String get oneWordMode => 'One word';

  @override
  String get classicModeShort => 'Classic';

  @override
  String get oneWordModeShort => 'One Word';

  @override
  String get spyMode => 'Spy';

  @override
  String get sudoku => 'Sudoku';

  @override
  String get sudoku_solved => 'Puzzle solved. Well done!';

  @override
  String get sudoku_difficulty => 'Difficulty';

  @override
  String get sudoku_difficulty_easy => 'Easy';

  @override
  String get sudoku_difficulty_medium => 'Medium';

  @override
  String get sudoku_difficulty_hard => 'Hard';

  @override
  String get sudoku_difficulty_expert => 'Expert';

  @override
  String get sudoku_difficulty_extreme => 'Extreme';

  @override
  String get sudoku_best_time => 'Best time';

  @override
  String get sudoku_new_record => 'New record!';

  @override
  String get sudoku_new_game => 'New game';

  @override
  String get sudoku_show_timer => 'Timer';

  @override
  String get sudoku_your_time => 'Your time:';

  @override
  String get sudoku_board_has_mistakes =>
      'The board is full, but something is not right';

  @override
  String get sudoku_game_over => 'Game over';

  @override
  String sudoku_out_of_mistakes(int count) {
    return 'You\'ve made $count mistakes';
  }

  @override
  String get retry => 'Retry';

  @override
  String player_with_number(int number) {
    return 'Player $number';
  }

  @override
  String get spy_tap_to_reveal => 'Tap the card to see your role';

  @override
  String get spy_you_are_spy => 'You are the SPY!';

  @override
  String get spy_dont_reveal => 'Blend in and try to guess the secret word';

  @override
  String get spy_secret_word => 'The secret word';

  @override
  String get spy_tap_to_hide => 'Tap again to hide and pass';

  @override
  String get spy_start_game => 'Start game';

  @override
  String get spy_all_ready => 'Everyone is ready';

  @override
  String get spy_find_the_spy => 'Take turns asking questions to find the spy.';

  @override
  String get play_again => 'Play again';

  @override
  String get change_pack => 'Change pack';

  @override
  String get game_rules => 'Game Rules';

  @override
  String get singleModeRule1 =>
      'Focus on explaining a single word on the screen while your team tries to guess it';

  @override
  String get singleModeRule2 =>
      'You can skip a difficult word to keep moving, but it will cost your team one point';

  @override
  String get cardModeRule1 =>
      'View a list of words on a single card and explain them in whichever order you prefer';

  @override
  String get cardModeRule2 =>
      'Your team must correctly guess every word on the list before the next card appears';

  @override
  String get generalRule1 =>
      'Every correctly guessed word earns your team exactly one point';

  @override
  String get generalRule2 =>
      'Use synonyms, antonyms, and creative descriptions to guide your team to the answer';

  @override
  String get generalRule3 =>
      'Never use translations, root words, spell by letters, or point to objects in the room';

  @override
  String get cardModeRule1Title => 'List of Words';

  @override
  String get cardModeRule2Title => 'Clear the Card';

  @override
  String get singleModeRule1Title => 'One at a Time';

  @override
  String get singleModeRule2Title => 'Skip Penalties';

  @override
  String get generalRule1Title => 'Earn Points';

  @override
  String get generalRule2Title => 'How to Explain';

  @override
  String get generalRule3Title => 'Strictly Banned';

  @override
  String get spyRule1 =>
      'Most players receive the exact same secret word while the hidden spies see nothing';

  @override
  String get spyRule2 =>
      'Take turns asking another player an open-ended or yes/no question about the word';

  @override
  String get spyRule3 =>
      'Alternatively, play by taking turns saying a word or phrase related to the secret word';

  @override
  String get spyRule4 =>
      'Make your clues specific enough to prove your innocence but vague enough to confuse the spy';

  @override
  String get spyRule5 =>
      'The spy must listen carefully to fake their way through the round and guess the word';

  @override
  String get spyRule6 =>
      'When time runs out, everyone discusses the clues and votes on who they believe the spy is';

  @override
  String get spyRule1Title => 'The Secret Word';

  @override
  String get spyRule2Title => 'Ask a Question';

  @override
  String get spyRule3Title => 'Drop a Hint';

  @override
  String get spyRule4Title => 'Keep It Vague';

  @override
  String get spyRule5Title => 'Blend In';

  @override
  String get spyRule6Title => 'Cast Your Vote';

  @override
  String get sudokuRule1 =>
      'Fill every row, column, and 3×3 box with the numbers 1 through 9 without any repeats';

  @override
  String get sudokuRule2 =>
      'Tap an empty cell and choose a number to place it while the row and column highlight';

  @override
  String get sudokuRule3 =>
      'Wrong numbers appear in red, and making three mistakes will end your game';

  @override
  String get sudokuRule4 =>
      'Turn on the pencil tool to write small notes and track possible numbers in a cell';

  @override
  String get sudokuRule5 =>
      'Use the undo button to cancel your last move or the erase tool to clear a cell';

  @override
  String get sudokuRule6 =>
      'Harder levels start with fewer given numbers — race to beat your best time';

  @override
  String get sudokuRule1Title => 'Fill the Grid';

  @override
  String get sudokuRule2Title => 'Place a Number';

  @override
  String get sudokuRule3Title => 'Three Lives';

  @override
  String get sudokuRule4Title => 'Take Notes';

  @override
  String get sudokuRule5Title => 'Undo and Erase';

  @override
  String get sudokuRule6Title => 'Choose a Level';

  @override
  String get rules_next => 'Next';

  @override
  String get rules_got_it => 'Got it';

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
  String get errorEmptyTeamNames =>
      'Wait, who\'s playing? Enter all team names!';

  @override
  String get feedback => 'Feedback';

  @override
  String get feedback_email_error =>
      'No email app found. Please send feedback to bardak.support@gmail.com';

  @override
  String get rateApp => 'Rate Us';

  @override
  String get rateApp_error =>
      'Oops! We couldn\'t open the App Store right now.';
}
