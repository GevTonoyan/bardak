import 'package:bardak/features/rewards/domain/entities/coin_balance_entity.dart';
import 'package:bardak/features/rewards/domain/repositories/rewards_repository.dart';
import 'package:bardak/features/rewards/domain/usecases/get_coin_balance_usecase.dart';
import 'package:bardak/features/rewards/domain/usecases/update_coin_balance_usecase.dart';
import 'package:bardak/features/rewards/domain/usecases/watch_coin_balance_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockRewardsRepository extends Mock implements RewardsRepository {}

void main() {
  late _MockRewardsRepository repository;

  setUp(() => repository = _MockRewardsRepository());

  test('GetCoinBalanceUseCase returns the repository balance', () {
    final balance = CoinBalanceEntity.initial();
    when(() => repository.getCoinBalance()).thenReturn(balance);

    expect(GetCoinBalanceUseCase(repository)(), balance);
  });

  test('UpdateCoinBalanceUseCase persists the balance', () async {
    final balance = CoinBalanceEntity.initial().copyWith(coins: 42);
    when(
      () => repository.updateCoinBalance(balance),
    ).thenAnswer((_) async => balance);

    expect(await UpdateCoinBalanceUseCase(repository)(balance), balance);
    verify(() => repository.updateCoinBalance(balance)).called(1);
  });

  test('WatchCoinBalanceUseCase forwards the repository stream', () {
    final balance = CoinBalanceEntity.initial();
    when(
      () => repository.watchCoinBalance(),
    ).thenAnswer((_) => Stream.value(balance));

    expect(WatchCoinBalanceUseCase(repository)(), emits(balance));
  });
}
