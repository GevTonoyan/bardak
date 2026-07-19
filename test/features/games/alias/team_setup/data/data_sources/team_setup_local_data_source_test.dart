import 'package:bardak/core/localizations/app_locale.dart';
import 'package:bardak/features/games/alias/team_setup/data/data_sources/team_setup_local_data_source.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('provides predefined team names for every supported locale', () {
    const dataSource = TeamSetupLocalDataSourceImpl();

    final names = dataSource.getPredefinedTeamNames();

    for (final locale in AppLocale.values) {
      expect(
        names[locale],
        isNotEmpty,
        reason: 'locale ${locale.name} must have predefined names',
      );
    }
  });
}
