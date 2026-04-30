import 'dart:async';

import 'package:alias_pro/word_pack/data/data_sources/word_packs_local_data_source.dart';
import 'package:alias_pro/word_pack/data/data_sources/word_packs_remote_data_source.dart';
import 'package:alias_pro/word_pack/domain/entities/word_pack_info_entity.dart';
import 'package:alias_pro/word_pack/domain/repositories/word_packs_repository.dart';
import 'package:alias_pro/word_pack/domain/usecases/are_packs_cached_usecase.dart';
import 'package:alias_pro/word_pack/domain/usecases/fetch_and_cache_word_packs_usecase.dart';
import 'package:alias_pro/word_pack/domain/usecases/get_word_packs_usecase.dart';
import 'package:alias_pro/word_pack/domain/usecases/get_words_by_pack_usecase.dart';
import 'package:alias_pro/word_pack/domain/usecases/get_words_version_usecase.dart';

/// Implementation of the [WordPacksRepository] interface.
class WordPacksRepositoryImpl implements WordPacksRepository {
  const WordPacksRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
  });

  final WordPacksLocalDataSource localDataSource;
  final WordPacksRemoteDataSource remoteDataSource;

  @override
  Future<WordPackInfoResultEntity> getWordPacks(
    GetWordPacksParams params,
  ) {
    return localDataSource.getWordPacks(params);
  }

  @override
  Future<List<String>> getWordsByPack(GetWordsByPackParams params) {
    return localDataSource.getWordsByPack(params);
  }

  @override
  Future<bool> areWordPacksCached(AreWordPacksCachedParams params) {
    return localDataSource.arePacksPresentInHive(params);
  }

  @override
  Future<void> fetchAndCacheWordPacks(
    FetchAndCacheWordPacksParams params,
  ) async {
    final packs = await remoteDataSource.getWordPacks(params);
    await localDataSource.cacheWordPacks(params.localeCode, packs);
  }

  @override
  int getWordsVersion(GetWordsVersionParams params) =>
      localDataSource.getWordsVersion(params);
}
