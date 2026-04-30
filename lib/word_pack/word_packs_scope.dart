import 'dart:async';

import 'package:alias_pro/word_pack/data/data_sources/word_packs_local_data_source.dart';
import 'package:alias_pro/word_pack/data/data_sources/word_packs_remote_data_source.dart';
import 'package:alias_pro/word_pack/data/repositories/word_packs_repository_impl.dart';
import 'package:alias_pro/word_pack/domain/repositories/word_packs_repository.dart';
import 'package:alias_pro/word_pack/domain/usecases/are_packs_cached_usecase.dart';
import 'package:alias_pro/word_pack/domain/usecases/fetch_and_cache_word_packs_usecase.dart';
import 'package:alias_pro/word_pack/domain/usecases/get_word_packs_usecase.dart';
import 'package:alias_pro/word_pack/domain/usecases/get_words_by_pack_usecase.dart';
import 'package:alias_pro/word_pack/domain/usecases/get_words_version_usecase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GetIt sl = GetIt.instance;

Future<void> injectWordPacksScope() async {
  if (sl.isRegistered<WordPacksRepository>()) {
    return;
  }

  sl
    ..registerLazySingleton<GetWordPacksUseCase>(
      () => GetWordPacksUseCase(sl()),
    )
    ..registerLazySingleton<GetWordsByPackUseCase>(
      () => GetWordsByPackUseCase(sl()),
    )
    ..registerLazySingleton<ArePacksCachedUseCase>(
      () => ArePacksCachedUseCase(sl()),
    )
    ..registerLazySingleton<FetchAndCacheWordPacksUseCase>(
      () => FetchAndCacheWordPacksUseCase(sl()),
    )
    ..registerLazySingleton<GetWordsVersionUseCase>(
      () => GetWordsVersionUseCase(sl()),
    )
    ..registerLazySingleton<WordPacksRepository>(
      () => WordPacksRepositoryImpl(
        localDataSource: sl(),
        remoteDataSource: sl(),
      ),
    );

  final sharedPreferences = await SharedPreferences.getInstance();
  sl
    ..registerLazySingleton<WordPacksLocalDataSource>(
      () => WordPacksLocalDataSourceImpl(sharedPreferences),
    )
    ..registerLazySingleton<WordPacksRemoteDataSource>(
      () =>
          WordPacksRemoteDataSourceImpl(firestore: FirebaseFirestore.instance),
    );
}
