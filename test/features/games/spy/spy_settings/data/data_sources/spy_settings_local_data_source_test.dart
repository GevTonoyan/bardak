import 'package:bardak/features/games/spy/spy_settings/data/data_sources/spy_settings_local_data_source.dart';
import 'package:bardak/features/games/spy/spy_settings/domain/entities/spy_settings_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late SpySettingsLocalDataSourceImpl dataSource;

  setUp(() async {
    SharedPreferences.setMockInitialValues(const {});
    dataSource = SpySettingsLocalDataSourceImpl(
      preferences: await SharedPreferences.getInstance(),
    );
  });

  test('returns the entity defaults when nothing is stored', () {
    expect(dataSource.getSpySettings(), const SpySettingsEntity());
  });

  test('updates round-trip through getSpySettings', () async {
    await dataSource.updatePlayerCount(7);
    await dataSource.updateSpyCount(2);
    await dataSource.updateRoundDuration(600);

    expect(
      dataSource.getSpySettings(),
      const SpySettingsEntity(
        playerCount: 7,
        spyCount: 2,
        roundDuration: 600,
      ),
    );
  });

  test('a partial update keeps defaults for the rest', () async {
    await dataSource.updateSpyCount(3);

    final settings = dataSource.getSpySettings();
    expect(settings.spyCount, 3);
    expect(settings.playerCount, const SpySettingsEntity().playerCount);
    expect(settings.roundDuration, const SpySettingsEntity().roundDuration);
  });
}
