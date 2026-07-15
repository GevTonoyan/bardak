import 'package:bardak/features/games/spy/spy_settings/domain/entities/spy_settings_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SpySettingsEntity defaults', () {
    test('match the documented spy defaults', () {
      const settings = SpySettingsEntity();

      expect(settings.playerCount, 4);
      expect(settings.spyCount, 1);
      expect(settings.roundDuration, 5 * 60);
    });
  });

  group('player count bounds', () {
    test('cannot decrease below 3', () {
      const settings = SpySettingsEntity(playerCount: 3);

      expect(settings.canDecreasePlayerCount, isFalse);
      expect(settings.canIncreasePlayerCount, isTrue);
    });

    test('cannot increase above 30', () {
      const settings = SpySettingsEntity(playerCount: 30);

      expect(settings.canIncreasePlayerCount, isFalse);
      expect(settings.canDecreasePlayerCount, isTrue);
    });
  });

  group('spy count bounds', () {
    test('cannot decrease below 1', () {
      const settings = SpySettingsEntity();

      expect(settings.canDecreaseSpyCount, isFalse);
    });

    test('spies can go up to every player being a spy', () {
      const settings = SpySettingsEntity(spyCount: 3);

      expect(settings.maxSpyCount, settings.playerCount);
      expect(settings.canIncreaseSpyCount, isTrue);
      expect(
        const SpySettingsEntity(spyCount: 4).canIncreaseSpyCount,
        isFalse,
      );
    });
  });

  group('round duration', () {
    test('cannot decrease below one minute', () {
      const settings = SpySettingsEntity(roundDuration: 60);

      expect(settings.canDecreaseRoundDuration, isFalse);
      expect(settings.canIncreaseRoundDuration, isTrue);
    });

    test('cannot increase above twenty minutes', () {
      const settings = SpySettingsEntity(roundDuration: 20 * 60);

      expect(settings.canIncreaseRoundDuration, isFalse);
      expect(settings.canDecreaseRoundDuration, isTrue);
    });

    test('roundDurationInMinutes shows whole minutes', () {
      expect(
        const SpySettingsEntity().roundDurationInMinutes,
        5,
      );
      expect(
        const SpySettingsEntity(roundDuration: 90).roundDurationInMinutes,
        1,
      );
    });
  });

  group('copyWith', () {
    test('replaces only the given fields', () {
      const settings = SpySettingsEntity();

      final updated = settings.copyWith(spyCount: 2);

      expect(updated.spyCount, 2);
      expect(updated.playerCount, settings.playerCount);
      expect(updated.roundDuration, settings.roundDuration);
    });
  });
}
