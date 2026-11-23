import 'package:bardak/features/games/sea_battle/sea_battle_settings/data/data_sources/sea_battle_settings_local_data_source.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_settings/domain/entities/sea_battle_bot_difficulty.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_settings/domain/entities/sea_battle_mode.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_settings/domain/entities/sea_battle_settings_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late SeaBattleSettingsLocalDataSourceImpl dataSource;

  setUp(() async {
    SharedPreferences.setMockInitialValues(const {});
    dataSource = SeaBattleSettingsLocalDataSourceImpl(
      preferences: await SharedPreferences.getInstance(),
    );
  });

  test('returns the entity defaults when nothing is stored', () {
    expect(dataSource.getSeaBattleSettings(), const SeaBattleSettingsEntity());
  });

  test('updates round-trip through getSeaBattleSettings', () async {
    await dataSource.updateMode(SeaBattleMode.online);
    await dataSource.updateBotDifficulty(SeaBattleBotDifficulty.hard);

    expect(
      dataSource.getSeaBattleSettings(),
      const SeaBattleSettingsEntity(
        mode: SeaBattleMode.online,
        botDifficulty: SeaBattleBotDifficulty.hard,
      ),
    );
  });

  test('falls back to defaults for unknown stored values', () async {
    SharedPreferences.setMockInitialValues(const {
      'sea_battle_mode': 'unknown',
      'sea_battle_bot_difficulty': 'impossible',
    });
    dataSource = SeaBattleSettingsLocalDataSourceImpl(
      preferences: await SharedPreferences.getInstance(),
    );

    expect(dataSource.getSeaBattleSettings(), const SeaBattleSettingsEntity());
  });
}
