import 'package:bardak/features/app_review/data/data_sources/app_review_local_data_source.dart';
import 'package:bardak/features/app_review/data/data_sources/app_review_platform_data_source.dart';
import 'package:bardak/features/app_review/data/repositories/app_review_repository_impl.dart';
import 'package:bardak/features/app_review/domain/repositories/app_review_repository.dart';
import 'package:bardak/features/app_review/domain/usecases/open_store_listing_usecase.dart';
import 'package:bardak/features/app_review/domain/usecases/record_app_opened_usecase.dart';
import 'package:bardak/features/app_review/domain/usecases/request_review_if_eligible_usecase.dart';
import 'package:bardak/features/app_review/presentation/cubit/in_app_review_cubit.dart';
import 'package:bardak/core/di/di.dart';

void injectAppReviewScope() {
  if (sl.isRegistered<AppReviewRepository>()) {
    return;
  }

  sl
    ..registerFactory<InAppReviewCubit>(
      () => InAppReviewCubit(
        requestReviewIfEligibleUseCase: sl(),
      ),
    )
    ..registerLazySingleton<RequestReviewIfEligibleUseCase>(
      () => RequestReviewIfEligibleUseCase(sl()),
    )
    ..registerLazySingleton<RecordAppOpenedUseCase>(
      () => RecordAppOpenedUseCase(sl()),
    )
    ..registerLazySingleton<OpenStoreListingUseCase>(
      () => OpenStoreListingUseCase(sl()),
    )
    ..registerLazySingleton<AppReviewRepository>(
      () => AppReviewRepositoryImpl(
        platformDataSource: sl(),
        localDataSource: sl(),
      ),
    )
    ..registerLazySingleton<AppReviewLocalDataSource>(
      () => AppReviewLocalDataSourceImpl(preferences: sl()),
    )
    ..registerLazySingleton<AppReviewPlatformDataSource>(
      AppReviewPlatformDataSourceImpl.new,
    );
}
