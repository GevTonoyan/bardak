import 'dart:async';
import 'dart:math' as math;

import 'package:bardak/core/di/di.dart';
import 'package:bardak/features/rewards/domain/entities/coin_balance_entity.dart';
import 'package:bardak/features/rewards/domain/usecases/get_coin_balance_usecase.dart';
import 'package:bardak/features/rewards/domain/usecases/update_coin_balance_usecase.dart';
import 'package:bardak/features/rewards/domain/usecases/watch_coin_balance_usecase.dart';
import 'package:bardak/features/rewards/presentation/bloc/rewards_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RewardsCubit extends Cubit<RewardsState> {
  RewardsCubit({
    required GetCoinBalanceUseCase getCoinBalanceUseCase,
    required this._updateCoinBalanceUseCase,
    required WatchCoinBalanceUseCase watchCoinBalanceUseCase,
  }) : super(RewardsState(coinBalance: getCoinBalanceUseCase())) {
    _subscription = watchCoinBalanceUseCase().listen(
      (balance) => emit(RewardsState(coinBalance: balance)),
    );
  }

  final UpdateCoinBalanceUseCase _updateCoinBalanceUseCase;

  late final StreamSubscription<CoinBalanceEntity> _subscription;

  /// Opens the reward box at [index], granting a random reward.
  Future<void> openBox(int index) async {
    final balance = state.coinBalance;
    if (balance.hasReachedDailyLimit || balance.isBoxOpened(index)) return;

    // Random reward from 20 to 200.
    final reward = (math.Random().nextInt(10) + 1) * 20;

    final updated = balance.copyWith(
      coins: balance.coins + reward,
      openedBoxes: {...balance.openedBoxes, index: reward},
      boxesDay: DateTime.now(),
    );

    try {
      // The stream drives the state emission.
      await _updateCoinBalanceUseCase(updated);
    } on Exception catch (error, stackTrace) {
      logger.error(
        'Failed to open reward box',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  @override
  Future<void> close() async {
    await _subscription.cancel();
    return super.close();
  }
}
