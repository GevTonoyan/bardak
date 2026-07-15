import 'package:bardak/features/games/alias/game_settings/data/data_sources/game_settings_local_data_source.dart';
import 'package:bardak/features/games/alias/game_settings/domain/entities/game_mode.dart';
import 'package:bardak/features/games/alias/game_settings/domain/entities/game_settings_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late GameSettingsLocalDataSourceImpl dataSource;

  setUp(() async {
    SharedPreferences.setMockInitialValues(const {});
    dataSource = GameSettingsLocalDataSourceImpl(
      preferences: await SharedPreferences.getInstance(),
    );
  });

  test('returns the entity defaults when nothing is stored', () {
    expect(dataSource.getGameSettings(), const GameSettingsEntity());
  });

  test('updates round-trip through getGameSettings', () async {
    await dataSource.updateGameMode(GameMode.singleWord);
    await dataSource.updateRoundDuration(90);
    await dataSource.updatePointsToWin(100);
    await dataSource.updateAllowSkipping(allowSkipping: false);

    expect(
      dataSource.getGameSettings(),
      const GameSettingsEntity(
        gameMode: GameMode.singleWord,
        roundDuration: 90,
        pointsToWin: 100,
        allowSkipping: false,
      ),
    );
  });
}
