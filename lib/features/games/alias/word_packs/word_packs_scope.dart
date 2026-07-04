import 'package:bardak/core/di/di.dart';
import 'package:bardak/features/games/alias/word_packs/data/data_sources/word_packs_local_data_source.dart';
import 'package:bardak/features/games/alias/word_packs/data/data_sources/word_packs_remote_data_source.dart';
import 'package:bardak/features/games/alias/word_packs/data/repositories/word_packs_repository_impl.dart';
import 'package:bardak/features/games/alias/word_packs/domain/repositories/word_packs_repository.dart';
import 'package:bardak/features/games/alias/word_packs/domain/usecases/are_word_packs_cached_usecase.dart';
import 'package:bardak/features/games/alias/word_packs/domain/usecases/download_word_packs_usecase.dart';
import 'package:bardak/features/games/alias/word_packs/domain/usecases/get_fallback_word_packs_usecase.dart';
import 'package:bardak/features/games/alias/word_packs/domain/usecases/get_word_packs_usecase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void injectWordPacksScope() {
  if (sl.isRegistered<WordPacksRepository>()) return;

  sl
    ..registerLazySingleton<GetWordPacksUseCase>(
      () => GetWordPacksUseCase(sl()),
    )
    ..registerLazySingleton<GetFallbackWordPacksUseCase>(
      () => GetFallbackWordPacksUseCase(sl()),
    )
    ..registerLazySingleton<AreWordPacksCachedUseCase>(
      () => AreWordPacksCachedUseCase(sl()),
    )
    ..registerLazySingleton<DownloadWordPacksUseCase>(
      () => DownloadWordPacksUseCase(sl()),
    )
    ..registerLazySingleton<WordPacksRepository>(
      () => WordPacksRepositoryImpl(
        localDataSource: sl(),
        remoteDataSource: sl(),
      ),
    )
    ..registerLazySingleton<WordPacksLocalDataSource>(
      () => WordPacksLocalDataSourceImpl(preferences: sl()),
    )
    ..registerLazySingleton<WordPacksRemoteDataSource>(
      () => WordPacksRemoteDataSourceImpl(
        firestore: FirebaseFirestore.instance,
      ),
    );
}
