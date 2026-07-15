import 'package:bardak/core/app_ui/theme/colors/app_color_scheme.dart';
import 'package:bardak/core/di/di.dart';
import 'package:bardak/core/logging/app_logger.dart';
import 'package:bardak/core/logging/console_logger.dart';
import 'package:bardak/features/themes/domain/usecases/get_purchased_themes_usecase.dart';
import 'package:bardak/features/themes/domain/usecases/purchase_theme_usecase.dart';
import 'package:bardak/features/themes/presentation/bloc/themes_bloc.dart';
import 'package:bardak/features/themes/presentation/bloc/themes_event.dart';
import 'package:bardak/features/themes/presentation/bloc/themes_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockGetPurchasedThemes extends Mock
    implements GetPurchasedThemesUseCase {}

class _MockPurchaseTheme extends Mock implements PurchaseThemeUseCase {}

void main() {
  late _MockGetPurchasedThemes getPurchasedThemes;
  late _MockPurchaseTheme purchaseTheme;

  setUpAll(() {
    registerFallbackValue(AppColorScheme.main);
    if (!sl.isRegistered<AppLogger>()) {
      sl.registerLazySingleton<AppLogger>(ConsoleLogger.new);
    }
  });

  setUp(() {
    getPurchasedThemes = _MockGetPurchasedThemes();
    purchaseTheme = _MockPurchaseTheme();
    when(getPurchasedThemes.call).thenReturn([AppColorScheme.main]);
  });

  ThemesBloc buildBloc() => ThemesBloc(
    getPurchasedThemesUseCase: getPurchasedThemes,
    purchaseThemeUseCase: purchaseTheme,
  );

  test('starts with the owned themes', () {
    final bloc = buildBloc();
    addTearDown(bloc.close);

    expect(bloc.state.purchasedThemes, [AppColorScheme.main]);
    expect(bloc.state.status, ThemesStatus.idle);
  });

  test('a successful purchase adds the theme and reports success', () async {
    when(
      () => purchaseTheme(AppColorScheme.purple),
    ).thenAnswer((_) async => PurchaseThemeResult.success);

    final bloc = buildBloc();
    addTearDown(bloc.close);

    final statuses = <ThemesStatus>[];
    final subscription = bloc.stream.listen((s) => statuses.add(s.status));
    addTearDown(subscription.cancel);

    bloc.add(const PurchaseTheme(theme: AppColorScheme.purple));
    await pumpEventQueue();

    expect(statuses, [ThemesStatus.purchasing, ThemesStatus.purchaseSuccess]);
    expect(
      bloc.state.purchasedThemes,
      [AppColorScheme.main, AppColorScheme.purple],
    );
    expect(bloc.state.lastPurchased, AppColorScheme.purple);
  });

  test('insufficient funds keeps the theme locked', () async {
    when(
      () => purchaseTheme(AppColorScheme.purple),
    ).thenAnswer((_) async => PurchaseThemeResult.insufficientFunds);

    final bloc = buildBloc()
      ..add(const PurchaseTheme(theme: AppColorScheme.purple));
    addTearDown(bloc.close);
    await pumpEventQueue();

    expect(bloc.state.status, ThemesStatus.insufficientFunds);
    expect(bloc.state.purchasedThemes, [AppColorScheme.main]);
  });

  test('purchasing an owned theme is a no-op', () async {
    final bloc = buildBloc()
      ..add(const PurchaseTheme(theme: AppColorScheme.main));
    addTearDown(bloc.close);
    await pumpEventQueue();

    verifyNever(() => purchaseTheme(any()));
  });

  test('a failed purchase returns to idle', () async {
    when(
      () => purchaseTheme(AppColorScheme.purple),
    ).thenThrow(Exception('boom'));

    final bloc = buildBloc()
      ..add(const PurchaseTheme(theme: AppColorScheme.purple));
    addTearDown(bloc.close);
    await pumpEventQueue();

    expect(bloc.state.status, ThemesStatus.idle);
    expect(bloc.state.purchasedThemes, [AppColorScheme.main]);
  });
}
