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
}
