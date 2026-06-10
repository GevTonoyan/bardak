import 'package:bardak/app_review/data/data_sources/app_review_data_source.dart';
import 'package:bardak/app_review/data/data_sources/app_review_local_data_source.dart';
import 'package:bardak/app_review/data/repositories/app_review_repository_impl.dart';
import 'package:bardak/app_review/domain/repositories/app_review_repository.dart';
import 'package:bardak/app_review/domain/usecases/on_game_completed_usecase.dart';
import 'package:bardak/app_review/domain/usecases/open_store_listing_usecase.dart';
import 'package:bardak/app_review/domain/usecases/record_app_opened_usecase.dart';
import 'package:bardak/app_review/presentation/bloc/in_app_review_bloc.dart';
import 'package:bardak/utils/dependency_injection/di.dart';

void injectAppReviewScope() {
  if (sl.isRegistered<AppReviewRepository>()) {
    return;
  }

  sl
    ..registerFactory<InAppReviewBloc>(
      () => InAppReviewBloc(
        onGameCompletedUseCase: sl(),
      ),
    )
    ..registerLazySingleton<OnGameCompletedUseCase>(
      () => OnGameCompletedUseCase(sl()),
    )
    ..registerLazySingleton<RecordAppOpenedUseCase>(
      () => RecordAppOpenedUseCase(sl()),
    )
    ..registerLazySingleton<OpenStoreListingUseCase>(
      () => OpenStoreListingUseCase(sl()),
    )
    ..registerLazySingleton<AppReviewRepository>(
      () => AppReviewRepositoryImpl(
        dataSource: sl(),
        localDataSource: sl(),
      ),
    )
    ..registerLazySingleton<AppReviewLocalDataSource>(
      () => AppReviewLocalDataSourceImpl(preferences: sl()),
    )
    ..registerLazySingleton<AppReviewDataSource>(
      AppReviewDataSourceImpl.new,
    );
}
