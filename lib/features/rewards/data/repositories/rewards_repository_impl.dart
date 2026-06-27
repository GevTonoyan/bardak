import 'package:bardak/features/rewards/data/data_sources/rewards_local_data_source.dart';
import 'package:bardak/features/rewards/domain/entities/coin_balance_entity.dart';
import 'package:bardak/features/rewards/domain/repositories/rewards_repository.dart';

/// Implementation of [RewardsRepository].
class RewardsRepositoryImpl implements RewardsRepository {
  const RewardsRepositoryImpl({required this.dataSource});

  final RewardsLocalDataSource dataSource;

  @override
  CoinBalanceEntity getCoinsState() {
    return dataSource.getCoinBalance();
  }

  @override
  Future<CoinBalanceEntity> updateCoins(CoinBalanceEntity coinBalance) async {
    await dataSource.saveCoinBalance(coinBalance);
    return coinBalance;
  }
}
