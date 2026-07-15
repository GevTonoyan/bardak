import 'package:bardak/features/rewards/domain/entities/coin_balance_entity.dart';
import 'package:flutter_test/flutter_test.dart';

String _yyyyMmDd(DateTime d) =>
    '${d.year}-'
    '${d.month.toString().padLeft(2, '0')}-'
    '${d.day.toString().padLeft(2, '0')}';

void main() {
  final today = DateTime.now();
  final todayString = _yyyyMmDd(today);

  group('CoinBalanceEntity.initial', () {
    test('starts with zero coins and no opened boxes today', () {
      final balance = CoinBalanceEntity.initial();

      expect(balance.coins, 0);
      expect(balance.openedBoxesToday, isEmpty);
      expect(balance.hasReachedDailyLimit, isFalse);
    });
  });

  group('CoinBalanceEntity.fromJson', () {
    test('parses coins and today opened boxes', () {
      final balance = CoinBalanceEntity.fromJson({
        'coins': 120,
        'boxesDay': todayString,
        'openedBoxes': const {'0': 10, '2': 25},
      });

      expect(balance.coins, 120);
      expect(balance.openedBoxesToday, {0: 10, 2: 25});
      expect(balance.openedCountToday, 2);
      expect(balance.isBoxOpened(0), isTrue);
      expect(balance.isBoxOpened(1), isFalse);
    });

    test('resets opened boxes recorded on a previous day', () {
      final balance = CoinBalanceEntity.fromJson(const {
        'coins': 50,
        'boxesDay': '2020-01-01',
        'openedBoxes': {'0': 10, '1': 20, '2': 30},
      });

      expect(balance.coins, 50);
      expect(balance.openedBoxesToday, isEmpty);
      expect(balance.hasReachedDailyLimit, isFalse);
    });

    test('ignores invalid box indexes', () {
      final balance = CoinBalanceEntity.fromJson({
        'coins': 0,
        'boxesDay': todayString,
        'openedBoxes': const {'-1': 5, '9': 5, 'abc': 5, '3': 15},
      });

      expect(balance.openedBoxesToday, {3: 15});
    });

    test('missing fields fall back to defaults', () {
      final balance = CoinBalanceEntity.fromJson(const {});

      expect(balance.coins, 0);
      expect(balance.openedBoxesToday, isEmpty);
    });

    test('malformed boxesDay falls back to today', () {
      final balance = CoinBalanceEntity.fromJson(const {
        'coins': 5,
        'boxesDay': 'not-a-date',
        'openedBoxes': {'1': 10},
      });

      // Fallback day is today, so the boxes count as today's.
      expect(balance.openedBoxesToday, {1: 10});
    });
  });

  group('daily limit', () {
    test('reached after $maxBoxesPerDay boxes', () {
      final balance = CoinBalanceEntity.fromJson({
        'coins': 0,
        'boxesDay': todayString,
        'openedBoxes': const {'0': 1, '1': 2, '2': 3},
      });

      expect(balance.hasReachedDailyLimit, isTrue);
    });
  });

  group('toJson', () {
    test('round-trips through fromJson', () {
      final original = CoinBalanceEntity.fromJson({
        'coins': 75,
        'boxesDay': todayString,
        'openedBoxes': const {'1': 10},
      });

      final restored = CoinBalanceEntity.fromJson(original.toJson());

      expect(restored, original);
    });
  });
}
