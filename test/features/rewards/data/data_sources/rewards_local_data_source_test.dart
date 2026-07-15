import 'package:bardak/features/rewards/data/data_sources/rewards_local_data_source.dart';
import 'package:bardak/features/rewards/domain/entities/coin_balance_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late RewardsLocalDataSourceImpl dataSource;

  Future<void> setUpWith(Map<String, Object> values) async {
    SharedPreferences.setMockInitialValues(values);
    dataSource = RewardsLocalDataSourceImpl(
      preferences: await SharedPreferences.getInstance(),
    );
  }

  test('returns the initial balance when nothing is stored', () async {
    await setUpWith(const {});

    expect(dataSource.getCoinBalance(), CoinBalanceEntity.initial());
  });

  test('corrupt stored JSON falls back to the initial balance', () async {
    await setUpWith(const {'coin_balance': 'not json at all'});

    expect(dataSource.getCoinBalance(), CoinBalanceEntity.initial());
  });

  test('updates round-trip through getCoinBalance', () async {
    await setUpWith(const {});
    final updated = CoinBalanceEntity.initial().copyWith(
      coins: 120,
      openedBoxes: {1: 40},
    );

    expect(await dataSource.updateCoinBalance(updated), isTrue);
    expect(dataSource.getCoinBalance(), updated);
  });

  test('a successful update is emitted on the watch stream', () async {
    await setUpWith(const {});
    final updated = CoinBalanceEntity.initial().copyWith(coins: 60);

    final emission = dataSource.watchCoinBalance().first;
    await dataSource.updateCoinBalance(updated);

    expect(await emission, updated);
  });
}
