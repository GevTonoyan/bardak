import 'package:bardak/features/games/spy/spy_packs/domain/entities/spy_pack_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SpyPackEntity.fromJson', () {
    test('parses a complete Firestore doc', () {
      final pack = SpyPackEntity.fromJson('locations', const {
        'name': 'Locations',
        'words': ['Beach', 'Hospital'],
        'image': 'https://example.com/a.webp',
        'image_blur_hash': 'LKO2?U%2Tw=w',
      });

      expect(pack.id, 'locations');
      expect(pack.name, 'Locations');
      expect(pack.words, ['Beach', 'Hospital']);
      expect(pack.image, 'https://example.com/a.webp');
      expect(pack.imageBlurHash, 'LKO2?U%2Tw=w');
    });

    test('image fields and words are optional', () {
      final pack = SpyPackEntity.fromJson('locations', const {
        'name': 'Locations',
      });

      expect(pack.words, isEmpty);
      expect(pack.image, '');
      expect(pack.imageBlurHash, '');
    });
  });
}
