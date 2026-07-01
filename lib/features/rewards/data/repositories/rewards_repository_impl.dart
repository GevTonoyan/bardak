import 'package:bardak/features/rewards/data/data_sources/rewards_local_data_source.dart';
import 'package:bardak/features/rewards/domain/entities/coin_balance_entity.dart';
import 'package:bardak/features/rewards/domain/repositories/rewards_repository.dart';

/// Implementation of [RewardsRepository].
class RewardsRepositoryImpl implements RewardsRepository {
  const RewardsRepositoryImpl({required this._dataSource});

  final RewardsLocalDataSource _dataSource;

  @override
  CoinBalanceEntity getCoinBalance() => _dataSource.getCoinBalance();

  @override
  Future<CoinBalanceEntity> updateCoinBalance(
    CoinBalanceEntity coinBalance,
  ) async {
    await _dataSource.updateCoinBalance(coinBalance);
    return coinBalance;
  }

  @override
  Stream<CoinBalanceEntity> watchCoinBalance() =>
      _dataSource.watchCoinBalance();
}
