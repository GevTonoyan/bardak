// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Amharic (`am`).
class AppLocalizationsAm extends AppLocalizations {
  AppLocalizationsAm([String locale = 'am']) : super(locale);

  @override
  String get settings______________________________________________ =>
      'settings----------------------------------------------------------------------';

  @override
  String get settings => 'Կարգավորումներ';

  @override
  String get app_settings => 'Հավելվածի կարգավորումներ';

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
  String get mode1 => 'Մի բառ';

  @override
  String get mode2 => 'Քարտի ռեժիմ';

  @override
  String get singleWordMode => 'Մի բառի ռեժիմ';

  @override
  String get selectMode => 'Ընտրեք խաղի ռեժիմը';

  @override
  String get wordPack => 'Բառերի փաթեթ';

  @override
  String get round => 'Ռաունդ';

  @override
  String get rulesTitle => 'Կանոնները';

  @override
  String get singleModeRule1 => 'Մի խաղացող բացատրում է մեկ բառ';

  @override
  String get singleModeRule2 =>
      'Թիմը փորձում է գուշակել հնարավորինս շատ բառեր, մինչ ժամանակը կավարտվի';

  @override
  String get singleModeRule3 =>
      'Բացատրողը չի կարող օգտագործել բառը, դրա որևէ արմատ, թարգմանություն, հնչյունական կամ ուղղագրական հուշումներ';

  @override
  String get singleModeRule4 =>
      'Թիմակիցները կարող են գուշակել այնքան անգամ, որքան ցանկանում են';

  @override
  String get singleModeRule5 =>
      'Երբ բառը ճիշտ գուշակվում է, նոր բառ է հայտնվում';

  @override
  String get singleModeRule6 =>
      'Եթե բառը բաց թողնվի, 1 միավոր է հանվում (կարող է փոխվել կարգավորումներում)';

  @override
  String get cardModeRule1 =>
      'Բացատրողը ստանում է քարտ, որի վրա մի քանի բառ կա (Սովորաբար 5-7)';

  @override
  String get cardModeRule2 =>
      'Քարտի բոլոր բառերը պետք է գուշակվեն, մինչ ժամանակը կավարտվի';

  @override
  String get cardModeRule3 =>
      'Խաղացողները կարող են գուշակել բառերը ցանկացած հերթականությամբ';

  @override
  String get cardModeRule4 =>
      'Բաց թողնելը թույլ չի տրվում՝ դուք պետք է գուշակեք քարտի բոլոր բառերը';

  @override
  String get cardModeRule5 =>
      'Բացատրողը չի կարող օգտագործել բառը, դրա որևէ արմատ, թարգմանություն, հնչյունական կամ ուղղագրական հուշումներ';

  @override
  String get cardModeRule6 =>
      'Միավորները հաշվարկվում են գուշակված բառերի քանակով';

  @override
  String get settings_general => 'Ընդհանուր';

  @override
  String get settings_roundDuration => 'Ռաունդի տևողությունը (վրկ)';

  @override
  String get settings_pointsToWin => 'Միավորներ հաղթելու համար';

  @override
  String get settings_soundEffects => 'Ձայնային էֆեկտներ';

  @override
  String get settings_allowSkipping => 'Թույլ տալ բաց թողնել';

  @override
  String get settings_penaltyForSkipping => 'Պատիժ բաց թողնելու համար';

  @override
  String get settings_wordsPerCard => 'Քարտի բառերի քանակը';

  @override
  String get settings_reset => 'Վերականգնել կարգավորումները';

  @override
  String get word_packs_fail => 'Բառերի փաթեթները բեռնելը ձախողվեց';

  @override
  String get failedLoadWords => 'Բառերը բեռնելը ձախողվեց';

  @override
  String get preGameTitle => 'Պատրաստվեք';

  @override
  String get preGameTeamSetup => 'Թիմերի կարգավորում';

  @override
  String get preGameTeam => 'Թիմ';

  @override
  String get preGameAddTeam => 'Ավելացնել թիմ';

  @override
  String roundOverview_teamTurn(Object teamName) {
    return 'Ընթացիկ հերթը՝ $teamName թիմինն է։';
  }

  @override
  String roundOverview_point(num points) {
    String _temp0 = intl.Intl.pluralLogic(
      points,
      locale: localeName,
      other: '$points միավոր',
      one: '$points միավոր',
    );
    return '$_temp0';
  }

  @override
  String get roundOverview_roundScores => 'Փուլի միավորներ:';

  @override
  String get roundOverview_confirmExit_title => 'Դուրս գալ խաղից՞';

  @override
  String get roundOverview_confirmExit_message =>
      'Եթե փակեք այս էջը, խաղի ողջ ընթացքը կկորչի։ Վստա՞հ եք, որ ցանկանում եք դուրս գալ։';

  @override
  String get countdown_go => 'Գնացինք!';

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
