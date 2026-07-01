import 'package:bardak/features/rewards/domain/entities/coin_balance_entity.dart';

/// Repository interface for managing the coin balance and daily rewards.
abstract interface class RewardsRepository {
  /// Returns the current coin balance.
  CoinBalanceEntity getCoinBalance();

  /// Persists the given coin balance.
  Future<CoinBalanceEntity> updateCoinBalance(CoinBalanceEntity coinBalance);

  /// Emits the coin balance whenever it changes.
  Stream<CoinBalanceEntity> watchCoinBalance();
}
