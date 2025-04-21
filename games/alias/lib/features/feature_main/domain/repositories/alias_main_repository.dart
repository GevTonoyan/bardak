import 'package:alias/features/feature_main/domain/entities/alias_word_pack_entity.dart';
import 'package:alias/features/feature_main/domain/usecases/are_word_packs_cached_usecase.dart';
import 'package:alias/features/feature_main/domain/usecases/fetch_and_cache_word_packs_usecase.dart';

/// AliasMainRepository is the contract for the repository that handles
/// the data operations for the Alias main screen.
abstract interface class AliasMainRepository {
  /// Checks if the word packs are cached locally in Hive.
  Future<bool> areWordPacksCached(AreWordPacksCachedParams params);

  /// Fetches all word packs from Firestore and caches them locally.
  Future<void> fetchAndCacheWordPacks(FetchAndCacheWordPacksParams params);
}
