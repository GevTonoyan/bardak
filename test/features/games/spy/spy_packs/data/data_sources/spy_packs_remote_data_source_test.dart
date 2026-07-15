import 'package:bardak/features/games/spy/spy_packs/data/data_sources/spy_packs_remote_data_source.dart';
import 'package:bardak/features/games/spy/spy_packs/domain/entities/spy_pack_entity.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late FakeFirebaseFirestore firestore;
  late SpyPacksRemoteDataSourceImpl dataSource;

  setUp(() {
    firestore = FakeFirebaseFirestore();
    dataSource = SpyPacksRemoteDataSourceImpl(firestore: firestore);
  });

  test('maps every field of the locale doc to a pack', () async {
    await firestore.collection('spy_packs').doc('en').set({
      'locations': {
        'name': 'Locations',
        'words': ['Beach', 'Hospital'],
        'image': 'url',
        'image_blur_hash': 'hash',
      },
      'food': {
        'name': 'Food',
        'words': ['Pizza'],
      },
    });

    final packs = await dataSource.getSpyPacks('en');

    expect(packs, hasLength(2));
    expect(
      packs,
      contains(
        const SpyPackEntity(
          id: 'locations',
          name: 'Locations',
          words: ['Beach', 'Hospital'],
          image: 'url',
          imageBlurHash: 'hash',
        ),
      ),
    );
    // Optional image fields default to empty.
    expect(
      packs,
      contains(
        const SpyPackEntity(
          id: 'food',
          name: 'Food',
          words: ['Pizza'],
          image: '',
          imageBlurHash: '',
        ),
      ),
    );
  });

  test('a locale without a document yields no packs', () async {
    await firestore.collection('spy_packs').doc('en').set({
      'locations': {'name': 'Locations', 'words': <String>[]},
    });

    expect(await dataSource.getSpyPacks('ru'), isEmpty);
  });

  test('an empty locale document yields no packs', () async {
    await firestore.collection('spy_packs').doc('en').set(<String, dynamic>{});

    expect(await dataSource.getSpyPacks('en'), isEmpty);
  });
}
