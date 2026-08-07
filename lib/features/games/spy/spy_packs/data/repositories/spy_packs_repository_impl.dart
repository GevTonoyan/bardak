import 'dart:math';

import 'package:bardak/features/games/spy/spy_packs/data/data_sources/spy_packs_local_data_source.dart';
import 'package:bardak/features/games/spy/spy_packs/data/data_sources/spy_packs_remote_data_source.dart';
import 'package:bardak/features/games/spy/spy_packs/domain/entities/spy_pack_entity.dart';
import 'package:bardak/features/games/spy/spy_packs/domain/repositories/spy_packs_repository.dart';

/// Implementation of the [SpyPacksRepository] interface.
class SpyPacksRepositoryImpl implements SpyPacksRepository {
  const SpyPacksRepositoryImpl({
    required this._localDataSource,
    required this._remoteDataSource,
  });

  final SpyPacksLocalDataSource _localDataSource;
  final SpyPacksRemoteDataSource _remoteDataSource;

  @override
  Future<List<SpyPackEntity>> getSpyPacks(String localeCode) async {
    return _sortedByOrder(await _localDataSource.getSpyPacks(localeCode));
  }

  @override
  List<SpyPackEntity> getFallbackSpyPacks(String localeCode) {
    return _sortedByOrder(_localDataSource.getFallbackSpyPacks(localeCode));
  }

  /// Built-in packs are shown in their configured [SpyPackEntity.order].
  /// The sort tolerates duplicate orders — ties simply keep their incoming
  /// relative position — so a mistaken repeat never throws.
  List<SpyPackEntity> _sortedByOrder(List<SpyPackEntity> packs) {
    return [...packs]..sort((a, b) => a.order.compareTo(b.order));
  }

  @override
  Future<bool> areSpyPacksCached(String localeCode) async {
    final isCached = await _localDataSource.areSpyPacksCached(localeCode);
    return isCached && !_localDataSource.isSyncNeeded();
  }

  @override
  Future<void> downloadSpyPacks(String localeCode) async {
    final packs = await _remoteDataSource.getSpyPacks(localeCode);
    await _localDataSource.cacheSpyPacks(localeCode, packs);
    await _localDataSource.updateLastSyncTimestamp();
  }

  @override
  Future<String> drawSecret({
    required String localeCode,
    required SpyPackEntity pack,
  }) async {
    if (pack.words.isEmpty) {
      throw StateError('Spy pack "${pack.id}" has no words to draw from');
    }

    // Custom packs are shared across languages, so their no-repeat history
    // lives in one bucket rather than one per UI locale.
    final bucket = pack.isCustom ? 'custom' : localeCode;

    var used = _localDataSource.getUsedSecrets(bucket, pack.id);
    var unused = pack.words.where((word) => !used.contains(word)).toList();

    // Every word has been played: reshuffle, avoiding an immediate repeat
    // of the most recently played word.
    if (unused.isEmpty) {
      final lastPlayed = used.isNotEmpty ? used.last : null;
      used = const [];
      unused = pack.words.where((word) => word != lastPlayed).toList();
      if (unused.isEmpty) unused = [...pack.words];
    }

    final secret = unused[Random().nextInt(unused.length)];
    await _localDataSource.updateUsedSecrets(bucket, pack.id, [
      ...used,
      secret,
    ]);

    return secret;
  }

  @override
  Future<List<SpyPackEntity>> getCustomSpyPacks() {
    return _localDataSource.getCustomSpyPacks();
  }

  @override
  Future<void> saveCustomSpyPack(SpyPackEntity pack) {
    return _localDataSource.saveCustomSpyPack(pack);
  }

  @override
  Future<void> deleteCustomSpyPack(String id) {
    return _localDataSource.deleteCustomSpyPack(id);
  }
}
