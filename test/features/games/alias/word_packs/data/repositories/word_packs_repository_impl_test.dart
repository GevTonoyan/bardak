import 'package:bardak/features/games/alias/word_packs/data/data_sources/word_packs_local_data_source.dart';
import 'package:bardak/features/games/alias/word_packs/data/data_sources/word_packs_remote_data_source.dart';
import 'package:bardak/features/games/alias/word_packs/data/repositories/word_packs_repository_impl.dart';
import 'package:bardak/features/games/alias/word_packs/domain/entities/word_pack_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockLocalDataSource extends Mock implements WordPacksLocalDataSource {}

class _MockRemoteDataSource extends Mock implements WordPacksRemoteDataSource {}

const _pack = WordPackEntity(
  id: 'animals',
  name: 'Animals',
  words: ['Cat'],
  image: '',
  imageBlurHash: '',
);

void main() {
  late _MockLocalDataSource local;
  late _MockRemoteDataSource remote;
  late WordPacksRepositoryImpl repository;

  setUp(() {
    local = _MockLocalDataSource();
    remote = _MockRemoteDataSource();
    repository = WordPacksRepositoryImpl(
      localDataSource: local,
      remoteDataSource: remote,
    );
  });

  group('areWordPacksCached', () {
    test('true only when cached and the sync window is fresh', () async {
      when(() => local.areWordPacksCached('en')).thenAnswer((_) async => true);
      when(local.isSyncNeeded).thenReturn(false);

      expect(await repository.areWordPacksCached('en'), isTrue);
    });

    test('false when the cache is stale', () async {
      when(() => local.areWordPacksCached('en')).thenAnswer((_) async => true);
      when(local.isSyncNeeded).thenReturn(true);

      expect(await repository.areWordPacksCached('en'), isFalse);
    });

    test('false when nothing is cached', () async {
      when(() => local.areWordPacksCached('en')).thenAnswer((_) async => false);
      when(local.isSyncNeeded).thenReturn(false);

      expect(await repository.areWordPacksCached('en'), isFalse);
    });
  });

  group('downloadWordPacks', () {
    test('caches the remote packs and stamps the sync time', () async {
      when(
        () => remote.getWordPacks('en'),
      ).thenAnswer((_) async => const [_pack]);
      when(
        () => local.cacheWordPacks('en', const [_pack]),
      ).thenAnswer((_) async {});
      when(local.updateLastSyncTimestamp).thenAnswer((_) async {});

      await repository.downloadWordPacks('en');

      verifyInOrder([
        () => remote.getWordPacks('en'),
        () => local.cacheWordPacks('en', const [_pack]),
        local.updateLastSyncTimestamp,
      ]);
    });
  });

  test('getWordPacks and fallbacks delegate to the local source', () async {
    when(() => local.getWordPacks('en')).thenAnswer((_) async => const [_pack]);
    when(() => local.getFallbackWordPacks('en')).thenReturn(const [_pack]);

    expect(await repository.getWordPacks('en'), const [_pack]);
    expect(repository.getFallbackWordPacks('en'), const [_pack]);
    verifyNever(() => remote.getWordPacks(any()));
  });
}
