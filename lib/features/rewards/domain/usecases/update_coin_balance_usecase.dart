import 'package:bardak/features/rewards/domain/entities/coin_balance_entity.dart';
import 'package:bardak/features/rewards/domain/repositories/rewards_repository.dart';

/// Persists an updated coin balance.
class UpdateCoinBalanceUseCase {
  const UpdateCoinBalanceUseCase(this._rewardsRepository);

  final RewardsRepository _rewardsRepository;

  Future<CoinBalanceEntity> call(CoinBalanceEntity coinBalance) =>
      _rewardsRepository.updateCoinBalance(coinBalance);
}
