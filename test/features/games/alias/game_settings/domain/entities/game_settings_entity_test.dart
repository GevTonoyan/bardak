import 'package:bardak/features/games/alias/game_settings/domain/entities/game_mode.dart';
import 'package:bardak/features/games/alias/game_settings/domain/entities/game_settings_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GameSettingsEntity defaults', () {
    test('match the documented game defaults', () {
      const settings = GameSettingsEntity();

      expect(settings.gameMode, GameMode.card);
      expect(settings.roundDuration, 60);
      expect(settings.pointsToWin, 60);
      expect(settings.allowSkipping, isTrue);
      expect(settings.wordsPerCard, 6);
    });
  });

  group('round duration bounds', () {
    test('can move within (30, 120)', () {
      const settings = GameSettingsEntity();

      expect(settings.canDecreaseRoundDuration, isTrue);
      expect(settings.canIncreaseRoundDuration, isTrue);
    });

    test('cannot decrease below 30', () {
      const settings = GameSettingsEntity(roundDuration: 30);

      expect(settings.canDecreaseRoundDuration, isFalse);
      expect(settings.canIncreaseRoundDuration, isTrue);
    });

    test('cannot increase above 120', () {
      const settings = GameSettingsEntity(roundDuration: 120);

      expect(settings.canIncreaseRoundDuration, isFalse);
      expect(settings.canDecreaseRoundDuration, isTrue);
    });
  });

  group('points to win bounds', () {
    test('cannot decrease below 30', () {
      const settings = GameSettingsEntity(pointsToWin: 30);

      expect(settings.canDecreasePointsToWin, isFalse);
      expect(settings.canIncreasePointsToWin, isTrue);
    });

    test('cannot increase above 120', () {
      const settings = GameSettingsEntity(pointsToWin: 120);

      expect(settings.canIncreasePointsToWin, isFalse);
      expect(settings.canDecreasePointsToWin, isTrue);
    });
  });

  group('copyWith', () {
    test('replaces only the given fields', () {
      const settings = GameSettingsEntity();

      final updated = settings.copyWith(
        gameMode: GameMode.singleWord,
        allowSkipping: false,
      );

      expect(updated.gameMode, GameMode.singleWord);
      expect(updated.allowSkipping, isFalse);
      expect(updated.roundDuration, settings.roundDuration);
      expect(updated.pointsToWin, settings.pointsToWin);
      expect(updated.wordsPerCard, settings.wordsPerCard);
    });
  });
}
