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
  String get settings_players => 'Խաղացողներ';

  @override
  String get settings_spies => 'Լրտեսներ';

  @override
  String unit_min(int count) {
    return '$count րոպե';
  }

  @override
  String get settings_points_to_win => 'Միավորներ հաղթանակի համար';

  @override
  String get settings_allow_skipping => 'Բաց թողում';

  @override
  String get themes => 'Գույներ';

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
  String get teams => 'Թիմեր';

  @override
  String team_with_count(int number) {
    return 'Թիմ $number';
  }

  @override
  String get alias => 'Ալիաս';

  @override
  String get oneWordMode => 'Մեկ բառով';

  @override
  String get classicModeShort => 'Դասական';

  @override
  String get oneWordModeShort => 'Մեկ բառ';

  @override
  String get spyMode => 'Լրտես';

  @override
  String get sudoku => 'Սուդոկու';

  @override
  String get sudoku_solved => 'Սուդոկուն լուծված է։ Կեցցե՛ս';

  @override
  String get sudoku_board_size => 'Դաշտի չափը';

  @override
  String get sudoku_difficulty => 'Բարդություն';

  @override
  String get sudoku_difficulty_easy => 'Հեշտ';

  @override
  String get sudoku_difficulty_medium => 'Միջին';

  @override
  String get sudoku_difficulty_hard => 'Բարդ';

  @override
  String get sudoku_difficulty_expert => 'Փորձագետ';

  @override
  String get sudoku_difficulty_extreme => 'Էքստրիմ';

  @override
  String get sudoku_best_time => 'Լավագույն ժամանակ';

  @override
  String get sudoku_new_record => 'Նոր ռեկորդ';

  @override
  String get sudoku_new_game => 'Նոր խաղ';

  @override
  String get sudoku_show_timer => 'Ժամանակաչափ';

  @override
  String get sudoku_your_time => 'Քո ժամանակը՝';

  @override
  String get sudoku_board_has_mistakes =>
      'Դաշտը լրացված է, բայց ինչ-որ տեղ սխալ կա';

  @override
  String get sudoku_game_over => 'Խաղն ավարտվեց';

  @override
  String sudoku_out_of_mistakes(int count) {
    return 'Դուք թույլ տվեցիք $count սխալ';
  }

  @override
  String get retry => 'Կրկնել';

  @override
  String player_with_number(int number) {
    return 'Խաղացող $number';
  }

  @override
  String get spy_tap_to_reveal => 'Սեղմիր քարտին՝ դերդ տեսնելու համար';

  @override
  String get spy_you_are_spy => 'Դու ԼՐՏԵՍՆ ես!';

  @override
  String get spy_dont_reveal => 'Աննկատ մնա և գուշակիր բառը։';

  @override
  String get spy_secret_word => 'Գաղտնի բառը';

  @override
  String get spy_tap_to_hide => 'Սեղմիր՝ թաքցնելու և փոխանցելու համար';

  @override
  String get spy_start_game => 'Սկսել խաղը';

  @override
  String get spy_all_ready => 'Բոլորը պատրաստ են';

  @override
  String get spy_find_the_spy => 'Հերթով հարցեր տվեք և գտեք լրտեսին';

  @override
  String get spy_new_pack => 'Նոր փաթեթ';

  @override
  String get spy_create_pack => 'Ստեղծել փաթեթ';

  @override
  String get spy_edit_pack => 'Խմբագրել փաթեթը';

  @override
  String get spy_pack_name => 'Փաթեթի անուն';

  @override
  String get spy_words => 'Բառեր';

  @override
  String spy_min_words(int count) {
    return 'Պահպանելու համար ավելացրե՛ք առնվազն $count բառ';
  }

  @override
  String get spy_save_pack => 'Պահպանել փաթեթը';

  @override
  String get spy_delete_pack => 'Ջնջել փաթեթը';

  @override
  String get spy_delete_pack_confirm =>
      'Ջնջե՞լ այս փաթեթը։ Այս գործողությունն անշրջելի է։';

  @override
  String get play_again => 'Խաղալ նորից';

  @override
  String get change_pack => 'Փոխել հավաքածուն';

  @override
  String get game_rules => 'Խաղի կանոնները';

  @override
  String get singleModeRule1 =>
      'Կենտրոնացե՛ք էկրանին հայտնված մեկ բառը բացատրելու վրա, մինչ թիմը փորձում է գուշակել այն';

  @override
  String get singleModeRule2 =>
      'Կարող եք բաց թողնել դժվար բառը՝ առաջ շարժվելու համար, բայց դա թիմին կարժենա մեկ միավոր';

  @override
  String get cardModeRule1 =>
      'Դիտե՛ք մեկ քարտի վրայի բառերի ցանկը և բացատրե՛ք դրանք ձեզ հարմար ցանկացած հերթականությամբ';

  @override
  String get cardModeRule2 =>
      'Թիմը պետք է ճիշտ գուշակի ցանկի բոլոր բառերը, մինչև հաջորդ քարտը հայտնվի';

  @override
  String get generalRule1 =>
      'Յուրաքանչյուր ճիշտ գուշակված բառ թիմին բերում է ուղիղ մեկ միավոր';

  @override
  String get generalRule2 =>
      'Օգտագործե՛ք հոմանիշներ, հականիշներ և ստեղծագործ նկարագրություններ՝ թիմին դեպի պատասխանն առաջնորդելու համար';

  @override
  String get generalRule3 =>
      'Երբեք մի՛ օգտագործեք թարգմանություններ, բառի արմատներ, մի՛ վանկարկեք տառերով և մի՛ մատնացույց արեք սենյակի առարկաները';

  @override
  String get cardModeRule1Title => 'Բառերի ցանկ';

  @override
  String get cardModeRule2Title => 'Ավարտե՛ք քարտը';

  @override
  String get singleModeRule1Title => 'Մեկ առ մեկ';

  @override
  String get singleModeRule2Title => 'Բացթողման տուգանք';

  @override
  String get generalRule1Title => 'Վաստակե՛ք միավորներ';

  @override
  String get generalRule2Title => 'Ինչպես բացատրել';

  @override
  String get generalRule3Title => 'Խստիվ արգելված';

  @override
  String get spyRule1 =>
      'Խաղացողների մեծ մասը ստանում է նույն գաղտնի բառը, մինչդեռ թաքնված լրտեսները ոչինչ չեն տեսնում';

  @override
  String get spyRule2 =>
      'Հերթով մեկ այլ խաղացողի տվեք բաց կամ «այո/ոչ» հարց բառի մասին';

  @override
  String get spyRule3 =>
      'Որպես տարբերակ՝ խաղացեք՝ հերթով ասելով գաղտնի բառի հետ կապված բառ կամ արտահայտություն';

  @override
  String get spyRule4 =>
      'Ձեր հուշումները դարձրեք բավական հստակ՝ ձեր անմեղությունն ապացուցելու, բայց բավական աղոտ՝ լրտեսին շփոթեցնելու համար';

  @override
  String get spyRule5 =>
      'Լրտեսը պետք է ուշադիր լսի՝ ռաունդի ընթացքում ձևացնելու և բառը գուշակելու համար';

  @override
  String get spyRule6 =>
      'Երբ ժամանակը լրանում է, բոլորը քննարկում են հուշումները և քվեարկում, թե ով է, իրենց կարծիքով, լրտեսը';

  @override
  String get spyRule1Title => 'Գաղտնի բառը';

  @override
  String get spyRule2Title => 'Հարց տվեք';

  @override
  String get spyRule3Title => 'Հուշում տվեք';

  @override
  String get spyRule4Title => 'Մնացեք աղոտ';

  @override
  String get spyRule5Title => 'Աննկատ մնացեք';

  @override
  String get spyRule6Title => 'Քվեարկեք';

  @override
  String get sudokuRule1 =>
      'Լրացրե՛ք յուրաքանչյուր տող, սյունակ և 3×3 քառակուսի 1-ից 9 թվերով՝ առանց կրկնության';

  @override
  String get sudokuRule2 =>
      'Սեղմե՛ք դատարկ բջիջին և ընտրե՛ք թիվ՝ այն տեղադրելու համար. տողը և սյունակը ընդգծվում են';

  @override
  String get sudokuRule3 =>
      'Սխալ թվերը հայտնվում են կարմիրով, և երեք սխալը կավարտի ձեր խաղը';

  @override
  String get sudokuRule4 =>
      'Միացրե՛ք մատիտը՝ փոքր նշումներ գրելու և բջիջում հնարավոր թվերը հետևելու համար';

  @override
  String get sudokuRule5 =>
      'Օգտագործե՛ք հետարկման կոճակը՝ վերջին քայլը չեղարկելու, կամ ջնջման գործիքը՝ բջիջը մաքրելու համար';

  @override
  String get sudokuRule6 =>
      'Ավելի բարդ մակարդակները սկսվում են ավելի քիչ տրված թվերով՝ փորձե՛ք գերազանցել ձեր լավագույն ժամանակը';

  @override
  String get sudokuRule1Title => 'Լրացրե՛ք ցանցը';

  @override
  String get sudokuRule2Title => 'Տեղադրե՛ք թիվ';

  @override
  String get sudokuRule3Title => 'Երեք կյանք';

  @override
  String get sudokuRule4Title => 'Կատարե՛ք նշումներ';

  @override
  String get sudokuRule5Title => 'Հետարկում և ջնջում';

  @override
  String get sudokuRule6Title => 'Ընտրե՛ք մակարդակ';

  @override
  String get rules_next => 'Հաջորդը';

  @override
  String get rules_got_it => 'Հասկացա';

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
      'Վստա՞հ եք, որ ցանկանում եք ավարտել խաղը։';

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
  String get errorEmptyTeamNames =>
      'Սպասիր, իսկ ովքե՞ր են խաղում: Լրացրեք բոլոր թիմերը:';

  @override
  String get feedback => 'Հետադարձ կապ';

  @override
  String get feedback_email_error =>
      'No email app found. Please send feedback to bardak.support@gmail.com';

  @override
  String get rateApp => 'Գնահատե՛ք մեզ';

  @override
  String get rateApp_error => 'Չհաջողվեց բացել հավելվածների խանութը:';
}
