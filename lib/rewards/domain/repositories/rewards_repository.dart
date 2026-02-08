import 'package:boardify/rewards/domain/entities/coin_balance_entity.dart';

/// Repository interface for managing coin balance and daily rewards.
abstract interface class RewardsRepository {
  /// Gets the current coin balance state.
  CoinBalanceEntity getCoinsState();

  /// Persists the given coin balance entity.
  Future<CoinBalanceEntity> updateCoins(CoinBalanceEntity coinBalance);
}
