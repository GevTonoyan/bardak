import 'package:alias_pro/rewards/domain/entities/coin_balance_entity.dart';
import 'package:alias_pro/rewards/domain/repositories/rewards_repository.dart';

/// Use case for getting the current coin balance state.
class GetCoinsStateUseCase {
  const GetCoinsStateUseCase(this.repository);

  final RewardsRepository repository;

  CoinBalanceEntity call() => repository.getCoinsState();
}
