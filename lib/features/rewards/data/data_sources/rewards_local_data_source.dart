import 'dart:async';
import 'dart:convert';

import 'package:bardak/features/rewards/domain/entities/coin_balance_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Local data source for accessing and storing the coin balance.
abstract interface class RewardsLocalDataSource {
  /// Returns the current coin balance.
  CoinBalanceEntity getCoinBalance();

  /// Persists the coin balance to local storage.
  Future<bool> updateCoinBalance(CoinBalanceEntity coinBalance);

  /// Emits the coin balance whenever it is persisted.
  Stream<CoinBalanceEntity> watchCoinBalance();
}

/// Implementation of [RewardsLocalDataSource] using SharedPreferences.
///
/// SharedPreferences has no native change feed, so writes are echoed through
/// a broadcast controller to keep listeners in sync.
class RewardsLocalDataSourceImpl implements RewardsLocalDataSource {
  RewardsLocalDataSourceImpl({required this._preferences});

  static const _coinBalanceKey = 'coin_balance';

  final SharedPreferences _preferences;

  final _coinBalanceController =
      StreamController<CoinBalanceEntity>.broadcast();

  @override
  CoinBalanceEntity getCoinBalance() {
    final jsonString = _preferences.getString(_coinBalanceKey);
    if (jsonString == null) return CoinBalanceEntity.initial();

    try {
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return CoinBalanceEntity.fromJson(json);
    } on Exception catch (_) {
      return CoinBalanceEntity.initial();
    }
  }

  @override
  Future<bool> updateCoinBalance(CoinBalanceEntity coinBalance) async {
    try {
      final jsonString = jsonEncode(coinBalance.toJson());
      final saved = await _preferences.setString(_coinBalanceKey, jsonString);
      if (saved) _coinBalanceController.add(coinBalance);
      return saved;
    } on Exception catch (_) {
      return false;
    }
  }

  @override
  Stream<CoinBalanceEntity> watchCoinBalance() => _coinBalanceController.stream;
}
