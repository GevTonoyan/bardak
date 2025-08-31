// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get games_________________________________________________ =>
      'games----------------------------------------------------------------------';

  @override
  String get games_availableGames => 'Доступные игры';

  @override
  String get games_aliasDescription => 'Угадай слова с вашей командой';

  @override
  String get settings______________________________________________ =>
      'settings----------------------------------------------------------------------';

  @override
  String get settings => 'Настройки';

  @override
  String get settings_darkMode => 'Тёмная тема';

  @override
  String get settings_localeName => 'Русский';

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
  String get alias_title => 'Алиас';

  @override
  String get alias_mode1 => 'Одно слово';

  @override
  String get alias_mode2 => 'Режим карты';

  @override
  String get alias_singleWordMode => 'Режим одного слова';

  @override
  String get alias_selectMode => 'Выберите режим игры';

  @override
  String get alias_wordPack => 'Пакет слов';

  @override
  String get alias_round => 'Раунд';

  @override
  String get alias_rulesTitle => 'Правила Алиаса';

  @override
  String get alias_singleModeRule1 => 'Один игрок объясняет одно слово за раз.';

  @override
  String get alias_singleModeRule2 =>
      'Команда пытается угадать как можно больше слов, пока не истечёт время.';

  @override
  String get alias_singleModeRule3 =>
      'Объясняющий не может использовать само слово, его часть, перевод, рифму или подсказки по написанию.';

  @override
  String get alias_singleModeRule4 => 'Товарищи по команде ';

  @override
  String get alias_singleModeRule5 =>
      'Можете угадывать столько раз, сколько захотите';

  @override
  String get alias_singleModeRule6 =>
      'Когда слово угадано правильно, появляется новое слово';

  @override
  String get alias_cardModeRule1 =>
      'Объясняющий получает карточку с несколькими словами (обычно 5–7).';

  @override
  String get alias_cardModeRule2 =>
      'Все слова на карточке должны быть угаданы до истечения времени';

  @override
  String get alias_cardModeRule3 =>
      'Игроки могут угадывать слова в любом порядке.';

  @override
  String get alias_cardModeRule4 =>
      'Пропускать нельзя — нужно угадать каждое слово на карточке';

  @override
  String get alias_cardModeRule5 =>
      'Объясняющий не может использовать само слово, его часть, перевод, рифму или подсказки по написанию.';

  @override
  String get alias_cardModeRule6 => 'Счёт основан на количестве угаданных слов';

  @override
  String get alias_settings => 'Настройки Алиаса';

  @override
  String get alias_settings_general => 'Общие';

  @override
  String get alias_settings_roundDuration => 'Длительность раунда (сек)';

  @override
  String get alias_settings_pointsToWin => 'Очки для победы';

  @override
  String get alias_settings_soundEffects => 'Звуковые эффекты';

  @override
  String get alias_settings_allowSkipping => 'Разрешить пропуск';

  @override
  String get alias_settings_penaltyForSkipping => 'Штраф за пропуск';

  @override
  String get alias_settings_wordsPerCard => 'Количество слов на карточке';

  @override
  String get alias_settings_reset => 'Сбросить настройки';

  @override
  String get alias_word_packs_fail => 'Не удалось загрузить пакеты слов';

  @override
  String get alias_failedLoadWords => 'Не удалось загрузить слова';

  @override
  String get alias_preGameTitle => 'Подготовьтесь';

  @override
  String get alias_preGameTeamSetup => 'Настройка команд';

  @override
  String get alias_preGameTeam => 'Команда';

  @override
  String get alias_preGameAddTeam => 'Добавить команду';

  @override
  String alias_roundOverview_teamTurn(Object teamName) {
    return 'Сейчас ход команды $teamName.';
  }

  @override
  String alias_roundOverview_point(num points) {
    String _temp0 = intl.Intl.pluralLogic(
      points,
      locale: localeName,
      other: '$points очков',
      one: '$points очко',
    );
    return '$_temp0';
  }

  @override
  String get alias_roundOverview_roundScores => 'Очки по раундам:';

  @override
  String get alias_roundOverview_confirmExit_title => 'Выйти из игры?';

  @override
  String get alias_roundOverview_confirmExit_message =>
      'Если вы закроете этот экран, весь прогресс игры будет потерян. Вы уверены, что хотите выйти?';

  @override
  String get alias_countdown_go => 'Вперёд!';

  @override
  String get general________________________________________________ =>
      'general----------------------------------------------------------------------';

  @override
  String get general_startGame => 'Начать игру';

  @override
  String get general_checkInternet => 'Проверьте ваше интернет-соединение';

  @override
  String get general_tryAgain => 'Попробовать снова';

  @override
  String get general_yes => 'Да';

  @override
  String get general_no => 'Нет';
}
