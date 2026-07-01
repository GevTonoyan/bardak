import 'package:bardak/features/rewards/domain/entities/coin_balance_entity.dart';
import 'package:bardak/features/rewards/domain/repositories/rewards_repository.dart';

/// Reads the current coin balance.
class GetCoinBalanceUseCase {
  const GetCoinBalanceUseCase(this._rewardsRepository);

  final RewardsRepository _rewardsRepository;

  CoinBalanceEntity call() => _rewardsRepository.getCoinBalance();
}
