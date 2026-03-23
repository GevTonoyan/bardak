import 'dart:async';
import 'dart:math' as math;

import 'package:alias_pro/rewards/domain/entities/coin_balance_entity.dart';
import 'package:alias_pro/rewards/domain/usecases/get_coins_state_usecase.dart';
import 'package:alias_pro/rewards/domain/usecases/update_coins_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

const int maxOpensPerDay = 3;

class RewardsCubit extends Cubit<CoinBalanceEntity> {
  RewardsCubit({
    required GetCoinsStateUseCase getCoinsStateUseCase,
    required UpdateCoinsUseCase updateCoinsUseCase,
  }) : _updateCoinsUseCase = updateCoinsUseCase,
       _getCoinsStateUseCase = getCoinsStateUseCase,
       super(CoinBalanceEntity.initial());

  final GetCoinsStateUseCase _getCoinsStateUseCase;
  final UpdateCoinsUseCase _updateCoinsUseCase;

  void getCoinsState() {
    try {
      final coinsState = _getCoinsStateUseCase();
      emit(coinsState);
    } on Exception catch (_) {
      // TODO(Gevorg): log an error
    }
  }

  FutureOr<void> updateCoins(int index, int coins) async {
    if (state.openedCountToday > maxOpensPerDay) return;

    try {
      final updatedBoxes = Map<int, int>.from(state.openedBoxes)
        ..[index] = coins;

      final updatedBalance = state.copyWith(
        coins: state.coins + coins,
        openedBoxes: updatedBoxes,
        boxesDay: DateTime.now(),
      );

      final persisted = await _updateCoinsUseCase(updatedBalance);
      emit(persisted);
    } on Exception catch (_) {
      // On error, keep current state (don't emit)
    }
  }

  /// Deducts [amount] coins if the balance is sufficient.
  /// Returns `true` when the spend succeeded, `false` otherwise.
  Future<bool> spendCoins(int amount) async {
    if (state.coins < amount) return false;

    try {
      final updatedBalance = state.copyWith(coins: state.coins - amount);
      final persisted = await _updateCoinsUseCase(updatedBalance);
      emit(persisted);
      return true;
    } on Exception catch (_) {
      return false;
    }
  }
}
