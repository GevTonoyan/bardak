import 'package:bardak/core/localizations/app_locale.dart';

/// Abstract local data source for predefined team names.
abstract interface class TeamNamesLocalDataSource {
  /// Returns all predefined team names grouped by [AppLocale].
  Map<AppLocale, Set<String>> getPredefinedTeamNames();
}

/// Implementation of [TeamNamesLocalDataSource] that returns
/// compile-time constant team name sets keyed by [AppLocale].
class TeamNamesLocalDataSourceImpl implements TeamNamesLocalDataSource {
  const TeamNamesLocalDataSourceImpl();

  @override
  Map<AppLocale, Set<String>> getPredefinedTeamNames() => _predefinedTeamNames;
}

/// Predefined team names keyed by [AppLocale].
const Map<AppLocale, Set<String>> _predefinedTeamNames = {
  AppLocale.am: {
    'Արծիվներ',
    'Վագրեր',
    'Առյուծներ',
    'Կայծակներ',
    'Փոթորիկ',
    'Հրաբուխ',
    'Վիշապներ',
    'Արեգակ',
    'Լուսաբաց',
    'Ամպրոպ',
    'Գայլեր',
    'Բազեներ',
    'Կրակ',
    'Ալիքներ',
    'Ուրվականներ',
    'Կոբրաներ',
    'Ատոմ',
    'Ստվեր',
    'Ռազմիկներ',
    'Հերոսներ',
    'Տիտաններ',
    'Ֆենիքս',
    'Կայծ',
    'Անձրև',
    'Բռունցք',
  },
  AppLocale.ru: {
    'Орлы',
    'Тигры',
    'Волки',
    'Молнии',
    'Буря',
    'Вулкан',
    'Драконы',
    'Пираты',
    'Ракеты',
    'Гладиаторы',
    'Акулы',
    'Рысь',
    'Соколы',
    'Медведи',
    'Кобры',
    'Призраки',
    'Спартанцы',
    'Легионеры',
    'Феникс',
    'Торнадо',
    'Пантеры',
    'Кулак',
    'Зенит',
    'Шторм',
    'Стрелы',
    'Авангард',
    'Северный Флот',
    'Гром',
  },
  AppLocale.en: {
    'Eagles',
    'Tigers',
    'Wolves',
    'Thunderbolts',
    'Storm',
    'Volcano',
    'Dragons',
    'Pirates',
    'Rockets',
    'Gladiators',
    'Sharks',
    'Lynx',
    'Falcons',
    'Bears',
    'Cobras',
    'Phantoms',
    'Spartans',
    'Legions',
    'Phoenix',
    'Tornado',
    'Panthers',
    'Vipers',
    'Titans',
    'Cyclones',
    'Arrows',
    'Nighthawks',
    'Iron Fist',
    'Blizzard',
  },
};
