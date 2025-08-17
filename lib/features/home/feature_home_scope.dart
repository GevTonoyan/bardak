import 'package:boardify/features/home/data/data_sources/home_local_data_source.dart';
import 'package:boardify/features/home/data/data_sources/home_remote_data_source.dart';
import 'package:boardify/features/home/data/repositories/home_repository_impl.dart';
import 'package:boardify/features/home/domain/repositories/home_repository.dart';
import 'package:boardify/features/home/domain/usecases/are_word_packs_cached_usecase.dart';
import 'package:boardify/features/home/domain/usecases/fetch_and_cache_word_packs_usecase.dart';
import 'package:boardify/features/home/domain/usecases/get_selected_word_pack_name_usecase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../core/dependency_injection/di.dart';

void injectHomeScope() {
  // Register the use case
  sl
    ..registerLazySingleton<AreWordPacksCachedUseCase>(
      () => AreWordPacksCachedUseCase(sl()),
    )
    ..registerLazySingleton<FetchAndCacheWordPacksUseCase>(
      () => FetchAndCacheWordPacksUseCase(sl()),
    )
    ..registerLazySingleton<GetSelectedWordPackNameUseCase>(
      () => GetSelectedWordPackNameUseCase(sl()),
    );

  // Register the repository
  sl.registerLazySingleton<HomeRepository>(
    () =>
        HomeRepositoryImpl(remoteDataSource: sl(), localDataSource: sl()),
  );

  // Register the data sources
  sl
    ..registerLazySingleton<HomeRemoteDataSource>(
      () => HomeRemoteDataSourceImpl(firestore: sl()),
    )
    ..registerLazySingleton<HomeLocalDataSource>(
      () => HomeLocalDataSourceImpl(preferences: sl()),
    );

  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);
}
