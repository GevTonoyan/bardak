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
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('am'),
    Locale('en'),
    Locale('ru')
  ];

  /// No description provided for @settings______________________________________________.
  ///
  /// In en, this message translates to:
  /// **'settings----------------------------------------------------------------------'**
  String get settings______________________________________________;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @settings_darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get settings_darkMode;

  /// No description provided for @settings_localeName.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get settings_localeName;

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

  /// No description provided for @alias________________________________________________.
  ///
  /// In en, this message translates to:
  /// **'alias----------------------------------------------------------------------'**
  String get alias________________________________________________;

  /// No description provided for @mode1.
  ///
  /// In en, this message translates to:
  /// **'Single Word'**
  String get mode1;

  /// No description provided for @mode2.
  ///
  /// In en, this message translates to:
  /// **'Card Mode'**
  String get mode2;

  /// No description provided for @singleWordMode.
  ///
  /// In en, this message translates to:
  /// **'Single Word Mode'**
  String get singleWordMode;

  /// No description provided for @selectMode.
  ///
  /// In en, this message translates to:
  /// **'Select Game Mode'**
  String get selectMode;

  /// No description provided for @wordPack.
  ///
  /// In en, this message translates to:
  /// **'Word Pack'**
  String get wordPack;

  /// No description provided for @round.
  ///
  /// In en, this message translates to:
  /// **'Round'**
  String get round;

  /// No description provided for @rulesTitle.
  ///
  /// In en, this message translates to:
  /// **'Rules'**
  String get rulesTitle;

  /// No description provided for @singleModeRule1.
  ///
  /// In en, this message translates to:
  /// **'One player explains a single word at a time.'**
  String get singleModeRule1;

  /// No description provided for @singleModeRule2.
  ///
  /// In en, this message translates to:
  /// **'The team tries to guess as many words as possible before the timer runs out.'**
  String get singleModeRule2;

  /// No description provided for @singleModeRule3.
  ///
  /// In en, this message translates to:
  /// **'The explainer cannot use the word itself, any part of it, a translation, a rhyme, or spelling hints.'**
  String get singleModeRule3;

  /// No description provided for @singleModeRule4.
  ///
  /// In en, this message translates to:
  /// **'Teammates can guess as many times as they want.'**
  String get singleModeRule4;

  /// No description provided for @singleModeRule5.
  ///
  /// In en, this message translates to:
  /// **'When guessed correctly, a new word appears.'**
  String get singleModeRule5;

  /// No description provided for @singleModeRule6.
  ///
  /// In en, this message translates to:
  /// **'If the word is skipped, 1 point is deducted (can be changed in settings).'**
  String get singleModeRule6;

  /// No description provided for @cardModeRule1.
  ///
  /// In en, this message translates to:
  /// **'The explainer receives a card with multiple words (usually 5–7).'**
  String get cardModeRule1;

  /// No description provided for @cardModeRule2.
  ///
  /// In en, this message translates to:
  /// **'All words on the card must be guessed before the timer runs out.'**
  String get cardModeRule2;

  /// No description provided for @cardModeRule3.
  ///
  /// In en, this message translates to:
  /// **'Players can guess the words in any order.'**
  String get cardModeRule3;

  /// No description provided for @cardModeRule4.
  ///
  /// In en, this message translates to:
  /// **'Skipping is not allowed — you must guess every word on the card.'**
  String get cardModeRule4;

  /// No description provided for @cardModeRule5.
  ///
  /// In en, this message translates to:
  /// **'The explainer cannot use the word itself, any part of it, a translation, a rhyme, or spelling hints.'**
  String get cardModeRule5;

  /// No description provided for @cardModeRule6.
  ///
  /// In en, this message translates to:
  /// **'Score is based on the number guessed words'**
  String get cardModeRule6;

  /// No description provided for @settings_general.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get settings_general;

  /// No description provided for @settings_roundDuration.
  ///
  /// In en, this message translates to:
  /// **'Round Duration (sec)'**
  String get settings_roundDuration;

  /// No description provided for @settings_pointsToWin.
  ///
  /// In en, this message translates to:
  /// **'Points to Win'**
  String get settings_pointsToWin;

  /// No description provided for @settings_soundEffects.
  ///
  /// In en, this message translates to:
  /// **'Sound Effects'**
  String get settings_soundEffects;

  /// No description provided for @settings_allowSkipping.
  ///
  /// In en, this message translates to:
  /// **'Allow Skipping'**
  String get settings_allowSkipping;

  /// No description provided for @settings_penaltyForSkipping.
  ///
  /// In en, this message translates to:
  /// **'Penalty for Skipping'**
  String get settings_penaltyForSkipping;

  /// No description provided for @settings_wordsPerCard.
  ///
  /// In en, this message translates to:
  /// **'Words per Card'**
  String get settings_wordsPerCard;

  /// No description provided for @settings_reset.
  ///
  /// In en, this message translates to:
  /// **'Reset Settings'**
  String get settings_reset;

  /// No description provided for @word_packs_fail.
  ///
  /// In en, this message translates to:
  /// **'Failed to load word packs'**
  String get word_packs_fail;

  /// No description provided for @failedLoadWords.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load words'**
  String get failedLoadWords;

  /// No description provided for @preGameTitle.
  ///
  /// In en, this message translates to:
  /// **'Get Ready'**
  String get preGameTitle;

  /// No description provided for @preGameTeamSetup.
  ///
  /// In en, this message translates to:
  /// **'Team Setup'**
  String get preGameTeamSetup;

  /// No description provided for @preGameTeam.
  ///
  /// In en, this message translates to:
  /// **'Team'**
  String get preGameTeam;

  /// No description provided for @preGameAddTeam.
  ///
  /// In en, this message translates to:
  /// **'Add Team'**
  String get preGameAddTeam;

  /// No description provided for @roundOverview_teamTurn.
  ///
  /// In en, this message translates to:
  /// **'It\'s {teamName}\'s turn!'**
  String roundOverview_teamTurn(Object teamName);

  /// No description provided for @roundOverview_point.
  ///
  /// In en, this message translates to:
  /// **'{points, plural, one {{points} point} other {{points} points}}'**
  String roundOverview_point(num points);

  /// No description provided for @roundOverview_roundScores.
  ///
  /// In en, this message translates to:
  /// **'Round Scores:'**
  String get roundOverview_roundScores;

  /// No description provided for @roundOverview_confirmExit_title.
  ///
  /// In en, this message translates to:
  /// **'Exit Game?'**
  String get roundOverview_confirmExit_title;

  /// No description provided for @roundOverview_confirmExit_message.
  ///
  /// In en, this message translates to:
  /// **'If you close this screen, all game progress will be lost. Are you sure you want to exit?'**
  String get roundOverview_confirmExit_message;

  /// No description provided for @countdown_go.
  ///
  /// In en, this message translates to:
  /// **'Go!'**
  String get countdown_go;

  /// No description provided for @general________________________________________________.
  ///
  /// In en, this message translates to:
  /// **'general----------------------------------------------------------------------'**
  String get general________________________________________________;

  /// No description provided for @general_startGame.
  ///
  /// In en, this message translates to:
  /// **'Start Game'**
  String get general_startGame;

  /// No description provided for @general_checkInternet.
  ///
  /// In en, this message translates to:
  /// **'Check your internet connection'**
  String get general_checkInternet;

  /// No description provided for @general_tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get general_tryAgain;

  /// No description provided for @general_yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get general_yes;

  /// No description provided for @general_no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get general_no;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['am', 'en', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'am': return AppLocalizationsAm();
    case 'en': return AppLocalizationsEn();
    case 'ru': return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
