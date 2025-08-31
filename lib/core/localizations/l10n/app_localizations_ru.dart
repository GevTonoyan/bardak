// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get settings______________________________________________ => 'settings----------------------------------------------------------------------';

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
  String get alias________________________________________________ => 'alias----------------------------------------------------------------------';

  @override
  String get mode1 => 'Одно слово';

  @override
  String get mode2 => 'Режим карты';

  @override
  String get singleWordMode => 'Режим одного слова';

  @override
  String get selectMode => 'Выберите режим игры';

  @override
  String get wordPack => 'Пакет слов';

  @override
  String get round => 'Раунд';

  @override
  String get rulesTitle => 'Правила';

  @override
  String get singleModeRule1 => 'Один игрок объясняет одно слово за раз.';

  @override
  String get singleModeRule2 => 'Команда пытается угадать как можно больше слов, пока не истечёт время.';

  @override
  String get singleModeRule3 => 'Объясняющий не может использовать само слово, его часть, перевод, рифму или подсказки по написанию.';

  @override
  String get singleModeRule4 => 'Товарищи по команде ';

  @override
  String get singleModeRule5 => 'Можете угадывать столько раз, сколько захотите';

  @override
  String get singleModeRule6 => 'Когда слово угадано правильно, появляется новое слово';

  @override
  String get cardModeRule1 => 'Объясняющий получает карточку с несколькими словами (обычно 5–7).';

  @override
  String get cardModeRule2 => 'Все слова на карточке должны быть угаданы до истечения времени';

  @override
  String get cardModeRule3 => 'Игроки могут угадывать слова в любом порядке.';

  @override
  String get cardModeRule4 => 'Пропускать нельзя — нужно угадать каждое слово на карточке';

  @override
  String get cardModeRule5 => 'Объясняющий не может использовать само слово, его часть, перевод, рифму или подсказки по написанию.';

  @override
  String get cardModeRule6 => 'Счёт основан на количестве угаданных слов';

  @override
  String get settings_general => 'Общие';

  @override
  String get settings_roundDuration => 'Длительность раунда (сек)';

  @override
  String get settings_pointsToWin => 'Очки для победы';

  @override
  String get settings_soundEffects => 'Звуковые эффекты';

  @override
  String get settings_allowSkipping => 'Разрешить пропуск';

  @override
  String get settings_penaltyForSkipping => 'Штраф за пропуск';

  @override
  String get settings_wordsPerCard => 'Количество слов на карточке';

  @override
  String get settings_reset => 'Сбросить настройки';

  @override
  String get word_packs_fail => 'Не удалось загрузить пакеты слов';

  @override
  String get failedLoadWords => 'Не удалось загрузить слова';

  @override
  String get preGameTitle => 'Подготовьтесь';

  @override
  String get preGameTeamSetup => 'Настройка команд';

  @override
  String get preGameTeam => 'Команда';

  @override
  String get preGameAddTeam => 'Добавить команду';

  @override
  String roundOverview_teamTurn(Object teamName) {
    return 'Сейчас ход команды $teamName.';
  }

  @override
  String roundOverview_point(num points) {
    String _temp0 = intl.Intl.pluralLogic(
      points,
      locale: localeName,
      other: '$points очков',
      one: '$points очко',
    );
    return '$_temp0';
  }

  @override
  String get roundOverview_roundScores => 'Очки по раундам:';

  @override
  String get roundOverview_confirmExit_title => 'Выйти из игры?';

  @override
  String get roundOverview_confirmExit_message => 'Если вы закроете этот экран, весь прогресс игры будет потерян. Вы уверены, что хотите выйти?';

  @override
  String get countdown_go => 'Вперёд!';

  @override
  String get general________________________________________________ => 'general----------------------------------------------------------------------';

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
