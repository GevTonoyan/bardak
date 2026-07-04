import 'package:bardak/features/rewards/domain/entities/coin_balance_entity.dart';
import 'package:equatable/equatable.dart';

/// State for the rewards cubit.
class RewardsState extends Equatable {
  const RewardsState({required this.coinBalance});

  final CoinBalanceEntity coinBalance;

  @override
  List<Object?> get props => [coinBalance];
}
