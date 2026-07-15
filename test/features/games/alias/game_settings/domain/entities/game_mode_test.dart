import 'package:bardak/features/games/alias/game_settings/domain/entities/game_mode.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GameMode.fromString', () {
    test('parses persisted names', () {
      expect(GameMode.fromString('card'), GameMode.card);
      expect(GameMode.fromString('singleWord'), GameMode.singleWord);
    });

    test('defaults to card for null or unknown values', () {
      expect(GameMode.fromString(null), GameMode.card);
      expect(GameMode.fromString('garbage'), GameMode.card);
      expect(GameMode.fromString(''), GameMode.card);
    });
  });
}
