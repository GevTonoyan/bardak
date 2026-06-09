import 'package:bardak/app_review/data/data_sources/app_review_data_source.dart';
import 'package:bardak/app_review/data/repositories/app_review_repository_impl.dart';
import 'package:bardak/app_review/domain/repositories/app_review_repository.dart';
import 'package:bardak/app_review/domain/usecases/open_store_listing_usecase.dart';
import 'package:bardak/utils/dependency_injection/di.dart';

void injectAppReviewScope() {
  if (sl.isRegistered<AppReviewRepository>()) {
    return;
  }

  sl
    ..registerLazySingleton<OpenStoreListingUseCase>(
      () => OpenStoreListingUseCase(sl()),
    )
    ..registerLazySingleton<AppReviewRepository>(
      () => AppReviewRepositoryImpl(dataSource: sl()),
    )
    ..registerLazySingleton<AppReviewDataSource>(
      AppReviewDataSourceImpl.new,
    );
}
