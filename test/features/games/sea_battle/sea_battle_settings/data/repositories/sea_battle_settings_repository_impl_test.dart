import 'package:bardak/features/games/sea_battle/sea_battle_settings/data/data_sources/sea_battle_settings_local_data_source.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_settings/data/repositories/sea_battle_settings_repository_impl.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_settings/domain/entities/sea_battle_bot_difficulty.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_settings/domain/entities/sea_battle_mode.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_settings/domain/entities/sea_battle_settings_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockLocalDataSource extends Mock
    implements SeaBattleSettingsLocalDataSource {}

void main() {
  late _MockLocalDataSource dataSource;
  late SeaBattleSettingsRepositoryImpl repository;

  setUp(() {
    dataSource = _MockLocalDataSource();
    repository = SeaBattleSettingsRepositoryImpl(dataSource: dataSource);
  });

  test('getSeaBattleSettings reads from the local data source', () {
    const settings = SeaBattleSettingsEntity(mode: SeaBattleMode.online);
    when(() => dataSource.getSeaBattleSettings()).thenReturn(settings);

    expect(repository.getSeaBattleSettings(), settings);
  });

  test('updateMode writes to the local data source', () async {
    when(
      () => dataSource.updateMode(SeaBattleMode.online),
    ).thenAnswer((_) async => true);

    expect(await repository.updateMode(SeaBattleMode.online), isTrue);
    verify(() => dataSource.updateMode(SeaBattleMode.online)).called(1);
  });

  test('updateBotDifficulty writes to the local data source', () async {
    when(
      () => dataSource.updateBotDifficulty(SeaBattleBotDifficulty.hard),
    ).thenAnswer((_) async => true);

    expect(
      await repository.updateBotDifficulty(SeaBattleBotDifficulty.hard),
      isTrue,
    );
    verify(
      () => dataSource.updateBotDifficulty(SeaBattleBotDifficulty.hard),
    ).called(1);
  });
}
