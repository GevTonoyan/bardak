import 'package:alias_pro/themes/data/data_sources/purchased_themes_local_data_source.dart';
import 'package:alias_pro/themes/data/repositories/purchased_themes_repository_impl.dart';
import 'package:alias_pro/themes/domain/repositories/purchased_themes_repository.dart';
import 'package:alias_pro/themes/domain/usecases/get_purchased_themes_usecase.dart';
import 'package:alias_pro/themes/domain/usecases/update_purchased_themes_usecase.dart';
import 'package:alias_pro/utils/dependency_injection/di.dart';

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
    ..registerLazySingleton<UpdatePurchasedThemesUseCase>(
      () => UpdatePurchasedThemesUseCase(sl()),
    );
}
