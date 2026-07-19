import 'package:bardak/features/games/alias/word_packs/data/data_sources/word_packs_remote_data_source.dart';
import 'package:bardak/features/games/alias/word_packs/domain/entities/word_pack_entity.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late FakeFirebaseFirestore firestore;
  late WordPacksRemoteDataSourceImpl dataSource;

  setUp(() {
    firestore = FakeFirebaseFirestore();
    dataSource = WordPacksRemoteDataSourceImpl(firestore: firestore);
  });

  test('maps every field of the locale doc to a pack', () async {
    await firestore.collection('word_packs').doc('en').set({
      'animals': {
        'name': 'Animals',
        'words': ['Cat', 'Dog'],
        'image': 'url',
        'image_blur_hash': 'hash',
      },
      'food': {
        'name': 'Food',
        'words': ['Pizza'],
        'image': '',
        'image_blur_hash': '',
      },
    });

    final packs = await dataSource.getWordPacks('en');

    expect(packs, hasLength(2));
    expect(
      packs,
      contains(
        const WordPackEntity(
          id: 'animals',
          name: 'Animals',
          words: ['Cat', 'Dog'],
          image: 'url',
          imageBlurHash: 'hash',
        ),
      ),
    );
  });

  test('a locale without a document yields no packs', () async {
    await firestore.collection('word_packs').doc('en').set({
      'animals': {
        'name': 'Animals',
        'words': <String>[],
        'image': '',
        'image_blur_hash': '',
      },
    });

    expect(await dataSource.getWordPacks('ru'), isEmpty);
  });

  test('an empty locale document yields no packs', () async {
    await firestore.collection('word_packs').doc('en').set(<String, dynamic>{});

    expect(await dataSource.getWordPacks('en'), isEmpty);
  });
}
