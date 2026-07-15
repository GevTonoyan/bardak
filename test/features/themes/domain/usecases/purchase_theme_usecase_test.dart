import 'package:bardak/core/app_ui/theme/colors/app_color_scheme.dart';
import 'package:bardak/features/rewards/domain/entities/coin_balance_entity.dart';
import 'package:bardak/features/rewards/domain/repositories/rewards_repository.dart';
import 'package:bardak/features/themes/domain/repositories/purchased_themes_repository.dart';
import 'package:bardak/features/themes/domain/theme_cost.dart';
import 'package:bardak/features/themes/domain/usecases/get_purchased_themes_usecase.dart';
import 'package:bardak/features/themes/domain/usecases/purchase_theme_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockPurchasedThemesRepository extends Mock
    implements PurchasedThemesRepository {}

class _MockRewardsRepository extends Mock implements RewardsRepository {}

void main() {
  late _MockPurchasedThemesRepository themesRepository;
  late _MockRewardsRepository rewardsRepository;
  late PurchaseThemeUseCase purchaseTheme;

  setUpAll(() {
    registerFallbackValue(CoinBalanceEntity.initial());
  });

  setUp(() {
    themesRepository = _MockPurchasedThemesRepository();
    rewardsRepository = _MockRewardsRepository();
    purchaseTheme = PurchaseThemeUseCase(themesRepository, rewardsRepository);
  });

  CoinBalanceEntity balanceWith(int coins) =>
      CoinBalanceEntity.initial().copyWith(coins: coins);

  group('PurchaseThemeUseCase', () {
    test('refuses when the balance cannot cover the cost', () async {
      when(
        () => rewardsRepository.getCoinBalance(),
      ).thenReturn(balanceWith(themeCost - 1));

      final result = await purchaseTheme(AppColorScheme.purple);

      expect(result, PurchaseThemeResult.insufficientFunds);
      verifyNever(() => rewardsRepository.updateCoinBalance(any()));
      verifyNever(() => themesRepository.updatePurchasedThemes(any()));
    });

    test('charges the cost and adds the theme on success', () async {
      when(
        () => rewardsRepository.getCoinBalance(),
      ).thenReturn(balanceWith(themeCost + 100));
      when(() => rewardsRepository.updateCoinBalance(any())).thenAnswer(
        (invocation) async =>
            invocation.positionalArguments.first as CoinBalanceEntity,
      );
      when(
        () => themesRepository.getPurchasedThemes(),
      ).thenReturn([AppColorScheme.main]);
      when(
        () => themesRepository.updatePurchasedThemes(any()),
      ).thenAnswer((_) async => true);

      final result = await purchaseTheme(AppColorScheme.purple);

      expect(result, PurchaseThemeResult.success);

      final charged =
          verify(
                () => rewardsRepository.updateCoinBalance(captureAny()),
              ).captured.single
              as CoinBalanceEntity;
      expect(charged.coins, 100);

      final owned =
          verify(
                () => themesRepository.updatePurchasedThemes(captureAny()),
              ).captured.single
              as List<AppColorScheme>;
      expect(owned, [AppColorScheme.main, AppColorScheme.purple]);
    });

    test('does not add a theme that is already owned twice', () async {
      when(
        () => rewardsRepository.getCoinBalance(),
      ).thenReturn(balanceWith(themeCost));
      when(() => rewardsRepository.updateCoinBalance(any())).thenAnswer(
        (invocation) async =>
            invocation.positionalArguments.first as CoinBalanceEntity,
      );
      when(
        () => themesRepository.getPurchasedThemes(),
      ).thenReturn([AppColorScheme.main, AppColorScheme.purple]);

      final result = await purchaseTheme(AppColorScheme.purple);

      expect(result, PurchaseThemeResult.success);
      verifyNever(() => themesRepository.updatePurchasedThemes(any()));
    });

    test('a balance of exactly the cost is enough', () async {
      when(
        () => rewardsRepository.getCoinBalance(),
      ).thenReturn(balanceWith(themeCost));
      when(() => rewardsRepository.updateCoinBalance(any())).thenAnswer(
        (invocation) async =>
            invocation.positionalArguments.first as CoinBalanceEntity,
      );
      when(() => themesRepository.getPurchasedThemes()).thenReturn(const []);
      when(
        () => themesRepository.updatePurchasedThemes(any()),
      ).thenAnswer((_) async => true);

      final result = await purchaseTheme(AppColorScheme.blue);

      expect(result, PurchaseThemeResult.success);
      final charged =
          verify(
                () => rewardsRepository.updateCoinBalance(captureAny()),
              ).captured.single
              as CoinBalanceEntity;
      expect(charged.coins, 0);
    });
  });

  group('GetPurchasedThemesUseCase', () {
    test('returns the owned themes', () {
      when(
        () => themesRepository.getPurchasedThemes(),
      ).thenReturn([AppColorScheme.main]);

      expect(
        GetPurchasedThemesUseCase(themesRepository)(),
        [AppColorScheme.main],
      );
    });
  });
}
