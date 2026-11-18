import 'package:bardak/features/games/sea_battle/sea_battle_settings/domain/entities/sea_battle_bot_difficulty.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_settings/domain/entities/sea_battle_mode.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_settings/domain/entities/sea_battle_settings_entity.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_settings/domain/usecases/get_sea_battle_settings_usecase.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_settings/domain/usecases/update_sea_battle_bot_difficulty_usecase.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_settings/domain/usecases/update_sea_battle_mode_usecase.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_settings/presentation/bloc/sea_battle_settings_bloc.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_settings/presentation/bloc/sea_battle_settings_event.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockGetSeaBattleSettings extends Mock
    implements GetSeaBattleSettingsUseCase {}

class _MockUpdateSeaBattleMode extends Mock
    implements UpdateSeaBattleModeUseCase {}

class _MockUpdateSeaBattleBotDifficulty extends Mock
    implements UpdateSeaBattleBotDifficultyUseCase {}

void main() {
  late _MockGetSeaBattleSettings getSeaBattleSettings;
  late _MockUpdateSeaBattleMode updateSeaBattleMode;
  late _MockUpdateSeaBattleBotDifficulty updateSeaBattleBotDifficulty;

  setUpAll(() {
    registerFallbackValue(SeaBattleMode.vsBot);
    registerFallbackValue(SeaBattleBotDifficulty.medium);
  });

  setUp(() {
    getSeaBattleSettings = _MockGetSeaBattleSettings();
    updateSeaBattleMode = _MockUpdateSeaBattleMode();
    updateSeaBattleBotDifficulty = _MockUpdateSeaBattleBotDifficulty();
    when(getSeaBattleSettings.call).thenReturn(const SeaBattleSettingsEntity());
    when(() => updateSeaBattleMode(any())).thenAnswer((_) async => true);
    when(
      () => updateSeaBattleBotDifficulty(any()),
    ).thenAnswer((_) async => true);
  });

  SeaBattleSettingsBloc buildBloc() => SeaBattleSettingsBloc(
    getSeaBattleSettingsUseCase: getSeaBattleSettings,
    updateSeaBattleModeUseCase: updateSeaBattleMode,
    updateSeaBattleBotDifficultyUseCase: updateSeaBattleBotDifficulty,
  );

  test('starts from the persisted settings', () {
    when(getSeaBattleSettings.call).thenReturn(
      const SeaBattleSettingsEntity(
        botDifficulty: SeaBattleBotDifficulty.hard,
      ),
    );

    final bloc = buildBloc();
    addTearDown(bloc.close);

    expect(
      bloc.state.seaBattleSettings.botDifficulty,
      SeaBattleBotDifficulty.hard,
    );
  });

  test('ChangeSeaBattleMode applies and persists', () async {
    final bloc = buildBloc()
      ..add(const ChangeSeaBattleMode(SeaBattleMode.online));
    addTearDown(bloc.close);
    await pumpEventQueue();

    expect(bloc.state.seaBattleSettings.mode, SeaBattleMode.online);
    verify(() => updateSeaBattleMode(SeaBattleMode.online)).called(1);
  });

  test('ChangeBotDifficulty applies and persists', () async {
    final bloc = buildBloc()
      ..add(const ChangeBotDifficulty(SeaBattleBotDifficulty.easy));
    addTearDown(bloc.close);
    await pumpEventQueue();

    expect(
      bloc.state.seaBattleSettings.botDifficulty,
      SeaBattleBotDifficulty.easy,
    );
    verify(
      () => updateSeaBattleBotDifficulty(SeaBattleBotDifficulty.easy),
    ).called(1);
  });

  test('selecting the current value does not persist again', () async {
    final bloc = buildBloc()
      ..add(const ChangeSeaBattleMode(SeaBattleMode.vsBot))
      ..add(const ChangeBotDifficulty(SeaBattleBotDifficulty.medium));
    addTearDown(bloc.close);
    await pumpEventQueue();

    verifyNever(() => updateSeaBattleMode(any()));
    verifyNever(() => updateSeaBattleBotDifficulty(any()));
  });
}
