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
  String get check => 'Проверить';

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
  String get theme_black => 'Черная';

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
  String get sounds => 'Звуки';

  @override
  String get rewards => 'Награды';

  @override
  String get rewardsSelectThree => 'Выберите три';

  @override
  String rewards_success(int count) {
    return 'Здорово!\nВы заработали $count очков';
  }

  @override
  String get teams => 'Команды';

  @override
  String team_with_count(int number) {
    return 'Команда $number';
  }

  @override
  String get classicMode => 'Классический';

  @override
  String get oneWordMode => 'Одно слово';

  @override
  String get game_rules => 'Правила игры';

  @override
  String get singleModeRule1 => 'Один игрок объясняет одно слово за раз.';

  @override
  String get singleModeRule2 =>
      'Команда пытается угадать как можно больше слов, пока не истечёт время.';

  @override
  String get singleModeRule3 =>
      'Объясняющий не может использовать само слово, его часть, перевод, рифму или подсказки по написанию.';

  @override
  String get singleModeRule4 =>
      'Товарищи по команде могут угадывать столько раз, сколько захотят.';

  @override
  String get singleModeRule5 =>
      'Когда слово угадано правильно, появляется новое слово.';

  @override
  String get singleModeRule6 =>
      'Если слово пропущено, вычитается 1 очко (можно изменить в настройках).';

  @override
  String get cardModeRule1 =>
      'Объясняющий получает карточку с несколькими словами (обычно 5–7).';

  @override
  String get cardModeRule2 =>
      'Все слова на карточке должны быть угаданы до истечения времени.';

  @override
  String get cardModeRule3 => 'Игроки могут угадывать слова в любом порядке.';

  @override
  String get cardModeRule4 =>
      'Пропускать нельзя — нужно угадать каждое слово на карточке.';

  @override
  String get cardModeRule5 =>
      'Объясняющий не может использовать само слово, его часть, перевод, рифму или подсказки по написанию.';

  @override
  String get cardModeRule6 => 'Счёт основан на количестве угаданных слов.';

  @override
  String get generalRule1 =>
      'Игра заканчивается, когда одна из команд набирает необходимое количество очков, но текущий раунд должен завершиться, чтобы все команды сыграли равное количество раз.';

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
}
