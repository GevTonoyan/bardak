import 'package:bardak/features/rewards/domain/entities/coin_balance_entity.dart';
import 'package:bardak/features/rewards/domain/repositories/rewards_repository.dart';

/// Streams the coin balance, emitting whenever it changes.
class WatchCoinBalanceUseCase {
  const WatchCoinBalanceUseCase(this._rewardsRepository);

  final RewardsRepository _rewardsRepository;

  Stream<CoinBalanceEntity> call() => _rewardsRepository.watchCoinBalance();
}
