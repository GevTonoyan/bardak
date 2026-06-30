import 'package:bardak/core/app_ui/theme/colors/app_color_scheme.dart';
import 'package:bardak/features/rewards/domain/repositories/rewards_repository.dart';
import 'package:bardak/features/themes/domain/repositories/purchased_themes_repository.dart';
import 'package:bardak/features/themes/domain/theme_cost.dart';

/// Outcome of attempting to purchase a theme.
enum PurchaseThemeResult { success, insufficientFunds }

/// Buys a theme as a single transaction: charges [themeCost] coins and marks
/// the theme as owned. Owns the price rule and coordinates the rewards and
/// purchased-themes repositories.
class PurchaseThemeUseCase {
  const PurchaseThemeUseCase(
    this._purchasedThemesRepository,
    this._rewardsRepository,
  );

  final PurchasedThemesRepository _purchasedThemesRepository;
  final RewardsRepository _rewardsRepository;

  Future<PurchaseThemeResult> call(AppColorScheme theme) async {
    final balance = _rewardsRepository.getCoinsState();
    if (balance.coins < themeCost) {
      return .insufficientFunds;
    }

    await _rewardsRepository.updateCoins(
      balance.copyWith(coins: balance.coins - themeCost),
    );

    final owned = List<AppColorScheme>.of(
      _purchasedThemesRepository.getPurchasedThemes(),
    );
    if (!owned.contains(theme)) {
      owned.add(theme);
      await _purchasedThemesRepository.updatePurchasedThemes(owned);
    }

    return .success;
  }
}
