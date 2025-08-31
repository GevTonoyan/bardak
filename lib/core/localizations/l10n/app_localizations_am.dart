// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Amharic (`am`).
class AppLocalizationsAm extends AppLocalizations {
  AppLocalizationsAm([String locale = 'am']) : super(locale);

  @override
  String get games_________________________________________________ =>
      'games----------------------------------------------------------------------';

  @override
  String get games_availableGames => 'Առկա խաղեր';

  @override
  String get games_aliasDescription => 'Գուշակեք բառերը ձեր թիմի հետ';

  @override
  String get settings______________________________________________ =>
      'settings----------------------------------------------------------------------';

  @override
  String get settings => 'Կարգավորումներ';

  @override
  String get settings_darkMode => ' Մութ ռեժիմ';

  @override
  String get settings_localeName => 'Հայերեն';

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
  String get alias_title => 'Ալիաս';

  @override
  String get alias_mode1 => 'Մի բառ';

  @override
  String get alias_mode2 => 'Քարտի ռեժիմ';

  @override
  String get alias_singleWordMode => 'Մի բառի ռեժիմ';

  @override
  String get alias_selectMode => 'Ընտրեք խաղի ռեժիմը';

  @override
  String get alias_wordPack => 'Բառերի փաթեթ';

  @override
  String get alias_round => 'Ռաունդ';

  @override
  String get alias_rulesTitle => 'Ալիասի կանոնները';

  @override
  String get alias_singleModeRule1 => 'Մի խաղացող բացատրում է մեկ բառ';

  @override
  String get alias_singleModeRule2 =>
      'Թիմը փորձում է գուշակել հնարավորինս շատ բառեր, մինչ ժամանակը կավարտվի';

  @override
  String get alias_singleModeRule3 =>
      'Բացատրողը չի կարող օգտագործել բառը, դրա որևէ արմատ, թարգմանություն, հնչյունական կամ ուղղագրական հուշումներ';

  @override
  String get alias_singleModeRule4 =>
      'Թիմակիցները կարող են գուշակել այնքան անգամ, որքան ցանկանում են';

  @override
  String get alias_singleModeRule5 =>
      'Երբ բառը ճիշտ գուշակվում է, նոր բառ է հայտնվում';

  @override
  String get alias_singleModeRule6 =>
      'Եթե բառը բաց թողնվի, 1 միավոր է հանվում (կարող է փոխվել կարգավորումներում)';

  @override
  String get alias_cardModeRule1 =>
      'Բացատրողը ստանում է քարտ, որի վրա մի քանի բառ կա (Սովորաբար 5-7)';

  @override
  String get alias_cardModeRule2 =>
      'Քարտի բոլոր բառերը պետք է գուշակվեն, մինչ ժամանակը կավարտվի';

  @override
  String get alias_cardModeRule3 =>
      'Խաղացողները կարող են գուշակել բառերը ցանկացած հերթականությամբ';

  @override
  String get alias_cardModeRule4 =>
      'Բաց թողնելը թույլ չի տրվում՝ դուք պետք է գուշակեք քարտի բոլոր բառերը';

  @override
  String get alias_cardModeRule5 =>
      'Բացատրողը չի կարող օգտագործել բառը, դրա որևէ արմատ, թարգմանություն, հնչյունական կամ ուղղագրական հուշումներ';

  @override
  String get alias_cardModeRule6 =>
      'Միավորները հաշվարկվում են գուշակված բառերի քանակով';

  @override
  String get alias_settings => 'Ալիասի կարգավորումներ';

  @override
  String get alias_settings_general => 'Ընդհանուր';

  @override
  String get alias_settings_roundDuration => 'Ռաունդի տևողությունը (վրկ)';

  @override
  String get alias_settings_pointsToWin => 'Միավորներ հաղթելու համար';

  @override
  String get alias_settings_soundEffects => 'Ձայնային էֆեկտներ';

  @override
  String get alias_settings_allowSkipping => 'Թույլ տալ բաց թողնել';

  @override
  String get alias_settings_penaltyForSkipping => 'Պատիժ բաց թողնելու համար';

  @override
  String get alias_settings_wordsPerCard => 'Քարտի բառերի քանակը';

  @override
  String get alias_settings_reset => 'Վերականգնել կարգավորումները';

  @override
  String get alias_word_packs_fail => 'Բառերի փաթեթները բեռնելը ձախողվեց';

  @override
  String get alias_failedLoadWords => 'Բառերը բեռնելը ձախողվեց';

  @override
  String get alias_preGameTitle => 'Պատրաստվեք';

  @override
  String get alias_preGameTeamSetup => 'Թիմերի կարգավորում';

  @override
  String get alias_preGameTeam => 'Թիմ';

  @override
  String get alias_preGameAddTeam => 'Ավելացնել թիմ';

  @override
  String alias_roundOverview_teamTurn(Object teamName) {
    return 'Ընթացիկ հերթը՝ $teamName թիմինն է։';
  }

  @override
  String alias_roundOverview_point(num points) {
    String _temp0 = intl.Intl.pluralLogic(
      points,
      locale: localeName,
      other: '$points միավոր',
      one: '$points միավոր',
    );
    return '$_temp0';
  }

  @override
  String get alias_roundOverview_roundScores => 'Փուլի միավորներ:';

  @override
  String get alias_roundOverview_confirmExit_title => 'Դուրս գալ խաղից՞';

  @override
  String get alias_roundOverview_confirmExit_message =>
      'Եթե փակեք այս էջը, խաղի ողջ ընթացքը կկորչի։ Վստա՞հ եք, որ ցանկանում եք դուրս գալ։';

  @override
  String get alias_countdown_go => 'Գնացինք!';

  @override
  String get general________________________________________________ =>
      'general----------------------------------------------------------------------';

  @override
  String get general_startGame => 'Սկսել խաղը';

  @override
  String get general_checkInternet => 'Ստուգեք ձեր ինտերնետային կապը';

  @override
  String get general_tryAgain => 'Կրկին փորձել';

  @override
  String get general_yes => 'Այո';

  @override
  String get general_no => 'Ոչ';
}
