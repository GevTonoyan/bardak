import 'package:alias/features/feature_main/data/data_sources/alias_main_local_data_source.dart';
import 'package:alias/features/feature_main/data/data_sources/alias_main_remote_data_source.dart';
import 'package:alias/features/feature_main/data/repositories/alias_main_repository_impl.dart';
import 'package:alias/features/feature_main/domain/repositories/alias_main_repository.dart';
import 'package:alias/features/feature_main/domain/usecases/are_word_packs_cached_usecase.dart';
import 'package:alias/features/feature_main/domain/usecases/fetch_and_cache_word_packs_usecase.dart';
import 'package:alias/features/feature_settings/alias_settings_scope.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void injectAliasMainScope() {
  if (sl.isRegistered<AliasMainRepository>()) {
    return;
  }

  // Register the use case
  sl
    ..registerLazySingleton<AreWordPacksCachedUseCase>(() => AreWordPacksCachedUseCase(sl()))
    ..registerLazySingleton<FetchAndCacheWordPacksUseCase>(
      () => FetchAndCacheWordPacksUseCase(sl()),
    );

  // Register the repository
  sl.registerLazySingleton<AliasMainRepository>(
    () => AliasMainRepositoryImpl(remoteDataSource: sl(), localDataSource: sl()),
  );

  // Register the data sources
  sl
    ..registerLazySingleton<AliasMainRemoteDataSource>(
      () => AliasMainRemoteDataSourceImpl(firestore: sl()),
    )
    ..registerLazySingleton<AliasMainLocalDataSource>(() => AliasMainLocalDataSourceImpl());

  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);
}
