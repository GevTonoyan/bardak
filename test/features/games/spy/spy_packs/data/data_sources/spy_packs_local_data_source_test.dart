import 'dart:io';

import 'package:bardak/features/games/spy/spy_packs/data/data_sources/spy_packs_local_data_source.dart';
import 'package:bardak/features/games/spy/spy_packs/domain/entities/spy_pack_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _pack = SpyPackEntity(
  id: 'locations',
  name: 'Locations',
  words: ['Beach', 'Hospital'],
  image: 'url',
  imageBlurHash: 'hash',
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory hiveDir;
  late SpyPacksLocalDataSourceImpl dataSource;

  setUp(() async {
    hiveDir = Directory.systemTemp.createTempSync('spy_packs_test');
    Hive.init(hiveDir.path);
    SharedPreferences.setMockInitialValues(const {});
    dataSource = SpyPacksLocalDataSourceImpl(
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
      expect(await dataSource.areSpyPacksCached('en'), isFalse);
    });

    test('cached packs round-trip', () async {
      await dataSource.cacheSpyPacks('en', const [_pack]);

      expect(await dataSource.areSpyPacksCached('en'), isTrue);
      expect(await dataSource.getSpyPacks('en'), const [_pack]);
    });

    test('caching replaces the previous packs entirely', () async {
      await dataSource.cacheSpyPacks('en', const [_pack]);

      const replacement = SpyPackEntity(
        id: 'food',
        name: 'Food',
        words: ['Pizza'],
        image: '',
        imageBlurHash: '',
      );
      await dataSource.cacheSpyPacks('en', const [replacement]);

      expect(await dataSource.getSpyPacks('en'), const [replacement]);
    });

    test('locales are cached independently', () async {
      await dataSource.cacheSpyPacks('en', const [_pack]);

      expect(await dataSource.areSpyPacksCached('ru'), isFalse);
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

  group('used secrets', () {
    test('starts empty per pack and locale', () {
      expect(dataSource.getUsedSecrets('en', 'locations'), isEmpty);
    });

    test('round-trips in play order, keyed by locale and pack', () async {
      await dataSource.updateUsedSecrets('en', 'locations', [
        'Beach',
        'Hospital',
      ]);

      expect(
        dataSource.getUsedSecrets('en', 'locations'),
        ['Beach', 'Hospital'],
      );
      expect(dataSource.getUsedSecrets('ru', 'locations'), isEmpty);
      expect(dataSource.getUsedSecrets('en', 'food'), isEmpty);
    });
  });

  test('fallback packs carry a blur hash but no image or words', () {
    final fallbacks = dataSource.getFallbackSpyPacks('en');

    expect(fallbacks, isNotEmpty);
    for (final pack in fallbacks) {
      expect(pack.imageBlurHash, isNotEmpty);
      expect(pack.image, isEmpty);
      expect(pack.words, isEmpty);
    }
  });

  group('custom packs', () {
    const custom = SpyPackEntity(
      id: 'custom_1',
      name: 'Friends',
      words: ['Alex', 'Sam', 'Jo'],
      image: '',
      imageBlurHash: '',
      isCustom: true,
    );

    test('start empty', () async {
      expect(await dataSource.getCustomSpyPacks(), isEmpty);
    });

    test('save and get round-trips, flagged custom with no image', () async {
      await dataSource.saveCustomSpyPack(custom);

      expect(await dataSource.getCustomSpyPacks(), [custom]);
    });

    test('saving the same id replaces the pack', () async {
      await dataSource.saveCustomSpyPack(custom);
      const edited = SpyPackEntity(
        id: 'custom_1',
        name: 'Best friends',
        words: ['Alex', 'Sam'],
        image: '',
        imageBlurHash: '',
        isCustom: true,
      );
      await dataSource.saveCustomSpyPack(edited);

      expect(await dataSource.getCustomSpyPacks(), [edited]);
    });

    test('delete removes the pack', () async {
      await dataSource.saveCustomSpyPack(custom);
      await dataSource.deleteCustomSpyPack('custom_1');

      expect(await dataSource.getCustomSpyPacks(), isEmpty);
    });

    test('survive a built-in pack cache replace', () async {
      await dataSource.saveCustomSpyPack(custom);
      await dataSource.cacheSpyPacks('en', const [_pack]);

      expect(await dataSource.getCustomSpyPacks(), [custom]);
    });
  });
}
