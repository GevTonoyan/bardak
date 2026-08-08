import 'package:bardak/core/di/di.dart';
import 'package:bardak/core/logging/app_logger.dart';
import 'package:bardak/core/logging/console_logger.dart';
import 'package:bardak/features/games/alias/word_packs/domain/entities/word_pack_entity.dart';
import 'package:bardak/features/games/alias/word_packs/domain/usecases/are_word_packs_cached_usecase.dart';
import 'package:bardak/features/games/alias/word_packs/domain/usecases/download_word_packs_usecase.dart';
import 'package:bardak/features/games/alias/word_packs/domain/usecases/get_fallback_word_packs_usecase.dart';
import 'package:bardak/features/games/alias/word_packs/domain/usecases/get_word_packs_usecase.dart';
import 'package:bardak/features/games/alias/word_packs/presentation/bloc/word_packs_bloc.dart';
import 'package:bardak/features/games/alias/word_packs/presentation/bloc/word_packs_event.dart';
import 'package:bardak/features/games/alias/word_packs/presentation/bloc/word_packs_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockGetWordPacks extends Mock implements GetWordPacksUseCase {}

class _MockGetFallbackWordPacks extends Mock
    implements GetFallbackWordPacksUseCase {}

class _MockAreWordPacksCached extends Mock
    implements AreWordPacksCachedUseCase {}

class _MockDownloadWordPacks extends Mock implements DownloadWordPacksUseCase {}

const _pack = WordPackEntity(
  id: 'animals',
  name: 'Animals',
  words: ['Cat'],
  image: 'url',
  imageBlurHash: 'hash',
);

const _fallback = WordPackEntity(
  id: 'animals',
  name: 'Animals',
  words: [],
  image: '',
  imageBlurHash: 'hash',
);

void main() {
  late _MockGetWordPacks getWordPacks;
  late _MockGetFallbackWordPacks getFallbackWordPacks;
  late _MockAreWordPacksCached areWordPacksCached;
  late _MockDownloadWordPacks downloadWordPacks;

  setUpAll(() {
    if (!sl.isRegistered<AppLogger>()) {
      sl.registerLazySingleton<AppLogger>(ConsoleLogger.new);
    }
  });

  setUp(() {
    getWordPacks = _MockGetWordPacks();
    getFallbackWordPacks = _MockGetFallbackWordPacks();
    areWordPacksCached = _MockAreWordPacksCached();
    downloadWordPacks = _MockDownloadWordPacks();
  });

  WordPacksBloc buildBloc() => WordPacksBloc(
    getWordPacksUseCase: getWordPacks,
    getFallbackWordPacksUseCase: getFallbackWordPacks,
    areWordPacksCachedUseCase: areWordPacksCached,
    downloadWordPacksUseCase: downloadWordPacks,
  );

  group('LoadWordPacks', () {
    test('emits the cached packs when the cache is fresh', () async {
      when(() => areWordPacksCached('en')).thenAnswer((_) async => true);
      when(() => getWordPacks('en')).thenAnswer((_) async => [_pack]);

      final bloc = buildBloc()..add(const LoadWordPacks('en'));
      addTearDown(bloc.close);
      await pumpEventQueue();

      expect(bloc.state, const WordPacksLoaded(packs: [_pack]));
    });

    test('emits fallback placeholders when nothing is cached', () async {
      when(() => areWordPacksCached('en')).thenAnswer((_) async => false);
      when(() => getFallbackWordPacks('en')).thenReturn([_fallback]);

      final bloc = buildBloc()..add(const LoadWordPacks('en'));
      addTearDown(bloc.close);
      await pumpEventQueue();

      expect(bloc.state, const WordPacksNotCached(fallbackPacks: [_fallback]));
      verifyNever(() => getWordPacks(any()));
    });

    test('falls back to placeholders when loading fails', () async {
      when(() => areWordPacksCached('en')).thenThrow(Exception('io'));
      when(() => getFallbackWordPacks('en')).thenReturn([_fallback]);

      final bloc = buildBloc()..add(const LoadWordPacks('en'));
      addTearDown(bloc.close);
      await pumpEventQueue();

      expect(bloc.state, const WordPacksNotCached(fallbackPacks: [_fallback]));
    });
  });

  group('DownloadWordPacks', () {
    test('downloads then reloads the packs', () async {
      when(() => downloadWordPacks('en')).thenAnswer((_) async {});
      when(() => areWordPacksCached('en')).thenAnswer((_) async => true);
      when(() => getWordPacks('en')).thenAnswer((_) async => [_pack]);

      final bloc = buildBloc()..add(const DownloadWordPacks('en'));
      addTearDown(bloc.close);
      await pumpEventQueue();

      verify(() => downloadWordPacks('en')).called(1);
      expect(bloc.state, const WordPacksLoaded(packs: [_pack]));
    });

    test('shows placeholders when the download fails', () async {
      when(() => downloadWordPacks('en')).thenThrow(Exception('offline'));
      when(() => getFallbackWordPacks('en')).thenReturn([_fallback]);

      final bloc = buildBloc()..add(const DownloadWordPacks('en'));
      addTearDown(bloc.close);
      await pumpEventQueue();

      expect(bloc.state, const WordPacksNotCached(fallbackPacks: [_fallback]));
    });

    test('a repeated failed download re-emits a distinct state', () async {
      when(() => downloadWordPacks('en')).thenThrow(Exception('offline'));
      when(() => getFallbackWordPacks('en')).thenReturn([_fallback]);

      final bloc = buildBloc();
      addTearDown(bloc.close);

      final states = <WordPacksState>[];
      final sub = bloc.stream.listen(states.add);

      bloc.add(const DownloadWordPacks('en'));
      await pumpEventQueue();
      bloc.add(const DownloadWordPacks('en'));
      await pumpEventQueue();
      await sub.cancel();

      // Two failures emit two distinct states (bumped attempt), so the
      // screen's listener fires again and re-shows the notification.
      expect(states.length, 2);
      expect(states.first, isNot(states.last));
    });
  });

  group('SyncWordPacks', () {
    test('downloads only locales that are not cached', () async {
      when(() => areWordPacksCached('en')).thenAnswer((_) async => true);
      when(() => areWordPacksCached('ru')).thenAnswer((_) async => false);
      when(() => areWordPacksCached('am')).thenAnswer((_) async => false);
      when(() => downloadWordPacks(any())).thenAnswer((_) async {});

      final bloc = buildBloc()..add(const SyncWordPacks());
      addTearDown(bloc.close);
      await pumpEventQueue();

      verifyNever(() => downloadWordPacks('en'));
      verify(() => downloadWordPacks('ru')).called(1);
      verify(() => downloadWordPacks('am')).called(1);
    });

    test('one failing locale does not stop the others', () async {
      when(() => areWordPacksCached(any())).thenAnswer((_) async => false);
      when(() => downloadWordPacks('en')).thenThrow(Exception('offline'));
      when(() => downloadWordPacks('ru')).thenAnswer((_) async {});
      when(() => downloadWordPacks('am')).thenAnswer((_) async {});

      final bloc = buildBloc()..add(const SyncWordPacks());
      addTearDown(bloc.close);
      await pumpEventQueue();

      verify(() => downloadWordPacks('ru')).called(1);
      verify(() => downloadWordPacks('am')).called(1);
    });
  });
}
