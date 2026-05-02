import 'package:bardak/themes/data/data_sources/purchased_themes_local_data_source.dart';
import 'package:bardak/themes/data/repositories/purchased_themes_repository_impl.dart';
import 'package:bardak/themes/domain/repositories/purchased_themes_repository.dart';
import 'package:bardak/themes/domain/usecases/get_purchased_themes_usecase.dart';
import 'package:bardak/themes/domain/usecases/update_purchased_themes_usecase.dart';
import 'package:bardak/utils/dependency_injection/di.dart';

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
