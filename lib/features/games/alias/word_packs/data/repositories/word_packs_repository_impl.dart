import 'package:bardak/features/games/alias/word_packs/data/data_sources/word_packs_local_data_source.dart';
import 'package:bardak/features/games/alias/word_packs/data/data_sources/word_packs_remote_data_source.dart';
import 'package:bardak/features/games/alias/word_packs/domain/entities/word_pack_entity.dart';
import 'package:bardak/features/games/alias/word_packs/domain/repositories/word_packs_repository.dart';

/// Implementation of the [WordPacksRepository] interface.
class WordPacksRepositoryImpl implements WordPacksRepository {
  const WordPacksRepositoryImpl({
    required this._localDataSource,
    required this._remoteDataSource,
  });

  final WordPacksLocalDataSource _localDataSource;
  final WordPacksRemoteDataSource _remoteDataSource;

  @override
  Future<List<WordPackEntity>> getWordPacks(String localeCode) {
    return _localDataSource.getWordPacks(localeCode);
  }

  @override
  List<WordPackEntity> getFallbackWordPacks(String localeCode) {
    return _localDataSource.getFallbackWordPacks(localeCode);
  }

  @override
  Future<bool> areWordPacksCached(String localeCode) async {
    final isCached = await _localDataSource.areWordPacksCached(localeCode);
    return isCached && !_localDataSource.isSyncNeeded();
  }

  @override
  Future<void> downloadWordPacks(String localeCode) async {
    final packs = await _remoteDataSource.getWordPacks(localeCode);
    await _localDataSource.cacheWordPacks(localeCode, packs);
    await _localDataSource.updateLastSyncTimestamp();
  }
}
