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

  /// No description provided for @rewards.
  ///
  /// In en, this message translates to:
  /// **'Rewards'**
  String get rewards;

  /// No description provided for @rewardsSelectThree.
  ///
  /// In en, this message translates to:
  /// **'Select three'**
  String get rewardsSelectThree;

  /// No description provided for @rewards_success.
  ///
  /// In en, this message translates to:
  /// **'+{count} points! See you tomorrow.'**
  String rewards_success(int count);

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
  /// **'Ask questions in turns and find the spy'**
  String get spy_find_the_spy;

  /// No description provided for @spy_finish_game.
  ///
  /// In en, this message translates to:
  /// **'Finish game'**
  String get spy_finish_game;

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
  /// **'Players explain words one after another in sequence'**
  String get singleModeRule1;

  /// No description provided for @singleModeRule2.
  ///
  /// In en, this message translates to:
  /// **'When a word is guessed correctly, the next word appears'**
  String get singleModeRule2;

  /// No description provided for @singleModeRule3.
  ///
  /// In en, this message translates to:
  /// **'Skipping a word results in a one point penalty'**
  String get singleModeRule3;

  /// No description provided for @cardModeRule1.
  ///
  /// In en, this message translates to:
  /// **'The explainer receives a card containing 6 words'**
  String get cardModeRule1;

  /// No description provided for @cardModeRule2.
  ///
  /// In en, this message translates to:
  /// **'All words on the current card must be guessed before moving to the next one'**
  String get cardModeRule2;

  /// No description provided for @cardModeRule3.
  ///
  /// In en, this message translates to:
  /// **'Players can explain words on the card in any order'**
  String get cardModeRule3;

  /// No description provided for @generalRule1.
  ///
  /// In en, this message translates to:
  /// **'Using word roots, translations, or phonetic hints is prohibited'**
  String get generalRule1;

  /// No description provided for @generalRule2.
  ///
  /// In en, this message translates to:
  /// **'After each round, players can review and edit the list of guessed words'**
  String get generalRule2;

  /// No description provided for @generalRule3.
  ///
  /// In en, this message translates to:
  /// **'The game ends when the target score is reached, but all teams must complete the current round'**
  String get generalRule3;

  /// No description provided for @spyRule1.
  ///
  /// In en, this message translates to:
  /// **'One or more players are secretly chosen as the spy'**
  String get spyRule1;

  /// No description provided for @spyRule2.
  ///
  /// In en, this message translates to:
  /// **'Everyone else sees the same secret word, while the spy sees nothing'**
  String get spyRule2;

  /// No description provided for @spyRule3.
  ///
  /// In en, this message translates to:
  /// **'Players take turns asking each other questions about the secret word'**
  String get spyRule3;

  /// No description provided for @spyRule4.
  ///
  /// In en, this message translates to:
  /// **'Answer so you sound like you know the word, but don\'t say it outright'**
  String get spyRule4;

  /// No description provided for @spyRule5.
  ///
  /// In en, this message translates to:
  /// **'The spy tries to blend in and figure out the secret word'**
  String get spyRule5;

  /// No description provided for @spyRule6.
  ///
  /// In en, this message translates to:
  /// **'When the time runs out, everyone votes on who the spy is'**
  String get spyRule6;

  /// No description provided for @spy_round_stop_description.
  ///
  /// In en, this message translates to:
  /// **'Stop the timer and reveal the secret word?'**
  String get spy_round_stop_description;

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

  /// No description provided for @unlock_theme_title.
  ///
  /// In en, this message translates to:
  /// **'Unlock Theme'**
  String get unlock_theme_title;

  /// No description provided for @unlock_theme_description.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to unlock this theme and change the game\'s look?'**
  String get unlock_theme_description;

  /// No description provided for @unlock_theme_confirm.
  ///
  /// In en, this message translates to:
  /// **'Unlock'**
  String get unlock_theme_confirm;

  /// No description provided for @not_enough_coins.
  ///
  /// In en, this message translates to:
  /// **'Not enough coins'**
  String get not_enough_coins;

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
