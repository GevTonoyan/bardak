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
  String get teams => 'Команды';

  @override
  String team_with_count(int number) {
    return 'Команда $number';
  }

  @override
  String get alias => 'Алиас';

  @override
  String get oneWordMode => 'Одним словом';

  @override
  String get classicModeShort => 'Классический';

  @override
  String get oneWordModeShort => 'Одно слово';

  @override
  String get spyMode => 'Шпион';

  @override
  String get sudoku => 'Судоку';

  @override
  String get sudoku_solved => 'Судоку решено. Отличная работа!';

  @override
  String get sudoku_difficulty => 'Сложность';

  @override
  String get sudoku_difficulty_easy => 'Легко';

  @override
  String get sudoku_difficulty_medium => 'Средне';

  @override
  String get sudoku_difficulty_hard => 'Сложно';

  @override
  String get sudoku_difficulty_expert => 'Эксперт';

  @override
  String get sudoku_difficulty_extreme => 'Экстрим';

  @override
  String get sudoku_best_time => 'Лучшее время';

  @override
  String get sudoku_new_record => 'Новый рекорд!';

  @override
  String get sudoku_new_game => 'Новая игра';

  @override
  String get sudoku_show_timer => 'Таймер';

  @override
  String get sudoku_your_time => 'Ваше время:';

  @override
  String get sudoku_board_has_mistakes =>
      'Поле заполнено, но где-то есть ошибка';

  @override
  String get sudoku_game_over => 'Игра окончена';

  @override
  String sudoku_out_of_mistakes(int count) {
    return 'Вы сделали $count ошибки';
  }

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
  String get spy_dont_reveal => 'Не выдай себя! Угадай слово.';

  @override
  String get spy_secret_word => 'Секретное слово';

  @override
  String get spy_tap_to_hide => 'Нажми, чтобы скрыть и передать';

  @override
  String get spy_start_game => 'Начать игру';

  @override
  String get spy_all_ready => 'Все готовы';

  @override
  String get spy_find_the_spy =>
      'Задавайте вопросы по очереди и найдите шпиона';

  @override
  String get play_again => 'Играть снова';

  @override
  String get change_pack => 'Сменить набор';

  @override
  String get game_rules => 'Правила игры';

  @override
  String get singleModeRule1 =>
      'Сосредоточьтесь на объяснении одного слова на экране, пока команда пытается его угадать';

  @override
  String get singleModeRule2 =>
      'Можно пропустить трудное слово, чтобы двигаться дальше, но это будет стоить команде одного очка';

  @override
  String get cardModeRule1 =>
      'На карточке — список слов; объясняйте их в любом удобном порядке';

  @override
  String get cardModeRule2 =>
      'Команда должна верно угадать все слова из списка, прежде чем появится следующая карточка';

  @override
  String get generalRule1 =>
      'Каждое верно угаданное слово приносит команде ровно одно очко';

  @override
  String get generalRule2 =>
      'Используйте синонимы, антонимы и творческие описания, чтобы подвести команду к ответу';

  @override
  String get generalRule3 =>
      'Никогда не используйте переводы, однокоренные слова, произношение по буквам и не указывайте на предметы в комнате';

  @override
  String get cardModeRule1Title => 'Список слов';

  @override
  String get cardModeRule2Title => 'Отгадайте карточку';

  @override
  String get singleModeRule1Title => 'По одному';

  @override
  String get singleModeRule2Title => 'Штраф за пропуск';

  @override
  String get generalRule1Title => 'Зарабатывайте очки';

  @override
  String get generalRule2Title => 'Как объяснять';

  @override
  String get generalRule3Title => 'Строго запрещено';

  @override
  String get spyRule1 =>
      'Большинство игроков получают одно и то же секретное слово, а скрытые шпионы не видят ничего';

  @override
  String get spyRule2 =>
      'По очереди задавайте другому игроку открытый вопрос или вопрос с ответом «да/нет» о слове';

  @override
  String get spyRule3 =>
      'Как вариант, играйте, по очереди называя слово или фразу, связанные с секретным словом';

  @override
  String get spyRule4 =>
      'Делайте подсказки достаточно точными, чтобы доказать невиновность, но достаточно размытыми, чтобы запутать шпиона';

  @override
  String get spyRule5 =>
      'Шпион должен внимательно слушать, чтобы притвориться своим и угадать слово';

  @override
  String get spyRule6 =>
      'Когда время истекает, все обсуждают подсказки и голосуют за того, кого считают шпионом';

  @override
  String get spyRule1Title => 'Секретное слово';

  @override
  String get spyRule2Title => 'Задайте вопрос';

  @override
  String get spyRule3Title => 'Дайте подсказку';

  @override
  String get spyRule4Title => 'Говорите размыто';

  @override
  String get spyRule5Title => 'Слейтесь с толпой';

  @override
  String get spyRule6Title => 'Проголосуйте';

  @override
  String get sudokuRule1 =>
      'Заполните каждую строку, столбец и квадрат 3×3 числами от 1 до 9 без повторов';

  @override
  String get sudokuRule2 =>
      'Нажмите на пустую клетку и выберите число, чтобы поставить его; строка и столбец подсвечиваются';

  @override
  String get sudokuRule3 =>
      'Неверные числа показываются красным, а три ошибки завершают игру';

  @override
  String get sudokuRule4 =>
      'Включите карандаш, чтобы записывать небольшие заметки и отмечать возможные числа в клетке';

  @override
  String get sudokuRule5 =>
      'Используйте отмену, чтобы отменить последний ход, или ластик, чтобы очистить клетку';

  @override
  String get sudokuRule6 =>
      'Сложные уровни начинаются с меньшего числа подсказок — старайтесь побить свой рекорд по времени';

  @override
  String get sudokuRule1Title => 'Заполните поле';

  @override
  String get sudokuRule2Title => 'Поставьте число';

  @override
  String get sudokuRule3Title => 'Три жизни';

  @override
  String get sudokuRule4Title => 'Делайте заметки';

  @override
  String get sudokuRule5Title => 'Отмена и стирание';

  @override
  String get sudokuRule6Title => 'Выберите уровень';

  @override
  String get rules_next => 'Далее';

  @override
  String get rules_got_it => 'Понятно';

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
