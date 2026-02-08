import 'package:boardify/rewards/domain/entities/coin_balance_entity.dart';
import 'package:boardify/rewards/domain/repositories/rewards_repository.dart';

/// Use case for getting the current coin balance state.
class GetCoinsStateUseCase {
  const GetCoinsStateUseCase(this.repository);

  final RewardsRepository repository;

  CoinBalanceEntity call() => repository.getCoinsState();
}
