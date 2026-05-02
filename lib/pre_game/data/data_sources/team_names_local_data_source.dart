import 'package:bardak/localizations/common/supported_locales.dart';

/// Abstract local data source for predefined team names.
abstract interface class TeamNamesLocalDataSource {
  /// Returns all predefined team names grouped by [AppLocales].
  Map<AppLocales, Set<String>> getPredefinedTeamNames();
}

/// Implementation of [TeamNamesLocalDataSource] that returns
/// compile-time constant team name sets keyed by [AppLocales].
class TeamNamesLocalDataSourceImpl implements TeamNamesLocalDataSource {
  const TeamNamesLocalDataSourceImpl();

  @override
  Map<AppLocales, Set<String>> getPredefinedTeamNames() => _predefinedTeamNames;
}

/// Predefined team names keyed by [AppLocales].
const Map<AppLocales, Set<String>> _predefinedTeamNames = {
  AppLocales.am: {
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
  AppLocales.ru: {
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
  AppLocales.en: {
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
