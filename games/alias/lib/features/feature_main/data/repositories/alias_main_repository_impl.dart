import 'package:alias/features/feature_main/data/data_sources/alias_main_local_data_source.dart';
import 'package:alias/features/feature_main/data/data_sources/alias_main_remote_data_source.dart';
import 'package:alias/features/feature_main/domain/repositories/alias_main_repository.dart';
import 'package:alias/features/feature_main/domain/usecases/are_word_packs_cached_usecase.dart';
import 'package:alias/features/feature_main/domain/usecases/fetch_and_cache_word_packs_usecase.dart';
import 'package:alias/features/feature_main/domain/usecases/get_selected_word_pack_name_usecase.dart';

/// AliasMainRepositoryImpl is the implementation of the [AliasMainRepository]
class AliasMainRepositoryImpl implements AliasMainRepository {
  final AliasMainRemoteDataSource remoteDataSource;
  final AliasMainLocalDataSource localDataSource;

  const AliasMainRepositoryImpl({required this.remoteDataSource, required this.localDataSource});

  @override
  Future<bool> areWordPacksCached(AreWordPacksCachedParams params) {
    return localDataSource.arePacksPresentInHive(params);
  }

  @override
  Future<void> fetchAndCacheWordPacks(FetchAndCacheWordPacksParams params) async {
    final packs = await remoteDataSource.getWordPacks(params);
    await localDataSource.cacheWordPacks(params.localeCode, packs);
  }

  @override
  Future<String> getSelectedWordPackName(GetSelectedWordPackNameParams params) {
    return localDataSource.getSelectedWordPackName(params);
  }
}
