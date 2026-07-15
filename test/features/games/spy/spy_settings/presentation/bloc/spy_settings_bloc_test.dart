import 'package:bardak/features/games/spy/spy_settings/domain/entities/spy_settings_entity.dart';
import 'package:bardak/features/games/spy/spy_settings/domain/usecases/get_spy_settings_usecase.dart';
import 'package:bardak/features/games/spy/spy_settings/domain/usecases/update_player_count_usecase.dart';
import 'package:bardak/features/games/spy/spy_settings/domain/usecases/update_spy_count_usecase.dart';
import 'package:bardak/features/games/spy/spy_settings/domain/usecases/update_spy_round_duration_usecase.dart';
import 'package:bardak/features/games/spy/spy_settings/presentation/bloc/spy_settings_bloc.dart';
import 'package:bardak/features/games/spy/spy_settings/presentation/bloc/spy_settings_event.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockGetSpySettings extends Mock implements GetSpySettingsUseCase {}

class _MockUpdatePlayerCount extends Mock implements UpdatePlayerCountUseCase {}

class _MockUpdateSpyCount extends Mock implements UpdateSpyCountUseCase {}

class _MockUpdateSpyRoundDuration extends Mock
    implements UpdateSpyRoundDurationUseCase {}

void main() {
  late _MockGetSpySettings getSpySettings;
  late _MockUpdatePlayerCount updatePlayerCount;
  late _MockUpdateSpyCount updateSpyCount;
  late _MockUpdateSpyRoundDuration updateSpyRoundDuration;

  setUp(() {
    getSpySettings = _MockGetSpySettings();
    updatePlayerCount = _MockUpdatePlayerCount();
    updateSpyCount = _MockUpdateSpyCount();
    updateSpyRoundDuration = _MockUpdateSpyRoundDuration();
    when(getSpySettings.call).thenReturn(const SpySettingsEntity());
    when(() => updatePlayerCount(any())).thenAnswer((_) async => true);
    when(() => updateSpyCount(any())).thenAnswer((_) async => true);
    when(() => updateSpyRoundDuration(any())).thenAnswer((_) async => true);
  });

  SpySettingsBloc buildBloc() => SpySettingsBloc(
    getSpySettingsUseCase: getSpySettings,
    updatePlayerCountUseCase: updatePlayerCount,
    updateSpyCountUseCase: updateSpyCount,
    updateSpyRoundDurationUseCase: updateSpyRoundDuration,
  );

  test('starts from the persisted settings', () {
    when(
      getSpySettings.call,
    ).thenReturn(const SpySettingsEntity(playerCount: 8));

    final bloc = buildBloc();
    addTearDown(bloc.close);

    expect(bloc.state.spySettings.playerCount, 8);
  });

  test('ChangePlayerCount applies and persists', () async {
    final bloc = buildBloc()..add(const ChangePlayerCount(6));
    addTearDown(bloc.close);
    await pumpEventQueue();

    expect(bloc.state.spySettings.playerCount, 6);
    verify(() => updatePlayerCount(6)).called(1);
    verifyNever(() => updateSpyCount(any()));
  });

  test('lowering players clamps the spy count and persists both', () async {
    when(getSpySettings.call).thenReturn(
      const SpySettingsEntity(spyCount: 4),
    );

    final bloc = buildBloc()..add(const ChangePlayerCount(3));
    addTearDown(bloc.close);
    await pumpEventQueue();

    expect(bloc.state.spySettings.playerCount, 3);
    expect(bloc.state.spySettings.spyCount, 3);
    verify(() => updatePlayerCount(3)).called(1);
    verify(() => updateSpyCount(3)).called(1);
  });

  test('ChangeSpyCount applies and persists', () async {
    final bloc = buildBloc()..add(const ChangeSpyCount(2));
    addTearDown(bloc.close);
    await pumpEventQueue();

    expect(bloc.state.spySettings.spyCount, 2);
    verify(() => updateSpyCount(2)).called(1);
  });

  test('ChangeRoundDuration applies and persists', () async {
    final bloc = buildBloc()..add(const ChangeRoundDuration(600));
    addTearDown(bloc.close);
    await pumpEventQueue();

    expect(bloc.state.spySettings.roundDuration, 600);
    verify(() => updateSpyRoundDuration(600)).called(1);
  });
}
