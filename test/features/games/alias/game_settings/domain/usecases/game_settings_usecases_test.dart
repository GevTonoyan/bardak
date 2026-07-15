import 'package:bardak/features/games/alias/game_settings/domain/entities/game_mode.dart';
import 'package:bardak/features/games/alias/game_settings/domain/entities/game_settings_entity.dart';
import 'package:bardak/features/games/alias/game_settings/domain/repositories/game_settings_repository.dart';
import 'package:bardak/features/games/alias/game_settings/domain/usecases/get_game_settings_usecase.dart';
import 'package:bardak/features/games/alias/game_settings/domain/usecases/update_allow_skipping_usecase.dart';
import 'package:bardak/features/games/alias/game_settings/domain/usecases/update_game_mode_usecase.dart';
import 'package:bardak/features/games/alias/game_settings/domain/usecases/update_points_to_win_usecase.dart';
import 'package:bardak/features/games/alias/game_settings/domain/usecases/update_round_duration_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockGameSettingsRepository extends Mock
    implements GameSettingsRepository {}

void main() {
  late _MockGameSettingsRepository repository;

  setUp(() => repository = _MockGameSettingsRepository());

  test('GetGameSettingsUseCase returns the repository settings', () {
    const settings = GameSettingsEntity(pointsToWin: 90);
    when(() => repository.getGameSettings()).thenReturn(settings);

    expect(GetGameSettingsUseCase(repository)(), settings);
  });

  test('UpdateGameModeUseCase persists the mode', () async {
    when(
      () => repository.updateGameMode(GameMode.singleWord),
    ).thenAnswer((_) async => true);

    expect(
      await UpdateGameModeUseCase(repository)(GameMode.singleWord),
      isTrue,
    );
    verify(() => repository.updateGameMode(GameMode.singleWord)).called(1);
  });

  test('UpdateRoundDurationUseCase persists the duration', () async {
    when(
      () => repository.updateRoundDuration(90),
    ).thenAnswer((_) async => true);

    expect(await UpdateRoundDurationUseCase(repository)(90), isTrue);
    verify(() => repository.updateRoundDuration(90)).called(1);
  });

  test('UpdatePointsToWinUseCase persists the target', () async {
    when(() => repository.updatePointsToWin(100)).thenAnswer((_) async => true);

    expect(await UpdatePointsToWinUseCase(repository)(100), isTrue);
    verify(() => repository.updatePointsToWin(100)).called(1);
  });

  test('UpdateAllowSkippingUseCase persists the flag', () async {
    when(
      () => repository.updateAllowSkipping(allowSkipping: false),
    ).thenAnswer((_) async => true);

    expect(
      await UpdateAllowSkippingUseCase(repository)(allowSkipping: false),
      isTrue,
    );
    verify(
      () => repository.updateAllowSkipping(allowSkipping: false),
    ).called(1);
  });
}
