import 'package:alias_pro/rewards/domain/entities/coin_balance_entity.dart';
import 'package:equatable/equatable.dart';

/// State for the rewards bloc.
class RewardsState extends Equatable {
  const RewardsState({required this.coinBalance});

  /// Creates initial state with default values.
  factory RewardsState.initial() {
    return RewardsState(
      coinBalance: CoinBalanceEntity.initial(),
    );
  }

  final CoinBalanceEntity coinBalance;

  RewardsState copyWith({
    CoinBalanceEntity? coinBalance,
  }) {
    return RewardsState(
      coinBalance: coinBalance ?? this.coinBalance,
    );
  }

  @override
  List<Object?> get props => [coinBalance];
}
