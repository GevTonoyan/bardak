import 'dart:async';

import 'package:bardak/features/rewards/domain/entities/coin_balance_entity.dart';
import 'package:bardak/features/rewards/domain/usecases/get_coin_balance_usecase.dart';
import 'package:bardak/features/rewards/domain/usecases/update_coin_balance_usecase.dart';
import 'package:bardak/features/rewards/domain/usecases/watch_coin_balance_usecase.dart';
import 'package:bardak/features/rewards/presentation/bloc/rewards_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockGetCoinBalance extends Mock implements GetCoinBalanceUseCase {}

class _MockUpdateCoinBalance extends Mock implements UpdateCoinBalanceUseCase {}

class _MockWatchCoinBalance extends Mock implements WatchCoinBalanceUseCase {}

void main() {
  late _MockGetCoinBalance getCoinBalance;
  late _MockUpdateCoinBalance updateCoinBalance;
  late _MockWatchCoinBalance watchCoinBalance;
  late StreamController<CoinBalanceEntity> balanceStream;

  setUpAll(() {
    registerFallbackValue(CoinBalanceEntity.initial());
  });

  setUp(() {
    getCoinBalance = _MockGetCoinBalance();
    updateCoinBalance = _MockUpdateCoinBalance();
    watchCoinBalance = _MockWatchCoinBalance();
    balanceStream = StreamController<CoinBalanceEntity>();
    when(getCoinBalance.call).thenReturn(CoinBalanceEntity.initial());
    when(watchCoinBalance.call).thenAnswer((_) => balanceStream.stream);
  });

  tearDown(() => balanceStream.close());

  RewardsCubit buildCubit() => RewardsCubit(
    getCoinBalanceUseCase: getCoinBalance,
    updateCoinBalanceUseCase: updateCoinBalance,
    watchCoinBalanceUseCase: watchCoinBalance,
  );

  test('starts from the current balance and follows the stream', () async {
    final cubit = buildCubit();
    addTearDown(cubit.close);

    expect(cubit.state.coinBalance.coins, 0);

    final updated = CoinBalanceEntity.initial().copyWith(coins: 40);
    balanceStream.add(updated);
    await pumpEventQueue();

    expect(cubit.state.coinBalance, updated);
  });

  group('openBox', () {
    test('grants a reward between 20 and 200 and records the box', () async {
      when(() => updateCoinBalance(any())).thenAnswer(
        (invocation) async =>
            invocation.positionalArguments.first as CoinBalanceEntity,
      );

      final cubit = buildCubit();
      addTearDown(cubit.close);

      await cubit.openBox(2);

      final saved =
          verify(() => updateCoinBalance(captureAny())).captured.single
              as CoinBalanceEntity;
      expect(saved.coins, inInclusiveRange(20, 200));
      expect(saved.coins % 20, 0);
      expect(saved.openedBoxes.keys, contains(2));
    });

    test('refuses to reopen an opened box', () async {
      when(getCoinBalance.call).thenReturn(
        CoinBalanceEntity.initial().copyWith(openedBoxes: {2: 40}),
      );

      final cubit = buildCubit();
      addTearDown(cubit.close);

      await cubit.openBox(2);

      verifyNever(() => updateCoinBalance(any()));
    });

    test('refuses once the daily limit is reached', () async {
      when(getCoinBalance.call).thenReturn(
        CoinBalanceEntity.initial().copyWith(
          openedBoxes: {0: 20, 1: 20, 2: 20},
        ),
      );

      final cubit = buildCubit();
      addTearDown(cubit.close);

      await cubit.openBox(5);

      verifyNever(() => updateCoinBalance(any()));
    });
  });
}
