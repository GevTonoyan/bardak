import 'package:bardak/core/di/di.dart';
import 'package:bardak/core/logging/app_logger.dart';
import 'package:bardak/core/logging/console_logger.dart';
import 'package:bardak/features/games/spy/spy_packs/domain/entities/spy_pack_entity.dart';
import 'package:bardak/features/games/spy/spy_packs/domain/usecases/are_spy_packs_cached_usecase.dart';
import 'package:bardak/features/games/spy/spy_packs/domain/usecases/delete_custom_spy_pack_usecase.dart';
import 'package:bardak/features/games/spy/spy_packs/domain/usecases/download_spy_packs_usecase.dart';
import 'package:bardak/features/games/spy/spy_packs/domain/usecases/draw_spy_secret_usecase.dart';
import 'package:bardak/features/games/spy/spy_packs/domain/usecases/get_custom_spy_packs_usecase.dart';
import 'package:bardak/features/games/spy/spy_packs/domain/usecases/get_fallback_spy_packs_usecase.dart';
import 'package:bardak/features/games/spy/spy_packs/domain/usecases/get_spy_packs_usecase.dart';
import 'package:bardak/features/games/spy/spy_packs/domain/usecases/save_custom_spy_pack_usecase.dart';
import 'package:bardak/features/games/spy/spy_packs/presentation/bloc/spy_packs_bloc.dart';
import 'package:bardak/features/games/spy/spy_packs/presentation/bloc/spy_packs_event.dart';
import 'package:bardak/features/games/spy/spy_packs/presentation/bloc/spy_packs_state.dart';
import 'package:bardak/features/games/spy/spy_settings/domain/entities/spy_settings_entity.dart';
import 'package:bardak/features/games/spy/spy_settings/domain/usecases/get_spy_settings_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockGetSpyPacks extends Mock implements GetSpyPacksUseCase {}

class _MockGetFallbackSpyPacks extends Mock
    implements GetFallbackSpyPacksUseCase {}

class _MockAreSpyPacksCached extends Mock implements AreSpyPacksCachedUseCase {}

class _MockDownloadSpyPacks extends Mock implements DownloadSpyPacksUseCase {}

class _MockDrawSpySecret extends Mock implements DrawSpySecretUseCase {}

class _MockGetSpySettings extends Mock implements GetSpySettingsUseCase {}

class _MockGetCustomSpyPacks extends Mock
    implements GetCustomSpyPacksUseCase {}

class _MockSaveCustomSpyPack extends Mock
    implements SaveCustomSpyPackUseCase {}

class _MockDeleteCustomSpyPack extends Mock
    implements DeleteCustomSpyPackUseCase {}

const _pack = SpyPackEntity(
  id: 'locations',
  name: 'Locations',
  words: ['Beach'],
  image: 'url',
  imageBlurHash: 'hash',
);

const _customPack = SpyPackEntity(
  id: 'custom_1',
  name: 'College friends',
  words: ['Alex', 'Sam', 'Jo'],
  image: '',
  imageBlurHash: '',
  isCustom: true,
);

const _fallback = SpyPackEntity(
  id: 'locations',
  name: 'Locations',
  words: [],
  image: '',
  imageBlurHash: 'hash',
);

void main() {
  late _MockGetSpyPacks getSpyPacks;
  late _MockGetFallbackSpyPacks getFallbackSpyPacks;
  late _MockAreSpyPacksCached areSpyPacksCached;
  late _MockDownloadSpyPacks downloadSpyPacks;
  late _MockDrawSpySecret drawSpySecret;
  late _MockGetSpySettings getSpySettings;
  late _MockGetCustomSpyPacks getCustomSpyPacks;
  late _MockSaveCustomSpyPack saveCustomSpyPack;
  late _MockDeleteCustomSpyPack deleteCustomSpyPack;

  setUpAll(() {
    registerFallbackValue(
      const DrawSpySecretParams(localeCode: 'en', pack: _pack),
    );
    registerFallbackValue(
      const SaveCustomSpyPackParams(name: '', words: []),
    );
    if (!sl.isRegistered<AppLogger>()) {
      sl.registerLazySingleton<AppLogger>(ConsoleLogger.new);
    }
  });

  setUp(() {
    getSpyPacks = _MockGetSpyPacks();
    getFallbackSpyPacks = _MockGetFallbackSpyPacks();
    areSpyPacksCached = _MockAreSpyPacksCached();
    downloadSpyPacks = _MockDownloadSpyPacks();
    drawSpySecret = _MockDrawSpySecret();
    getSpySettings = _MockGetSpySettings();
    getCustomSpyPacks = _MockGetCustomSpyPacks();
    saveCustomSpyPack = _MockSaveCustomSpyPack();
    deleteCustomSpyPack = _MockDeleteCustomSpyPack();

    // Most tests have no custom packs; specific ones override this.
    when(() => getCustomSpyPacks()).thenAnswer((_) async => []);
  });

  SpyPacksBloc buildBloc() => SpyPacksBloc(
    getSpyPacksUseCase: getSpyPacks,
    getFallbackSpyPacksUseCase: getFallbackSpyPacks,
    areSpyPacksCachedUseCase: areSpyPacksCached,
    downloadSpyPacksUseCase: downloadSpyPacks,
    drawSpySecretUseCase: drawSpySecret,
    getSpySettingsUseCase: getSpySettings,
    getCustomSpyPacksUseCase: getCustomSpyPacks,
    saveCustomSpyPackUseCase: saveCustomSpyPack,
    deleteCustomSpyPackUseCase: deleteCustomSpyPack,
  );

  group('LoadSpyPacks', () {
    test('emits the cached packs when the cache is fresh', () async {
      when(() => areSpyPacksCached('en')).thenAnswer((_) async => true);
      when(() => getSpyPacks('en')).thenAnswer((_) async => [_pack]);

      final bloc = buildBloc()..add(const LoadSpyPacks('en'));
      addTearDown(bloc.close);
      await pumpEventQueue();

      expect(bloc.state, const SpyPacksLoaded(packs: [_pack]));
    });

    test('emits fallback placeholders when nothing is cached', () async {
      when(() => areSpyPacksCached('en')).thenAnswer((_) async => false);
      when(() => getFallbackSpyPacks('en')).thenReturn([_fallback]);

      final bloc = buildBloc()..add(const LoadSpyPacks('en'));
      addTearDown(bloc.close);
      await pumpEventQueue();

      expect(
        bloc.state,
        const SpyPacksNotCached(fallbackPacks: [_fallback]),
      );
      verifyNever(() => getSpyPacks(any()));
    });

    test('falls back to placeholders when loading fails', () async {
      when(() => areSpyPacksCached('en')).thenThrow(Exception('io'));
      when(() => getFallbackSpyPacks('en')).thenReturn([_fallback]);

      final bloc = buildBloc()..add(const LoadSpyPacks('en'));
      addTearDown(bloc.close);
      await pumpEventQueue();

      expect(
        bloc.state,
        const SpyPacksNotCached(fallbackPacks: [_fallback]),
      );
    });
  });

  group('DownloadSpyPacks', () {
    test('downloads then reloads the packs', () async {
      when(() => downloadSpyPacks('en')).thenAnswer((_) async {});
      when(() => areSpyPacksCached('en')).thenAnswer((_) async => true);
      when(() => getSpyPacks('en')).thenAnswer((_) async => [_pack]);

      final bloc = buildBloc()..add(const DownloadSpyPacks('en'));
      addTearDown(bloc.close);
      await pumpEventQueue();

      verify(() => downloadSpyPacks('en')).called(1);
      expect(bloc.state, const SpyPacksLoaded(packs: [_pack]));
    });

    test('shows placeholders when the download fails', () async {
      when(() => downloadSpyPacks('en')).thenThrow(Exception('offline'));
      when(() => getFallbackSpyPacks('en')).thenReturn([_fallback]);

      final bloc = buildBloc()..add(const DownloadSpyPacks('en'));
      addTearDown(bloc.close);
      await pumpEventQueue();

      expect(
        bloc.state,
        const SpyPacksNotCached(fallbackPacks: [_fallback]),
      );
    });

    test('a repeated failed download re-emits a distinct state', () async {
      when(() => downloadSpyPacks('en')).thenThrow(Exception('offline'));
      when(() => getFallbackSpyPacks('en')).thenReturn([_fallback]);

      final bloc = buildBloc();
      addTearDown(bloc.close);

      final states = <SpyPacksState>[];
      final sub = bloc.stream.listen(states.add);

      bloc.add(const DownloadSpyPacks('en'));
      await pumpEventQueue();
      bloc.add(const DownloadSpyPacks('en'));
      await pumpEventQueue();
      await sub.cancel();

      // Two failures emit two distinct states (bumped attempt), so the
      // screen's listener fires again and re-shows the notification.
      expect(states.length, 2);
      expect(states.first, isNot(states.last));
    });
  });

  group('SyncSpyPacks', () {
    test('downloads only locales that are not cached', () async {
      when(() => areSpyPacksCached('en')).thenAnswer((_) async => true);
      when(() => areSpyPacksCached('ru')).thenAnswer((_) async => false);
      when(() => areSpyPacksCached('am')).thenAnswer((_) async => false);
      when(() => downloadSpyPacks(any())).thenAnswer((_) async {});

      final bloc = buildBloc()..add(const SyncSpyPacks());
      addTearDown(bloc.close);
      await pumpEventQueue();

      verifyNever(() => downloadSpyPacks('en'));
      verify(() => downloadSpyPacks('ru')).called(1);
      verify(() => downloadSpyPacks('am')).called(1);
    });
  });

  group('StartSpyGame', () {
    test('builds a ready session from settings and a drawn secret', () async {
      when(() => areSpyPacksCached('en')).thenAnswer((_) async => true);
      when(() => getSpyPacks('en')).thenAnswer((_) async => [_pack]);
      when(getSpySettings.call).thenReturn(
        const SpySettingsEntity(playerCount: 5, spyCount: 2),
      );
      when(() => drawSpySecret(any())).thenAnswer((_) async => 'Beach');

      final bloc = buildBloc()..add(const LoadSpyPacks('en'));
      addTearDown(bloc.close);
      await pumpEventQueue();

      bloc.add(const StartSpyGame(pack: _pack, locale: 'en'));
      await pumpEventQueue();

      final state = bloc.state;
      expect(state, isA<SpyGameReady>());
      final ready = state as SpyGameReady;
      expect(ready.packs, [_pack], reason: 'pack list stays rendered');
      expect(ready.session.secretWord, 'Beach');
      expect(ready.session.pack, _pack);
      expect(ready.session.players, hasLength(5));
      expect(ready.session.players.where((p) => p.isSpy).length, 2);
      expect(
        ready.session.roundDuration,
        const SpySettingsEntity().roundDuration,
      );
    });

    test('keeps the current state when drawing a secret fails', () async {
      when(getSpySettings.call).thenReturn(const SpySettingsEntity());
      when(() => drawSpySecret(any())).thenThrow(Exception('empty deck'));

      final bloc = buildBloc()
        ..add(const StartSpyGame(pack: _pack, locale: 'en'));
      addTearDown(bloc.close);
      await pumpEventQueue();

      expect(bloc.state, const SpyPacksInitial());
    });
  });

  group('custom packs', () {
    test('LoadSpyPacks prepends custom packs to the built-in list', () async {
      when(() => getCustomSpyPacks()).thenAnswer((_) async => [_customPack]);
      when(() => areSpyPacksCached('en')).thenAnswer((_) async => true);
      when(() => getSpyPacks('en')).thenAnswer((_) async => [_pack]);

      final bloc = buildBloc()..add(const LoadSpyPacks('en'));
      addTearDown(bloc.close);
      await pumpEventQueue();

      expect(bloc.state, const SpyPacksLoaded(packs: [_customPack, _pack]));
    });

    test('custom packs also show while built-ins need downloading', () async {
      when(() => getCustomSpyPacks()).thenAnswer((_) async => [_customPack]);
      when(() => areSpyPacksCached('en')).thenAnswer((_) async => false);
      when(() => getFallbackSpyPacks('en')).thenReturn([_fallback]);

      final bloc = buildBloc()..add(const LoadSpyPacks('en'));
      addTearDown(bloc.close);
      await pumpEventQueue();

      expect(
        bloc.state,
        const SpyPacksNotCached(
          fallbackPacks: [_fallback],
          customPacks: [_customPack],
        ),
      );
    });

    test('SaveSpyPack persists then reloads', () async {
      when(() => saveCustomSpyPack(any())).thenAnswer((_) async {});
      when(() => getCustomSpyPacks()).thenAnswer((_) async => [_customPack]);
      when(() => areSpyPacksCached('en')).thenAnswer((_) async => true);
      when(() => getSpyPacks('en')).thenAnswer((_) async => [_pack]);

      final bloc = buildBloc()
        ..add(
          const SaveSpyPack(
            name: 'College friends',
            words: ['Alex', 'Sam', 'Jo'],
            locale: 'en',
          ),
        );
      addTearDown(bloc.close);
      await pumpEventQueue();

      verify(() => saveCustomSpyPack(any())).called(1);
      expect(bloc.state, const SpyPacksLoaded(packs: [_customPack, _pack]));
    });

    test('DeleteSpyPack removes then reloads', () async {
      when(() => deleteCustomSpyPack('custom_1')).thenAnswer((_) async {});
      when(() => areSpyPacksCached('en')).thenAnswer((_) async => true);
      when(() => getSpyPacks('en')).thenAnswer((_) async => [_pack]);

      final bloc = buildBloc()
        ..add(const DeleteSpyPack(id: 'custom_1', locale: 'en'));
      addTearDown(bloc.close);
      await pumpEventQueue();

      verify(() => deleteCustomSpyPack('custom_1')).called(1);
      expect(bloc.state, const SpyPacksLoaded(packs: [_pack]));
    });
  });
}
