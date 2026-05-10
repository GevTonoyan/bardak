import 'package:bardak/word_pack/data/data_sources/word_packs_local_data_source.dart';
import 'package:bardak/word_pack/data/data_sources/word_packs_remote_data_source.dart';
import 'package:bardak/word_pack/data/repositories/word_packs_repository_impl.dart';
import 'package:bardak/word_pack/domain/repositories/word_packs_repository.dart';
import 'package:bardak/word_pack/domain/usecases/are_packs_cached_usecase.dart';
import 'package:bardak/word_pack/domain/usecases/fetch_and_cache_word_packs_usecase.dart';
import 'package:bardak/word_pack/domain/usecases/get_word_packs_usecase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';

final GetIt sl = GetIt.instance;

void injectWordPacksScope() {
  if (sl.isRegistered<WordPacksRepository>()) {
    return;
  }

  sl
    ..registerLazySingleton<GetWordPacksUseCase>(
      () => GetWordPacksUseCase(sl()),
    )
    ..registerLazySingleton<ArePacksCachedUseCase>(
      () => ArePacksCachedUseCase(sl()),
    )
    ..registerLazySingleton<FetchAndCacheWordPacksUseCase>(
      () => FetchAndCacheWordPacksUseCase(sl()),
    )
    ..registerLazySingleton<WordPacksRepository>(
      () => WordPacksRepositoryImpl(
        localDataSource: sl(),
        remoteDataSource: sl(),
      ),
    )
    ..registerLazySingleton<WordPacksLocalDataSource>(
      () => WordPacksLocalDataSourceImpl(sl()),
    )
    ..registerLazySingleton<WordPacksRemoteDataSource>(
      () =>
          WordPacksRemoteDataSourceImpl(firestore: FirebaseFirestore.instance),
    );
}
