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
  String get back => 'Back';

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
  String all_words_count(int count) {
    return 'All words · $count';
  }

  @override
  String easy_words_count(int count) {
    return 'Easy words · $count';
  }

  @override
  String get spyMode => 'Spy';

  @override
  String get sudoku => 'Sudoku';

  @override
  String get sudoku_solved => 'Puzzle solved. Well done!';

  @override
  String get sudoku_board_size => 'Board size';

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
  String get seaBattle => 'Sea Battle';

  @override
  String get sea_battle_mode => 'Mode';

  @override
  String get sea_battle_mode_solo => 'Solo';

  @override
  String get sea_battle_mode_online => 'Online';

  @override
  String get sea_battle_bot_difficulty => 'Bot level';

  @override
  String get sea_battle_difficulty_easy => 'Easy';

  @override
  String get sea_battle_difficulty_medium => 'Medium';

  @override
  String get sea_battle_difficulty_hard => 'Hard';

  @override
  String get sea_battle_place_ships => 'Place your ships';

  @override
  String get sea_battle_placement_hint =>
      'Drag ships onto the board. Tap a ship to rotate it';

  @override
  String get sea_battle_shuffle => 'Shuffle';

  @override
  String get sea_battle_start => 'Start';

  @override
  String get sea_battle_ready => 'Ready';

  @override
  String get sea_battle_leave => 'Leave';

  @override
  String get sea_battle_your_turn => 'Your turn';

  @override
  String get sea_battle_opponent_turn => 'Opponent\'s turn';

  @override
  String get sea_battle_enemy_fleet => 'Enemy fleet';

  @override
  String get sea_battle_victory => 'Victory!';

  @override
  String get sea_battle_defeat => 'Defeat';

  @override
  String get sea_battle_victory_subtitle => 'You sank the whole enemy fleet';

  @override
  String get sea_battle_defeat_subtitle => 'The enemy sank your fleet';

  @override
  String get sea_battle_accuracy => 'Accuracy';

  @override
  String get sea_battle_shots => 'Shots';

  @override
  String get sea_battle_hits => 'Hits';

  @override
  String get sea_battle_ships_sunk => 'Sunk';

  @override
  String get sea_battle_ships_lost => 'Lost';

  @override
  String get sea_battle_invite_title => 'Invite a friend';

  @override
  String get sea_battle_invite_hint =>
      'Let your friend scan this code with their phone camera, or send them the link';

  @override
  String get sea_battle_creating_room => 'Creating a room…';

  @override
  String get sea_battle_connection_error => 'No connection. Try again';

  @override
  String get sea_battle_waiting_for_opponent => 'Waiting for your opponent';

  @override
  String get sea_battle_you_are_ready => 'You\'re ready!';

  @override
  String get sea_battle_waiting_for_opponent_ships =>
      'Waiting for your opponent to place their ships';

  @override
  String get sea_battle_share => 'Share';

  @override
  String get sea_battle_link_copied => 'Link copied';

  @override
  String get sea_battle_join_title => 'Join a game';

  @override
  String get sea_battle_joining => 'Joining your friend\'s game…';

  @override
  String get sea_battle_room_not_found =>
      'This game is over or the link is wrong. Ask your friend for a new link';

  @override
  String get sea_battle_room_full =>
      'Someone else has already joined this game';

  @override
  String get sea_battle_join_invite_title => 'Join your friend\'s game?';

  @override
  String get sea_battle_join_invite_description =>
      'You\'ll leave the current screen';

  @override
  String get sea_battle_join => 'Join';

  @override
  String get sea_battle_room_closed => 'The room was closed';

  @override
  String get sea_battle_opponent_left => 'Your friend left the battle';

  @override
  String get sea_battle_connection_lost => 'The connection was lost';

  @override
  String sea_battle_share_message(String link) {
    return 'Join my Sea Battle game in Bardak! $link';
  }

  @override
  String get sea_battle_rule_1_title => 'Build Your Fleet';

  @override
  String get sea_battle_rule_1 =>
      'Each player has 10 ships: one of 4 cells, two of 3, three of 2 and four of 1';

  @override
  String get sea_battle_rule_2_title => 'Keep Your Distance';

  @override
  String get sea_battle_rule_2 =>
      'Ships can\'t touch each other, not even at the corners';

  @override
  String get sea_battle_rule_3_title => 'Take Your Shot';

  @override
  String get sea_battle_rule_3 =>
      'Take turns tapping a cell on your opponent\'s board. A dot marks a miss';

  @override
  String get sea_battle_rule_4_title => 'Hit and Shoot Again';

  @override
  String get sea_battle_rule_4 =>
      'Hit a ship and you shoot again, until you miss';

  @override
  String get sea_battle_rule_5_title => 'Sink the Ship';

  @override
  String get sea_battle_rule_5 =>
      'Hit every cell of a ship to sink it. The cells around it are marked for you';

  @override
  String get sea_battle_rule_6_title => 'Win the Battle';

  @override
  String get sea_battle_rule_6 =>
      'Sink the whole enemy fleet before they sink yours';

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
  String get spy_new_pack => 'New pack';

  @override
  String get spy_create_pack => 'Create pack';

  @override
  String get spy_edit_pack => 'Edit pack';

  @override
  String get spy_pack_name => 'Pack name';

  @override
  String get spy_words => 'Words';

  @override
  String spy_min_words(int count) {
    return 'Add at least $count words to save';
  }

  @override
  String get spy_save_pack => 'Save pack';

  @override
  String get spy_delete_pack => 'Delete pack';

  @override
  String get spy_delete_pack_confirm =>
      'Delete this pack? This can\'t be undone.';

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
