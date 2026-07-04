import 'package:bardak/core/di/di.dart';
import 'package:bardak/features/games/spy/spy_packs/data/data_sources/spy_packs_local_data_source.dart';
import 'package:bardak/features/games/spy/spy_packs/data/data_sources/spy_packs_remote_data_source.dart';
import 'package:bardak/features/games/spy/spy_packs/data/repositories/spy_packs_repository_impl.dart';
import 'package:bardak/features/games/spy/spy_packs/domain/repositories/spy_packs_repository.dart';
import 'package:bardak/features/games/spy/spy_packs/domain/usecases/are_spy_packs_cached_usecase.dart';
import 'package:bardak/features/games/spy/spy_packs/domain/usecases/download_spy_packs_usecase.dart';
import 'package:bardak/features/games/spy/spy_packs/domain/usecases/draw_spy_secret_usecase.dart';
import 'package:bardak/features/games/spy/spy_packs/domain/usecases/get_spy_packs_usecase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void injectSpyPacksScope() {
  if (sl.isRegistered<SpyPacksRepository>()) return;

  sl
    ..registerLazySingleton<GetSpyPacksUseCase>(
      () => GetSpyPacksUseCase(sl()),
    )
    ..registerLazySingleton<AreSpyPacksCachedUseCase>(
      () => AreSpyPacksCachedUseCase(sl()),
    )
    ..registerLazySingleton<DownloadSpyPacksUseCase>(
      () => DownloadSpyPacksUseCase(sl()),
    )
    ..registerLazySingleton<DrawSpySecretUseCase>(
      () => DrawSpySecretUseCase(sl()),
    )
    ..registerLazySingleton<SpyPacksRepository>(
      () => SpyPacksRepositoryImpl(
        localDataSource: sl(),
        remoteDataSource: sl(),
      ),
    )
    ..registerLazySingleton<SpyPacksLocalDataSource>(
      () => SpyPacksLocalDataSourceImpl(preferences: sl()),
    )
    ..registerLazySingleton<SpyPacksRemoteDataSource>(
      () => SpyPacksRemoteDataSourceImpl(
        firestore: FirebaseFirestore.instance,
      ),
    );
}
