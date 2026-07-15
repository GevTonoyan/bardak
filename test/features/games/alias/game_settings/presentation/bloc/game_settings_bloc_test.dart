import 'package:bardak/features/games/alias/game_settings/domain/entities/game_mode.dart';
import 'package:bardak/features/games/alias/game_settings/domain/entities/game_settings_entity.dart';
import 'package:bardak/features/games/alias/game_settings/domain/usecases/get_game_settings_usecase.dart';
import 'package:bardak/features/games/alias/game_settings/domain/usecases/update_allow_skipping_usecase.dart';
import 'package:bardak/features/games/alias/game_settings/domain/usecases/update_game_mode_usecase.dart';
import 'package:bardak/features/games/alias/game_settings/domain/usecases/update_points_to_win_usecase.dart';
import 'package:bardak/features/games/alias/game_settings/domain/usecases/update_round_duration_usecase.dart';
import 'package:bardak/features/games/alias/game_settings/presentation/bloc/game_settings_bloc.dart';
import 'package:bardak/features/games/alias/game_settings/presentation/bloc/game_settings_event.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockGetGameSettings extends Mock implements GetGameSettingsUseCase {}

class _MockUpdateGameMode extends Mock implements UpdateGameModeUseCase {}

class _MockUpdateRoundDuration extends Mock
    implements UpdateRoundDurationUseCase {}

class _MockUpdatePointsToWin extends Mock implements UpdatePointsToWinUseCase {}

class _MockUpdateAllowSkipping extends Mock
    implements UpdateAllowSkippingUseCase {}

void main() {
  setUpAll(() {
    registerFallbackValue(GameMode.card);
  });

  late _MockGetGameSettings getGameSettings;
  late _MockUpdateGameMode updateGameMode;
  late _MockUpdateRoundDuration updateRoundDuration;
  late _MockUpdatePointsToWin updatePointsToWin;
  late _MockUpdateAllowSkipping updateAllowSkipping;

  setUp(() {
    getGameSettings = _MockGetGameSettings();
    updateGameMode = _MockUpdateGameMode();
    updateRoundDuration = _MockUpdateRoundDuration();
    updatePointsToWin = _MockUpdatePointsToWin();
    updateAllowSkipping = _MockUpdateAllowSkipping();
    when(getGameSettings.call).thenReturn(const GameSettingsEntity());
  });

  GameSettingsBloc buildBloc() => GameSettingsBloc(
    getGameSettingsUseCase: getGameSettings,
    updateGameModeUseCase: updateGameMode,
    updateRoundDurationUseCase: updateRoundDuration,
    updatePointsToWinUseCase: updatePointsToWin,
    updateAllowSkippingUseCase: updateAllowSkipping,
  );

  test('starts from the persisted settings', () {
    when(
      getGameSettings.call,
    ).thenReturn(const GameSettingsEntity(pointsToWin: 90));

    final bloc = buildBloc();
    addTearDown(bloc.close);

    expect(bloc.state.gameSettings.pointsToWin, 90);
  });

  test('ChangeGameMode applies and persists', () async {
    when(
      () => updateGameMode(GameMode.singleWord),
    ).thenAnswer((_) async => true);

    final bloc = buildBloc()..add(const ChangeGameMode(GameMode.singleWord));
    addTearDown(bloc.close);
    await pumpEventQueue();

    expect(bloc.state.gameSettings.gameMode, GameMode.singleWord);
    verify(() => updateGameMode(GameMode.singleWord)).called(1);
  });

  test('ChangeGameMode to the current mode is a no-op', () async {
    final bloc = buildBloc()..add(const ChangeGameMode(GameMode.card));
    addTearDown(bloc.close);
    await pumpEventQueue();

    verifyNever(() => updateGameMode(any()));
  });

  test('ChangeRoundDuration applies and persists', () async {
    when(() => updateRoundDuration(90)).thenAnswer((_) async => true);

    final bloc = buildBloc()..add(const ChangeRoundDuration(90));
    addTearDown(bloc.close);
    await pumpEventQueue();

    expect(bloc.state.gameSettings.roundDuration, 90);
    verify(() => updateRoundDuration(90)).called(1);
  });

  test('ChangePointsToWin applies and persists', () async {
    when(() => updatePointsToWin(100)).thenAnswer((_) async => true);

    final bloc = buildBloc()..add(const ChangePointsToWin(100));
    addTearDown(bloc.close);
    await pumpEventQueue();

    expect(bloc.state.gameSettings.pointsToWin, 100);
    verify(() => updatePointsToWin(100)).called(1);
  });

  test('ChangeAllowSkipping applies and persists', () async {
    when(
      () => updateAllowSkipping(allowSkipping: false),
    ).thenAnswer((_) async => true);

    final bloc = buildBloc()
      ..add(const ChangeAllowSkipping(allowSkipping: false));
    addTearDown(bloc.close);
    await pumpEventQueue();

    expect(bloc.state.gameSettings.allowSkipping, isFalse);
    verify(() => updateAllowSkipping(allowSkipping: false)).called(1);
  });
}
