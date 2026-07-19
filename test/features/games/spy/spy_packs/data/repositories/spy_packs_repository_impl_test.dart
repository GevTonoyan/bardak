import 'package:bardak/features/games/spy/spy_packs/data/data_sources/spy_packs_local_data_source.dart';
import 'package:bardak/features/games/spy/spy_packs/data/data_sources/spy_packs_remote_data_source.dart';
import 'package:bardak/features/games/spy/spy_packs/data/repositories/spy_packs_repository_impl.dart';
import 'package:bardak/features/games/spy/spy_packs/domain/entities/spy_pack_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockLocalDataSource extends Mock implements SpyPacksLocalDataSource {}

class _MockRemoteDataSource extends Mock implements SpyPacksRemoteDataSource {}

SpyPackEntity _pack(List<String> words) => SpyPackEntity(
  id: 'locations',
  name: 'Locations',
  words: words,
  image: '',
  imageBlurHash: '',
);

void main() {
  late _MockLocalDataSource local;
  late _MockRemoteDataSource remote;
  late SpyPacksRepositoryImpl repository;

  setUp(() {
    local = _MockLocalDataSource();
    remote = _MockRemoteDataSource();
    repository = SpyPacksRepositoryImpl(
      localDataSource: local,
      remoteDataSource: remote,
    );
    when(
      () => local.updateUsedSecrets(any(), any(), any()),
    ).thenAnswer((_) async => true);
  });

  group('areSpyPacksCached', () {
    test('true only when cached and the sync window is fresh', () async {
      when(() => local.areSpyPacksCached('en')).thenAnswer((_) async => true);
      when(local.isSyncNeeded).thenReturn(false);

      expect(await repository.areSpyPacksCached('en'), isTrue);
    });

    test('false when the cache is stale', () async {
      when(() => local.areSpyPacksCached('en')).thenAnswer((_) async => true);
      when(local.isSyncNeeded).thenReturn(true);

      expect(await repository.areSpyPacksCached('en'), isFalse);
    });

    test('false when nothing is cached', () async {
      when(() => local.areSpyPacksCached('en')).thenAnswer((_) async => false);
      when(local.isSyncNeeded).thenReturn(false);

      expect(await repository.areSpyPacksCached('en'), isFalse);
    });
  });

  group('downloadSpyPacks', () {
    test('caches the remote packs and stamps the sync time', () async {
      final packs = [
        _pack(const ['Beach']),
      ];
      when(() => remote.getSpyPacks('en')).thenAnswer((_) async => packs);
      when(() => local.cacheSpyPacks('en', packs)).thenAnswer((_) async {});
      when(local.updateLastSyncTimestamp).thenAnswer((_) async {});

      await repository.downloadSpyPacks('en');

      verifyInOrder([
        () => remote.getSpyPacks('en'),
        () => local.cacheSpyPacks('en', packs),
        local.updateLastSyncTimestamp,
      ]);
    });
  });

  group('drawSecret', () {
    test('throws on a pack with no words', () async {
      expect(
        () => repository.drawSecret(localeCode: 'en', pack: _pack(const [])),
        throwsStateError,
      );
    });

    test('draws only words that were not played yet', () async {
      when(
        () => local.getUsedSecrets('en', 'locations'),
      ).thenReturn(const ['Beach', 'Hospital']);

      final secret = await repository.drawSecret(
        localeCode: 'en',
        pack: _pack(const ['Beach', 'Hospital', 'School']),
      );

      expect(secret, 'School');
    });

    test('records the drawn word in play order', () async {
      when(
        () => local.getUsedSecrets('en', 'locations'),
      ).thenReturn(const ['Beach']);

      await repository.drawSecret(
        localeCode: 'en',
        pack: _pack(const ['Beach', 'School']),
      );

      verify(
        () => local.updateUsedSecrets('en', 'locations', [
          'Beach',
          'School',
        ]),
      ).called(1);
    });

    test('reshuffles an exhausted deck avoiding an immediate repeat', () async {
      when(
        () => local.getUsedSecrets('en', 'locations'),
      ).thenReturn(const ['School', 'Beach']);

      // The whole pack was played; 'Beach' was last, so it cannot repeat.
      final secret = await repository.drawSecret(
        localeCode: 'en',
        pack: _pack(const ['Beach', 'School']),
      );

      expect(secret, 'School');
      // The deck restarted: only the new draw is recorded.
      verify(
        () => local.updateUsedSecrets('en', 'locations', ['School']),
      ).called(1);
    });

    test('a one-word pack can repeat its only word', () async {
      when(
        () => local.getUsedSecrets('en', 'locations'),
      ).thenReturn(const ['Beach']);

      final secret = await repository.drawSecret(
        localeCode: 'en',
        pack: _pack(const ['Beach']),
      );

      expect(secret, 'Beach');
    });

    test('never repeats until the deck is exhausted', () async {
      // Simulate three consecutive games with a stateful fake store.
      var used = <String>[];
      when(
        () => local.getUsedSecrets('en', 'locations'),
      ).thenAnswer((_) => used);
      when(() => local.updateUsedSecrets(any(), any(), any())).thenAnswer((
        invocation,
      ) async {
        used = List<String>.from(
          invocation.positionalArguments[2] as List<String>,
        );
        return true;
      });

      final pack = _pack(const ['a', 'b', 'c']);
      final drawn = <String>{};
      for (var i = 0; i < 3; i++) {
        drawn.add(await repository.drawSecret(localeCode: 'en', pack: pack));
      }

      expect(drawn, {'a', 'b', 'c'});
    });
  });

  test('getSpyPacks and fallbacks delegate to the local source', () async {
    final packs = [
      _pack(const ['Beach']),
    ];
    when(() => local.getSpyPacks('en')).thenAnswer((_) async => packs);
    when(() => local.getFallbackSpyPacks('en')).thenReturn(packs);

    expect(await repository.getSpyPacks('en'), packs);
    expect(repository.getFallbackSpyPacks('en'), packs);
    verifyNever(() => remote.getSpyPacks(any()));
  });
}
