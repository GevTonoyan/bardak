// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Amharic (`am`).
class AppLocalizationsAm extends AppLocalizations {
  AppLocalizationsAm([String locale = 'am']) : super(locale);

  @override
  String get appVersion => 'Հավելվածի տարբերակը';

  @override
  String get proceed => 'Շարունակել';

  @override
  String get cancel => 'Չեղարկել';

  @override
  String get add => 'Ավելացնել';

  @override
  String get skip => 'Բաց թողնել';

  @override
  String get correct => 'Ճիշտ է';

  @override
  String get review => 'Ստուգում';

  @override
  String unit_sec(int count) {
    return '$count վրկ';
  }

  @override
  String unit_pts(int count) {
    return '$count միավոր';
  }

  @override
  String points_value(String value) {
    return '$value միավոր';
  }

  @override
  String get settings => 'Կարգավորումներ';

  @override
  String get settings_localeArmenian => 'Հայերեն';

  @override
  String get settings_localeRussian => 'Русский';

  @override
  String get settings_localeEnglish => 'English';

  @override
  String get settings_game_mode => 'Խաղի ռեժիմ';

  @override
  String get settings_round_time => 'Ռաունդի տևողություն';

  @override
  String get settings_points_to_win => 'Միավորներ հաղթանակի համար';

  @override
  String get settings_allow_skipping => 'Բաց թողում';

  @override
  String get themes => 'Թեմաներ';

  @override
  String get theme_main => 'Հիմնական';

  @override
  String get theme_purple => 'Մանուշակագույն';

  @override
  String get theme_yellow => 'Դեղին';

  @override
  String get theme_blue => 'Կապույտ';

  @override
  String get theme_green => 'Կանաչ';

  @override
  String get theme_pink => 'Վարդագույն';

  @override
  String get theme_red => 'Կարմիր';

  @override
  String get theme_turquoise => 'Փիրուզագույն';

  @override
  String get theme_orange => 'Նարնջագույն';

  @override
  String get theme_brown => 'Շագանակագույն';

  @override
  String get theme_navy => 'Մուգ կապույտ';

  @override
  String get theme_mint => 'Անանուխի';

  @override
  String get theme_plum => 'Սալորագույն';

  @override
  String get theme_dark => 'Մուգ';

  @override
  String get theme_grey => 'Մոխրագույն';

  @override
  String get languages => 'Լեզուներ';

  @override
  String get sounds => 'Ձայներ';

  @override
  String get rewards => 'Պարգևներ';

  @override
  String get rewardsSelectThree => 'Ընտրեք երեքը';

  @override
  String rewards_success(int count) {
    return '+$count միավոր: Կհանդիպենք վաղը:';
  }

  @override
  String get teams => 'Թիմեր';

  @override
  String team_with_count(int number) {
    return 'Թիմ $number';
  }

  @override
  String get classicMode => 'Դասական';

  @override
  String get oneWordMode => 'Մեկ բառ';

  @override
  String get game_rules => 'Խաղի կանոնները';

  @override
  String get singleModeRule1 =>
      'Խաղացողը բացատրում է բառերը հաջորդաբար՝ մեկը մյուսի հետևից';

  @override
  String get singleModeRule2 =>
      'Բառը ճիշտ գուշակելու դեպքում հայտնվում է հաջորդ բառը';

  @override
  String get singleModeRule3 =>
      'Բառը բաց թողնելու դեպքում հաշվից նվազեցվում է 1 միավոր';

  @override
  String get cardModeRule1 =>
      'Բացատրողը ստանում է քարտ, որը պարունակում է 6 բառ';

  @override
  String get cardModeRule2 =>
      'Հաջորդ քարտին անցնելու համար անհրաժեշտ է գուշակել ընթացիկ քարտի բոլոր բառերը';

  @override
  String get cardModeRule3 =>
      'Խաղացողը կարող է բացատրել քարտի բառերը ցանկացած հերթականությամբ';

  @override
  String get generalRule1 =>
      'Արգելվում է օգտագործել բառի արմատը, թարգմանությունը կամ հնչյունական հուշումներ';

  @override
  String get generalRule2 =>
      'Յուրաքանչյուր փուլից հետո խաղացողները կարող են վերանայել և խմբագրել գուշակված բառերի ցանկը';

  @override
  String get generalRule3 =>
      'Խաղն ավարտվում է սահմանված միավորներին հասնելիս, սակայն փուլը պետք է խաղան բոլոր թիմերը';

  @override
  String get scoreboard => 'Հաշիվը';

  @override
  String get next_team => 'Հաջորդ թիմը';

  @override
  String get winner_reveal => 'Եվ հաղթողն է...';

  @override
  String get no_words_left_error =>
      'Այս թեմայում բառեր չեն մնացել։ Խնդրում ենք ընտրել այլ փաթեթ՝ նորից խաղալու համար:';

  @override
  String get downloadWordsNetworkError =>
      'Նախ պետք է ներբեռնեք բառերը: Խնդրում ենք ստուգել ձեր ինտերնետ կապը և փորձել կրկին:';

  @override
  String get exit_game_title => 'Դուրս գա՞լ խաղից';

  @override
  String get exit_game_description =>
      'Վստա՞հ եք, որ ցանկանում եք ավարտել խաղը:';

  @override
  String get exit_game_confirm => 'Այո, դուրս գալ';

  @override
  String get round_stop_title => 'Ավարտե՞լ ռաունդը';

  @override
  String get round_stop_description =>
      'Դադարեցնե՞լ ժամանակը և տեսնել արդյունքները: Միավորները կպահպանվեն:';

  @override
  String get round_stop_confirm => 'Ավարտել';

  @override
  String get round_stop_resume => 'Շարունակել';

  @override
  String get unlock_theme_title => 'Բացել թեման';

  @override
  String get unlock_theme_description =>
      'Համոզվա՞ծ եք, որ ցանկանում եք ակտիվացնել այս թեման և փոխել խաղի տեսքը:';

  @override
  String get unlock_theme_confirm => 'Բացել';

  @override
  String get not_enough_coins => 'Մետաղադրամները բավարար չեն';

  @override
  String get errorEmptyTeamNames =>
      'Սպասիր, իսկ ովքե՞ր են խաղում: Լրացրեք բոլոր թիմերը:';

  @override
  String get feedback => 'Հետադարձ կապ';

  @override
  String get feedback_email_error =>
      'No email app found. Please send feedback to bardak.support@gmail.com';
}
