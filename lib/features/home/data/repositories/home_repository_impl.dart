import 'package:boardify/features/home/data/data_sources/home_local_data_source.dart';
import 'package:boardify/features/home/data/data_sources/home_remote_data_source.dart';
import 'package:boardify/features/home/domain/repositories/home_repository.dart';
import 'package:boardify/features/home/domain/usecases/are_word_packs_cached_usecase.dart';
import 'package:boardify/features/home/domain/usecases/fetch_and_cache_word_packs_usecase.dart';
import 'package:boardify/features/home/domain/usecases/get_selected_word_pack_name_usecase.dart';

/// AliasMainRepositoryImpl is the implementation of the [HomeRepository]
class HomeRepositoryImpl implements HomeRepository {

  const HomeRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });
  final HomeRemoteDataSource remoteDataSource;
  final HomeLocalDataSource localDataSource;

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
  Future<String> getSelectedWordPackName(GetSelectedWordPackNameParams params) {
    return localDataSource.getSelectedWordPackName(params);
  }
}
