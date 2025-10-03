import 'dart:async';

import 'package:boardify/features/word_pack/data/data_sources/word_packs_local_data_source.dart';
import 'package:boardify/features/word_pack/data/repositories/word_packs_repository_impl.dart';
import 'package:boardify/features/word_pack/domain/repositories/word_packs_repository.dart';
import 'package:boardify/features/word_pack/domain/usecases/get_word_packs_usecase.dart';
import 'package:boardify/features/word_pack/domain/usecases/get_words_by_pack_usecase.dart';
import 'package:boardify/features/word_pack/domain/usecases/set_selected_word_pack_usecase.dart';
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
    ..registerLazySingleton<SetSelectedWordPackUseCase>(
      () => SetSelectedWordPackUseCase(sl()),
    )
    ..registerLazySingleton<WordPacksRepository>(
      () => WordPacksRepositoryImpl(localDataSource: sl()),
    );

  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<WordPacksLocalDataSource>(
    () => WordPacksLocalDataSourceImpl(sharedPreferences),
  );
}
