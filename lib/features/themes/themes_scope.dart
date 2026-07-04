import 'package:bardak/core/di/di.dart';
import 'package:bardak/features/themes/data/data_sources/purchased_themes_local_data_source.dart';
import 'package:bardak/features/themes/data/repositories/purchased_themes_repository_impl.dart';
import 'package:bardak/features/themes/domain/repositories/purchased_themes_repository.dart';
import 'package:bardak/features/themes/domain/usecases/get_purchased_themes_usecase.dart';
import 'package:bardak/features/themes/domain/usecases/purchase_theme_usecase.dart';

void injectThemesScope() {
  if (sl.isRegistered<PurchasedThemesRepository>()) return;

  sl
    ..registerLazySingleton<PurchasedThemesLocalDataSource>(
      () => PurchasedThemesLocalDataSourceImpl(preferences: sl()),
    )
    ..registerLazySingleton<PurchasedThemesRepository>(
      () => PurchasedThemesRepositoryImpl(dataSource: sl()),
    )
    ..registerLazySingleton<GetPurchasedThemesUseCase>(
      () => GetPurchasedThemesUseCase(sl()),
    )
    ..registerLazySingleton<PurchaseThemeUseCase>(
      () => PurchaseThemeUseCase(sl(), sl()),
    );
}
