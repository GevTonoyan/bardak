import 'package:boardify/rewards/domain/entities/coin_balance_entity.dart';
import 'package:boardify/rewards/domain/repositories/rewards_repository.dart';

/// Use case for persisting an updated coin balance entity.
class UpdateCoinsUseCase {
  const UpdateCoinsUseCase(this.repository);

  final RewardsRepository repository;

  Future<CoinBalanceEntity> call(CoinBalanceEntity coinBalance) =>
      repository.updateCoins(coinBalance);
}
