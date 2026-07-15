import 'package:bardak/features/games/spy/spy_settings/domain/entities/spy_settings_entity.dart';
import 'package:bardak/features/games/spy/spy_settings/domain/repositories/spy_settings_repository.dart';
import 'package:bardak/features/games/spy/spy_settings/domain/usecases/get_spy_settings_usecase.dart';
import 'package:bardak/features/games/spy/spy_settings/domain/usecases/update_player_count_usecase.dart';
import 'package:bardak/features/games/spy/spy_settings/domain/usecases/update_spy_count_usecase.dart';
import 'package:bardak/features/games/spy/spy_settings/domain/usecases/update_spy_round_duration_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockSpySettingsRepository extends Mock
    implements SpySettingsRepository {}

void main() {
  late _MockSpySettingsRepository repository;

  setUp(() => repository = _MockSpySettingsRepository());

  test('GetSpySettingsUseCase returns the repository settings', () {
    const settings = SpySettingsEntity(playerCount: 6);
    when(() => repository.getSpySettings()).thenReturn(settings);

    expect(GetSpySettingsUseCase(repository)(), settings);
  });

  test('UpdatePlayerCountUseCase persists the count', () async {
    when(() => repository.updatePlayerCount(7)).thenAnswer((_) async => true);

    expect(await UpdatePlayerCountUseCase(repository)(7), isTrue);
    verify(() => repository.updatePlayerCount(7)).called(1);
  });

  test('UpdateSpyCountUseCase persists the count', () async {
    when(() => repository.updateSpyCount(2)).thenAnswer((_) async => true);

    expect(await UpdateSpyCountUseCase(repository)(2), isTrue);
    verify(() => repository.updateSpyCount(2)).called(1);
  });

  test('UpdateSpyRoundDurationUseCase persists the duration', () async {
    when(
      () => repository.updateRoundDuration(600),
    ).thenAnswer((_) async => true);

    expect(await UpdateSpyRoundDurationUseCase(repository)(600), isTrue);
    verify(() => repository.updateRoundDuration(600)).called(1);
  });
}
