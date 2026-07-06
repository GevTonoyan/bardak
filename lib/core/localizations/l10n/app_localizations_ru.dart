// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appVersion => 'Версия приложения';

  @override
  String get proceed => 'Продолжить';

  @override
  String get cancel => 'Отмена';

  @override
  String get add => 'Добавить';

  @override
  String get skip => 'Пропустить';

  @override
  String get correct => 'Правильно';

  @override
  String get review => 'Проверка';

  @override
  String unit_sec(int count) {
    return '$count сек';
  }

  @override
  String unit_pts(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count очков',
      few: '$count очка',
      one: '$count очко',
    );
    return '$_temp0';
  }

  @override
  String points_value(String value) {
    return '$value очко';
  }

  @override
  String get settings => 'Настройки';

  @override
  String get settings_localeArmenian => 'Հայերեն';

  @override
  String get settings_localeRussian => 'Русский';

  @override
  String get settings_localeEnglish => 'English';

  @override
  String get settings_game_mode => 'Режим игры';

  @override
  String get settings_round_time => 'Время раунда';

  @override
  String get settings_players => 'Игроки';

  @override
  String get settings_spies => 'Шпионы';

  @override
  String unit_min(int count) {
    return '$count мин';
  }

  @override
  String get settings_points_to_win => 'Очки для победы';

  @override
  String get settings_allow_skipping => 'Пропуск слов';

  @override
  String get themes => 'Темы';

  @override
  String get theme_main => 'Основная';

  @override
  String get theme_purple => 'Фиолетовая';

  @override
  String get theme_yellow => 'Желтая';

  @override
  String get theme_blue => 'Синяя';

  @override
  String get theme_green => 'Зеленая';

  @override
  String get theme_pink => 'Розовая';

  @override
  String get theme_red => 'Красная';

  @override
  String get theme_turquoise => 'Бирюзовый';

  @override
  String get theme_orange => 'Оранжевая';

  @override
  String get theme_brown => 'Коричневая';

  @override
  String get theme_navy => 'Тёмно-синяя';

  @override
  String get theme_mint => 'Мятная';

  @override
  String get theme_plum => 'Сливовая';

  @override
  String get theme_dark => 'Тёмная';

  @override
  String get theme_grey => 'Серая';

  @override
  String get languages => 'Языки';

  @override
  String get sounds => 'Звуки';

  @override
  String get rewards => 'Награды';

  @override
  String get rewardsSelectThree => 'Выберите три';

  @override
  String rewards_success(int count) {
    return '+$count очков! Ждем тебя завтра.';
  }

  @override
  String get teams => 'Команды';

  @override
  String team_with_count(int number) {
    return 'Команда $number';
  }

  @override
  String get classicMode => 'Классический Алиас';

  @override
  String get oneWordMode => 'Одним словом';

  @override
  String get classicModeShort => 'Классический';

  @override
  String get oneWordModeShort => 'Одно слово';

  @override
  String get spyMode => 'Шпион';

  @override
  String get retry => 'Повторить';

  @override
  String player_with_number(int number) {
    return 'Игрок $number';
  }

  @override
  String get spy_tap_to_reveal => 'Нажми на карту, чтобы увидеть свою роль';

  @override
  String get spy_you_are_spy => 'Ты ШПИОН!';

  @override
  String get spy_dont_reveal =>
      'Не выдай себя! Попробуй угадать секретное слово';

  @override
  String get spy_secret_word => 'Секретное слово';

  @override
  String get spy_tap_to_hide => 'Нажми ещё раз, чтобы скрыть';

  @override
  String get spy_start_game => 'Начать игру';

  @override
  String get spy_all_ready => 'Все готовы';

  @override
  String get spy_find_the_spy =>
      'Задавайте вопросы по очереди и найдите шпиона';

  @override
  String get spy_finish_game => 'Завершить игру';

  @override
  String get play_again => 'Играть снова';

  @override
  String get change_pack => 'Сменить набор';

  @override
  String get game_rules => 'Правила игры';

  @override
  String get singleModeRule1 =>
      'Игрок объясняет слова последовательно, одно за другим';

  @override
  String get singleModeRule2 =>
      'При правильном угадывании слова сразу появляется следующее';

  @override
  String get singleModeRule3 => 'За пропуск слова вычитается 1 очко';

  @override
  String get cardModeRule1 =>
      'Ведущий получает карточку, на которой указано 6 слов';

  @override
  String get cardModeRule2 =>
      'Нужно угадать все слова на карточке, прежде чем перейти к следующей';

  @override
  String get cardModeRule3 =>
      'Игрок может объяснять слова на карточке в любом порядке';

  @override
  String get generalRule1 =>
      'Запрещено использовать однокоренные слова, переводы или фонетические подсказки';

  @override
  String get generalRule2 =>
      'После каждого раунда игроки могут просмотреть и отредактировать список угаданных слов';

  @override
  String get generalRule3 =>
      'Игра завершается при достижении лимита очков, но текущий раунд должен быть доигран всеми командами';

  @override
  String get scoreboard => 'Счёт';

  @override
  String get next_team => 'Следующая команда';

  @override
  String get winner_reveal => 'И победителем становится...';

  @override
  String get no_words_left_error =>
      'Извините, слова закончились. Вы можете попробовать с другой тематикой.';

  @override
  String get downloadWordsNetworkError =>
      'Сначала необходимо скачать слова. Пожалуйста, проверьте подключение к интернету и попробуйте снова.';

  @override
  String get exit_game_title => 'Выйти из игры?';

  @override
  String get exit_game_description =>
      'Вы уверены, что хотите завершить текущую игру?';

  @override
  String get exit_game_confirm => 'Да, выйти';

  @override
  String get round_stop_title => 'Завершить раунд?';

  @override
  String get round_stop_description =>
      'Остановить таймер и увидеть результаты? Очки будут сохранены.';

  @override
  String get round_stop_confirm => 'Завершить';

  @override
  String get round_stop_resume => 'Продолжить';

  @override
  String get unlock_theme_title => 'Открыть тему';

  @override
  String get unlock_theme_description =>
      'Вы уверены, что хотите разблокировать эту тему и изменить внешний вид игры?';

  @override
  String get unlock_theme_confirm => 'Открыть';

  @override
  String get not_enough_coins => 'Недостаточно монет';

  @override
  String get errorEmptyTeamNames =>
      'Подождите, а кто играет? Введите названия команд!';

  @override
  String get feedback => 'Обратная связь';

  @override
  String get feedback_email_error =>
      'Почтовое приложение не найдено. Напишите нам на bardak.support@gmail.com';

  @override
  String get rateApp => 'Оцените нас';

  @override
  String get rateApp_error => 'Ой! Не удалось открыть магазин приложений.';
}
