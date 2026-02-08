import 'dart:convert';

import 'package:boardify/rewards/domain/entities/coin_balance_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Local data source for accessing and storing coin balance information.
abstract interface class RewardsLocalDataSource {
  /// Gets the current coin balance entity.
  CoinBalanceEntity getCoinBalance();

  /// Saves the coin balance entity to local storage.
  Future<bool> saveCoinBalance(CoinBalanceEntity coinBalance);

  Future<void> resetCoins();
}

/// Implementation of [RewardsLocalDataSource] using SharedPreferences.
class RewardsLocalDataSourceImpl implements RewardsLocalDataSource {
  const RewardsLocalDataSourceImpl({required this.preferences});

  final SharedPreferences preferences;

  static const _coinBalanceKey = 'coin_balance';

  @override
  CoinBalanceEntity getCoinBalance() {
    final jsonString = preferences.getString(_coinBalanceKey);
    if (jsonString != null) {
      try {
        final json = jsonDecode(jsonString) as Map<String, dynamic>;
        return CoinBalanceEntity.fromJson(json);
      } on Exception catch (_) {
        return CoinBalanceEntity.initial();
      }
    } else {
      return CoinBalanceEntity.initial();
    }
  }

  @override
  Future<bool> saveCoinBalance(CoinBalanceEntity coinBalance) async {
    try {
      final jsonString = jsonEncode(coinBalance.toJson());
      return await preferences.setString(_coinBalanceKey, jsonString);
    } on Exception catch (_) {
      return false;
    }
  }

  // debug only function, that resets todays coins
  Future<void> resetCoins() async {
    await preferences.remove(_coinBalanceKey);
  }
}
