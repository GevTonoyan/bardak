import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_am.dart';
import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('am'),
    Locale('en'),
    Locale('ru'),
  ];

  /// No description provided for @appVersion.
  ///
  /// In en, this message translates to:
  /// **'App version'**
  String get appVersion;

  /// No description provided for @proceed.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get proceed;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @correct.
  ///
  /// In en, this message translates to:
  /// **'Correct'**
  String get correct;

  /// No description provided for @review.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get review;

  /// No description provided for @unit_sec.
  ///
  /// In en, this message translates to:
  /// **'{count} sec'**
  String unit_sec(int count);

  /// No description provided for @unit_pts.
  ///
  /// In en, this message translates to:
  /// **'{count} pts'**
  String unit_pts(int count);

  /// No description provided for @points_value.
  ///
  /// In en, this message translates to:
  /// **'{value} pts'**
  String points_value(String value);

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @settings_localeArmenian.
  ///
  /// In en, this message translates to:
  /// **'Հայերեն'**
  String get settings_localeArmenian;

  /// No description provided for @settings_localeRussian.
  ///
  /// In en, this message translates to:
  /// **'Русский'**
  String get settings_localeRussian;

  /// No description provided for @settings_localeEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get settings_localeEnglish;

  /// No description provided for @settings_game_mode.
  ///
  /// In en, this message translates to:
  /// **'Game Mode'**
  String get settings_game_mode;

  /// No description provided for @settings_round_time.
  ///
  /// In en, this message translates to:
  /// **'Round Time'**
  String get settings_round_time;

  /// No description provided for @settings_players.
  ///
  /// In en, this message translates to:
  /// **'Players'**
  String get settings_players;

  /// No description provided for @settings_spies.
  ///
  /// In en, this message translates to:
  /// **'Spies'**
  String get settings_spies;

  /// No description provided for @unit_min.
  ///
  /// In en, this message translates to:
  /// **'{count} min'**
  String unit_min(int count);

  /// No description provided for @settings_points_to_win.
  ///
  /// In en, this message translates to:
  /// **'Points to Win'**
  String get settings_points_to_win;

  /// No description provided for @settings_allow_skipping.
  ///
  /// In en, this message translates to:
  /// **'Allow Skipping'**
  String get settings_allow_skipping;

  /// No description provided for @themes.
  ///
  /// In en, this message translates to:
  /// **'Themes'**
  String get themes;

  /// No description provided for @theme_main.
  ///
  /// In en, this message translates to:
  /// **'Main'**
  String get theme_main;

  /// No description provided for @theme_purple.
  ///
  /// In en, this message translates to:
  /// **'Purple'**
  String get theme_purple;

  /// No description provided for @theme_yellow.
  ///
  /// In en, this message translates to:
  /// **'Yellow'**
  String get theme_yellow;

  /// No description provided for @theme_blue.
  ///
  /// In en, this message translates to:
  /// **'Blue'**
  String get theme_blue;

  /// No description provided for @theme_green.
  ///
  /// In en, this message translates to:
  /// **'Green'**
  String get theme_green;

  /// No description provided for @theme_pink.
  ///
  /// In en, this message translates to:
  /// **'Pink'**
  String get theme_pink;

  /// No description provided for @theme_red.
  ///
  /// In en, this message translates to:
  /// **'Red'**
  String get theme_red;

  /// No description provided for @theme_turquoise.
  ///
  /// In en, this message translates to:
  /// **'Turquoise'**
  String get theme_turquoise;

  /// No description provided for @theme_orange.
  ///
  /// In en, this message translates to:
  /// **'Orange'**
  String get theme_orange;

  /// No description provided for @theme_brown.
  ///
  /// In en, this message translates to:
  /// **'Brown'**
  String get theme_brown;

  /// No description provided for @theme_navy.
  ///
  /// In en, this message translates to:
  /// **'Navy Blue'**
  String get theme_navy;

  /// No description provided for @theme_mint.
  ///
  /// In en, this message translates to:
  /// **'Mint Green'**
  String get theme_mint;

  /// No description provided for @theme_plum.
  ///
  /// In en, this message translates to:
  /// **'Plum'**
  String get theme_plum;

  /// No description provided for @theme_dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get theme_dark;

  /// No description provided for @theme_grey.
  ///
  /// In en, this message translates to:
  /// **'Grey'**
  String get theme_grey;

  /// No description provided for @languages.
  ///
  /// In en, this message translates to:
  /// **'Languages'**
  String get languages;

  /// No description provided for @sounds.
  ///
  /// In en, this message translates to:
  /// **'Sounds'**
  String get sounds;

  /// No description provided for @teams.
  ///
  /// In en, this message translates to:
  /// **'Teams'**
  String get teams;

  /// No description provided for @team_with_count.
  ///
  /// In en, this message translates to:
  /// **'Team {number}'**
  String team_with_count(int number);

  /// No description provided for @alias.
  ///
  /// In en, this message translates to:
  /// **'Alias'**
  String get alias;

  /// No description provided for @oneWordMode.
  ///
  /// In en, this message translates to:
  /// **'One word'**
  String get oneWordMode;

  /// No description provided for @classicModeShort.
  ///
  /// In en, this message translates to:
  /// **'Classic'**
  String get classicModeShort;

  /// No description provided for @oneWordModeShort.
  ///
  /// In en, this message translates to:
  /// **'One Word'**
  String get oneWordModeShort;

  /// No description provided for @spyMode.
  ///
  /// In en, this message translates to:
  /// **'Spy'**
  String get spyMode;

  /// No description provided for @sudoku.
  ///
  /// In en, this message translates to:
  /// **'Sudoku'**
  String get sudoku;

  /// No description provided for @sudoku_solved.
  ///
  /// In en, this message translates to:
  /// **'Puzzle solved. Well done!'**
  String get sudoku_solved;

  /// No description provided for @sudoku_difficulty.
  ///
  /// In en, this message translates to:
  /// **'Difficulty'**
  String get sudoku_difficulty;

  /// No description provided for @sudoku_difficulty_easy.
  ///
  /// In en, this message translates to:
  /// **'Easy'**
  String get sudoku_difficulty_easy;

  /// No description provided for @sudoku_difficulty_medium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get sudoku_difficulty_medium;

  /// No description provided for @sudoku_difficulty_hard.
  ///
  /// In en, this message translates to:
  /// **'Hard'**
  String get sudoku_difficulty_hard;

  /// No description provided for @sudoku_difficulty_expert.
  ///
  /// In en, this message translates to:
  /// **'Expert'**
  String get sudoku_difficulty_expert;

  /// No description provided for @sudoku_difficulty_extreme.
  ///
  /// In en, this message translates to:
  /// **'Extreme'**
  String get sudoku_difficulty_extreme;

  /// No description provided for @sudoku_best_time.
  ///
  /// In en, this message translates to:
  /// **'Best time'**
  String get sudoku_best_time;

  /// No description provided for @sudoku_new_record.
  ///
  /// In en, this message translates to:
  /// **'New record!'**
  String get sudoku_new_record;

  /// No description provided for @sudoku_new_game.
  ///
  /// In en, this message translates to:
  /// **'New game'**
  String get sudoku_new_game;

  /// No description provided for @sudoku_show_timer.
  ///
  /// In en, this message translates to:
  /// **'Timer'**
  String get sudoku_show_timer;

  /// No description provided for @sudoku_your_time.
  ///
  /// In en, this message translates to:
  /// **'Your time:'**
  String get sudoku_your_time;

  /// No description provided for @sudoku_board_has_mistakes.
  ///
  /// In en, this message translates to:
  /// **'The board is full, but something is not right'**
  String get sudoku_board_has_mistakes;

  /// No description provided for @sudoku_game_over.
  ///
  /// In en, this message translates to:
  /// **'Game over'**
  String get sudoku_game_over;

  /// No description provided for @sudoku_out_of_mistakes.
  ///
  /// In en, this message translates to:
  /// **'You\'ve made {count} mistakes'**
  String sudoku_out_of_mistakes(int count);

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @player_with_number.
  ///
  /// In en, this message translates to:
  /// **'Player {number}'**
  String player_with_number(int number);

  /// No description provided for @spy_tap_to_reveal.
  ///
  /// In en, this message translates to:
  /// **'Tap the card to see your role'**
  String get spy_tap_to_reveal;

  /// No description provided for @spy_you_are_spy.
  ///
  /// In en, this message translates to:
  /// **'You are the SPY!'**
  String get spy_you_are_spy;

  /// No description provided for @spy_dont_reveal.
  ///
  /// In en, this message translates to:
  /// **'Blend in and try to guess the secret word'**
  String get spy_dont_reveal;

  /// No description provided for @spy_secret_word.
  ///
  /// In en, this message translates to:
  /// **'The secret word'**
  String get spy_secret_word;

  /// No description provided for @spy_tap_to_hide.
  ///
  /// In en, this message translates to:
  /// **'Tap again to hide and pass'**
  String get spy_tap_to_hide;

  /// No description provided for @spy_start_game.
  ///
  /// In en, this message translates to:
  /// **'Start game'**
  String get spy_start_game;

  /// No description provided for @spy_all_ready.
  ///
  /// In en, this message translates to:
  /// **'Everyone is ready'**
  String get spy_all_ready;

  /// No description provided for @spy_find_the_spy.
  ///
  /// In en, this message translates to:
  /// **'Take turns asking questions to find the spy.'**
  String get spy_find_the_spy;

  /// No description provided for @spy_new_pack.
  ///
  /// In en, this message translates to:
  /// **'New pack'**
  String get spy_new_pack;

  /// No description provided for @spy_create_pack.
  ///
  /// In en, this message translates to:
  /// **'Create pack'**
  String get spy_create_pack;

  /// No description provided for @spy_edit_pack.
  ///
  /// In en, this message translates to:
  /// **'Edit pack'**
  String get spy_edit_pack;

  /// No description provided for @spy_pack_name.
  ///
  /// In en, this message translates to:
  /// **'Pack name'**
  String get spy_pack_name;

  /// No description provided for @spy_words.
  ///
  /// In en, this message translates to:
  /// **'Words'**
  String get spy_words;

  /// No description provided for @spy_min_words.
  ///
  /// In en, this message translates to:
  /// **'Add at least {count} words to save'**
  String spy_min_words(int count);

  /// No description provided for @spy_save_pack.
  ///
  /// In en, this message translates to:
  /// **'Save pack'**
  String get spy_save_pack;

  /// No description provided for @spy_delete_pack.
  ///
  /// In en, this message translates to:
  /// **'Delete pack'**
  String get spy_delete_pack;

  /// No description provided for @spy_delete_pack_confirm.
  ///
  /// In en, this message translates to:
  /// **'Delete this pack? This can\'t be undone.'**
  String get spy_delete_pack_confirm;

  /// No description provided for @play_again.
  ///
  /// In en, this message translates to:
  /// **'Play again'**
  String get play_again;

  /// No description provided for @change_pack.
  ///
  /// In en, this message translates to:
  /// **'Change pack'**
  String get change_pack;

  /// No description provided for @game_rules.
  ///
  /// In en, this message translates to:
  /// **'Game Rules'**
  String get game_rules;

  /// No description provided for @singleModeRule1.
  ///
  /// In en, this message translates to:
  /// **'Focus on explaining a single word on the screen while your team tries to guess it'**
  String get singleModeRule1;

  /// No description provided for @singleModeRule2.
  ///
  /// In en, this message translates to:
  /// **'You can skip a difficult word to keep moving, but it will cost your team one point'**
  String get singleModeRule2;

  /// No description provided for @cardModeRule1.
  ///
  /// In en, this message translates to:
  /// **'View a list of words on a single card and explain them in whichever order you prefer'**
  String get cardModeRule1;

  /// No description provided for @cardModeRule2.
  ///
  /// In en, this message translates to:
  /// **'Your team must correctly guess every word on the list before the next card appears'**
  String get cardModeRule2;

  /// No description provided for @generalRule1.
  ///
  /// In en, this message translates to:
  /// **'Every correctly guessed word earns your team exactly one point'**
  String get generalRule1;

  /// No description provided for @generalRule2.
  ///
  /// In en, this message translates to:
  /// **'Use synonyms, antonyms, and creative descriptions to guide your team to the answer'**
  String get generalRule2;

  /// No description provided for @generalRule3.
  ///
  /// In en, this message translates to:
  /// **'Never use translations, root words, spell by letters, or point to objects in the room'**
  String get generalRule3;

  /// No description provided for @cardModeRule1Title.
  ///
  /// In en, this message translates to:
  /// **'List of Words'**
  String get cardModeRule1Title;

  /// No description provided for @cardModeRule2Title.
  ///
  /// In en, this message translates to:
  /// **'Clear the Card'**
  String get cardModeRule2Title;

  /// No description provided for @singleModeRule1Title.
  ///
  /// In en, this message translates to:
  /// **'One at a Time'**
  String get singleModeRule1Title;

  /// No description provided for @singleModeRule2Title.
  ///
  /// In en, this message translates to:
  /// **'Skip Penalties'**
  String get singleModeRule2Title;

  /// No description provided for @generalRule1Title.
  ///
  /// In en, this message translates to:
  /// **'Earn Points'**
  String get generalRule1Title;

  /// No description provided for @generalRule2Title.
  ///
  /// In en, this message translates to:
  /// **'How to Explain'**
  String get generalRule2Title;

  /// No description provided for @generalRule3Title.
  ///
  /// In en, this message translates to:
  /// **'Strictly Banned'**
  String get generalRule3Title;

  /// No description provided for @spyRule1.
  ///
  /// In en, this message translates to:
  /// **'Most players receive the exact same secret word while the hidden spies see nothing'**
  String get spyRule1;

  /// No description provided for @spyRule2.
  ///
  /// In en, this message translates to:
  /// **'Take turns asking another player an open-ended or yes/no question about the word'**
  String get spyRule2;

  /// No description provided for @spyRule3.
  ///
  /// In en, this message translates to:
  /// **'Alternatively, play by taking turns saying a word or phrase related to the secret word'**
  String get spyRule3;

  /// No description provided for @spyRule4.
  ///
  /// In en, this message translates to:
  /// **'Make your clues specific enough to prove your innocence but vague enough to confuse the spy'**
  String get spyRule4;

  /// No description provided for @spyRule5.
  ///
  /// In en, this message translates to:
  /// **'The spy must listen carefully to fake their way through the round and guess the word'**
  String get spyRule5;

  /// No description provided for @spyRule6.
  ///
  /// In en, this message translates to:
  /// **'When time runs out, everyone discusses the clues and votes on who they believe the spy is'**
  String get spyRule6;

  /// No description provided for @spyRule1Title.
  ///
  /// In en, this message translates to:
  /// **'The Secret Word'**
  String get spyRule1Title;

  /// No description provided for @spyRule2Title.
  ///
  /// In en, this message translates to:
  /// **'Ask a Question'**
  String get spyRule2Title;

  /// No description provided for @spyRule3Title.
  ///
  /// In en, this message translates to:
  /// **'Drop a Hint'**
  String get spyRule3Title;

  /// No description provided for @spyRule4Title.
  ///
  /// In en, this message translates to:
  /// **'Keep It Vague'**
  String get spyRule4Title;

  /// No description provided for @spyRule5Title.
  ///
  /// In en, this message translates to:
  /// **'Blend In'**
  String get spyRule5Title;

  /// No description provided for @spyRule6Title.
  ///
  /// In en, this message translates to:
  /// **'Cast Your Vote'**
  String get spyRule6Title;

  /// No description provided for @sudokuRule1.
  ///
  /// In en, this message translates to:
  /// **'Fill every row, column, and 3×3 box with the numbers 1 through 9 without any repeats'**
  String get sudokuRule1;

  /// No description provided for @sudokuRule2.
  ///
  /// In en, this message translates to:
  /// **'Tap an empty cell and choose a number to place it while the row and column highlight'**
  String get sudokuRule2;

  /// No description provided for @sudokuRule3.
  ///
  /// In en, this message translates to:
  /// **'Wrong numbers appear in red, and making three mistakes will end your game'**
  String get sudokuRule3;

  /// No description provided for @sudokuRule4.
  ///
  /// In en, this message translates to:
  /// **'Turn on the pencil tool to write small notes and track possible numbers in a cell'**
  String get sudokuRule4;

  /// No description provided for @sudokuRule5.
  ///
  /// In en, this message translates to:
  /// **'Use the undo button to cancel your last move or the erase tool to clear a cell'**
  String get sudokuRule5;

  /// No description provided for @sudokuRule6.
  ///
  /// In en, this message translates to:
  /// **'Harder levels start with fewer given numbers — race to beat your best time'**
  String get sudokuRule6;

  /// No description provided for @sudokuRule1Title.
  ///
  /// In en, this message translates to:
  /// **'Fill the Grid'**
  String get sudokuRule1Title;

  /// No description provided for @sudokuRule2Title.
  ///
  /// In en, this message translates to:
  /// **'Place a Number'**
  String get sudokuRule2Title;

  /// No description provided for @sudokuRule3Title.
  ///
  /// In en, this message translates to:
  /// **'Three Lives'**
  String get sudokuRule3Title;

  /// No description provided for @sudokuRule4Title.
  ///
  /// In en, this message translates to:
  /// **'Take Notes'**
  String get sudokuRule4Title;

  /// No description provided for @sudokuRule5Title.
  ///
  /// In en, this message translates to:
  /// **'Undo and Erase'**
  String get sudokuRule5Title;

  /// No description provided for @sudokuRule6Title.
  ///
  /// In en, this message translates to:
  /// **'Choose a Level'**
  String get sudokuRule6Title;

  /// No description provided for @rules_next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get rules_next;

  /// No description provided for @rules_got_it.
  ///
  /// In en, this message translates to:
  /// **'Got it'**
  String get rules_got_it;

  /// No description provided for @scoreboard.
  ///
  /// In en, this message translates to:
  /// **'Score'**
  String get scoreboard;

  /// No description provided for @next_team.
  ///
  /// In en, this message translates to:
  /// **'Next team'**
  String get next_team;

  /// No description provided for @winner_reveal.
  ///
  /// In en, this message translates to:
  /// **'And the winner is...'**
  String get winner_reveal;

  /// No description provided for @no_words_left_error.
  ///
  /// In en, this message translates to:
  /// **'Sorry, words are finished. You can try with another topic.'**
  String get no_words_left_error;

  /// No description provided for @downloadWordsNetworkError.
  ///
  /// In en, this message translates to:
  /// **'You need to download the words first. Please check your internet connection and try again.'**
  String get downloadWordsNetworkError;

  /// No description provided for @exit_game_title.
  ///
  /// In en, this message translates to:
  /// **'Leave the game?'**
  String get exit_game_title;

  /// No description provided for @exit_game_description.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to finish the current game?'**
  String get exit_game_description;

  /// No description provided for @exit_game_confirm.
  ///
  /// In en, this message translates to:
  /// **'Yes, leave'**
  String get exit_game_confirm;

  /// No description provided for @round_stop_title.
  ///
  /// In en, this message translates to:
  /// **'Finish Round?'**
  String get round_stop_title;

  /// No description provided for @round_stop_description.
  ///
  /// In en, this message translates to:
  /// **'Stop the timer and see results? Your points will be saved.'**
  String get round_stop_description;

  /// No description provided for @round_stop_confirm.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get round_stop_confirm;

  /// No description provided for @round_stop_resume.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get round_stop_resume;

  /// No description provided for @errorEmptyTeamNames.
  ///
  /// In en, this message translates to:
  /// **'Wait, who\'s playing? Enter all team names!'**
  String get errorEmptyTeamNames;

  /// No description provided for @feedback.
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get feedback;

  /// No description provided for @feedback_email_error.
  ///
  /// In en, this message translates to:
  /// **'No email app found. Please send feedback to bardak.support@gmail.com'**
  String get feedback_email_error;

  /// No description provided for @rateApp.
  ///
  /// In en, this message translates to:
  /// **'Rate Us'**
  String get rateApp;

  /// No description provided for @rateApp_error.
  ///
  /// In en, this message translates to:
  /// **'Oops! We couldn\'t open the App Store right now.'**
  String get rateApp_error;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['am', 'en', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'am':
      return AppLocalizationsAm();
    case 'en':
      return AppLocalizationsEn();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
