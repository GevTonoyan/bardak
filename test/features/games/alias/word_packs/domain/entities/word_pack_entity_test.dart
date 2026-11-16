import 'package:bardak/features/games/alias/word_packs/domain/entities/word_pack_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('WordPackEntity.fromJson', () {
    test('parses a complete Firestore doc', () {
      final pack = WordPackEntity.fromJson('animals', const {
        'name': 'Animals',
        'words': ['Cat', 'Dog'],
        'image': 'https://example.com/a.webp',
        'image_blur_hash': 'LKO2?U%2Tw=w',
      });

      expect(pack.id, 'animals');
      expect(pack.name, 'Animals');
      expect(pack.words, ['Cat', 'Dog']);
      expect(pack.image, 'https://example.com/a.webp');
      expect(pack.imageBlurHash, 'LKO2?U%2Tw=w');
    });

    test('missing words default to empty', () {
      final pack = WordPackEntity.fromJson('animals', const {
        'name': 'Animals',
        'image': '',
        'image_blur_hash': '',
      });

      expect(pack.words, isEmpty);
    });
  });

  group('easy words', () {
    WordPackEntity pack({List<String> easyWords = const []}) => WordPackEntity(
      id: 'animals',
      name: 'Animals',
      words: const ['Cat', 'Dog', 'Platypus'],
      easyWords: easyWords,
      image: '',
      imageBlurHash: '',
    );

    test('fromJson parses the easy list', () {
      final parsed = WordPackEntity.fromJson('animals', const {
        'name': 'Animals',
        'words': ['Cat', 'Dog', 'Platypus'],
        'easy': ['Cat', 'Dog'],
        'image': '',
        'image_blur_hash': '',
      });

      expect(parsed.easyWords, ['Cat', 'Dog']);
      expect(parsed.hasEasyWords, isTrue);
    });

    test('a missing easy list means no easy mode', () {
      final parsed = WordPackEntity.fromJson('animals', const {
        'name': 'Animals',
        'words': ['Cat'],
        'image': '',
        'image_blur_hash': '',
      });

      expect(parsed.easyWords, isEmpty);
      expect(parsed.hasEasyWords, isFalse);
    });

    test('wordsFor plays all words outside easy mode', () {
      expect(
        pack(easyWords: const ['Cat']).wordsFor(easyMode: false),
        ['Cat', 'Dog', 'Platypus'],
      );
    });

    test('wordsFor plays only easy words in easy mode', () {
      expect(
        pack(easyWords: const ['Cat']).wordsFor(easyMode: true),
        ['Cat'],
      );
    });

    test('wordsFor has nothing to play in easy mode without easy words', () {
      expect(pack().wordsFor(easyMode: true), isEmpty);
    });
  });
}
