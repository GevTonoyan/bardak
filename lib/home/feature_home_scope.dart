import 'package:boardify/home/data/data_sources/home_local_data_source.dart';
import 'package:boardify/home/data/data_sources/home_remote_data_source.dart';
import 'package:boardify/home/data/repositories/home_repository_impl.dart';
import 'package:boardify/home/domain/repositories/home_repository.dart';
import 'package:boardify/home/domain/usecases/are_word_packs_cached_usecase.dart';
import 'package:boardify/home/domain/usecases/fetch_and_cache_word_packs_usecase.dart';
import 'package:boardify/home/domain/usecases/get_selected_word_pack_name_usecase.dart';
import 'package:boardify/home/domain/usecases/get_words_version_usecase.dart';
import 'package:boardify/utils/dependency_injection/di.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
    )
    ..registerLazySingleton<GetWordsVersionUseCase>(
      () => GetWordsVersionUseCase(sl()),
    )
    ..registerLazySingleton<HomeRepository>(
      () => HomeRepositoryImpl(remoteDataSource: sl(), localDataSource: sl()),
    )
    ..registerLazySingleton<HomeRemoteDataSource>(
      () => HomeRemoteDataSourceImpl(firestore: sl()),
    )
    ..registerLazySingleton<HomeLocalDataSource>(
      () => HomeLocalDataSourceImpl(preferences: sl()),
    )
    ..registerLazySingleton<FirebaseFirestore>(
      () => FirebaseFirestore.instance,
    );
}
