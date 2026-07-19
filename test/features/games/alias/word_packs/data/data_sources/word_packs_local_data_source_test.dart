import 'dart:io';

import 'package:bardak/features/games/alias/word_packs/data/data_sources/word_packs_local_data_source.dart';
import 'package:bardak/features/games/alias/word_packs/domain/entities/word_pack_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _pack = WordPackEntity(
  id: 'animals',
  name: 'Animals',
  words: ['Cat', 'Dog'],
  image: 'url',
  imageBlurHash: 'hash',
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory hiveDir;
  late WordPacksLocalDataSourceImpl dataSource;

  setUp(() async {
    hiveDir = Directory.systemTemp.createTempSync('word_packs_test');
    Hive.init(hiveDir.path);
    SharedPreferences.setMockInitialValues(const {});
    dataSource = WordPacksLocalDataSourceImpl(
      preferences: await SharedPreferences.getInstance(),
    );
  });

  tearDown(() async {
    await Hive.deleteFromDisk();
    await Hive.close();
    hiveDir.deleteSync(recursive: true);
  });

  group('pack cache', () {
    test('nothing is cached initially', () async {
      expect(await dataSource.areWordPacksCached('en'), isFalse);
    });

    test('cached packs round-trip', () async {
      await dataSource.cacheWordPacks('en', const [_pack]);

      expect(await dataSource.areWordPacksCached('en'), isTrue);
      expect(await dataSource.getWordPacks('en'), const [_pack]);
    });

    test('caching replaces the previous packs entirely', () async {
      await dataSource.cacheWordPacks('en', const [_pack]);

      const replacement = WordPackEntity(
        id: 'food',
        name: 'Food',
        words: ['Pizza'],
        image: '',
        imageBlurHash: '',
      );
      await dataSource.cacheWordPacks('en', const [replacement]);

      expect(await dataSource.getWordPacks('en'), const [replacement]);
    });

    test('locales are cached independently', () async {
      await dataSource.cacheWordPacks('en', const [_pack]);

      expect(await dataSource.areWordPacksCached('ru'), isFalse);
    });
  });

  group('sync window', () {
    test('sync is needed before the first sync', () {
      expect(dataSource.isSyncNeeded(), isTrue);
    });

    test('sync is not needed right after a sync', () async {
      await dataSource.updateLastSyncTimestamp();

      expect(dataSource.isSyncNeeded(), isFalse);
    });
  });

  test('fallback packs carry a blur hash but no words', () {
    final fallbacks = dataSource.getFallbackWordPacks('en');

    expect(fallbacks, isNotEmpty);
    for (final pack in fallbacks) {
      expect(pack.imageBlurHash, isNotEmpty);
      expect(pack.words, isEmpty);
    }
  });
}
