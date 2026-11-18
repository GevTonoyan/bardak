import 'package:bardak/features/games/sea_battle/sea_battle_settings/domain/entities/sea_battle_bot_difficulty.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_settings/domain/entities/sea_battle_mode.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_settings/domain/entities/sea_battle_settings_entity.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_settings/domain/repositories/sea_battle_settings_repository.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_settings/domain/usecases/get_sea_battle_settings_usecase.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_settings/domain/usecases/update_sea_battle_bot_difficulty_usecase.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_settings/domain/usecases/update_sea_battle_mode_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockSeaBattleSettingsRepository extends Mock
    implements SeaBattleSettingsRepository {}

void main() {
  late _MockSeaBattleSettingsRepository repository;

  setUp(() => repository = _MockSeaBattleSettingsRepository());

  test('GetSeaBattleSettingsUseCase returns the repository settings', () {
    const settings = SeaBattleSettingsEntity(
      mode: SeaBattleMode.online,
      botDifficulty: SeaBattleBotDifficulty.hard,
    );
    when(() => repository.getSeaBattleSettings()).thenReturn(settings);

    expect(GetSeaBattleSettingsUseCase(repository)(), settings);
  });

  test('UpdateSeaBattleModeUseCase persists the mode', () async {
    when(
      () => repository.updateMode(SeaBattleMode.online),
    ).thenAnswer((_) async => true);

    expect(
      await UpdateSeaBattleModeUseCase(repository)(SeaBattleMode.online),
      isTrue,
    );
    verify(() => repository.updateMode(SeaBattleMode.online)).called(1);
  });

  test('UpdateSeaBattleBotDifficultyUseCase persists the difficulty', () async {
    when(
      () => repository.updateBotDifficulty(SeaBattleBotDifficulty.easy),
    ).thenAnswer((_) async => true);

    expect(
      await UpdateSeaBattleBotDifficultyUseCase(repository)(
        SeaBattleBotDifficulty.easy,
      ),
      isTrue,
    );
    verify(
      () => repository.updateBotDifficulty(SeaBattleBotDifficulty.easy),
    ).called(1);
  });
}
