import 'package:boardify/features/home/domain/usecases/are_word_packs_cached_usecase.dart';
import 'package:boardify/features/home/domain/usecases/fetch_and_cache_word_packs_usecase.dart';
import 'package:boardify/features/home/domain/usecases/get_selected_word_pack_name_usecase.dart';

/// AliasMainRepository is the contract for the repository that handles
/// the data operations for the Alias main screen.
abstract interface class HomeRepository {
  /// Checks if the word packs are cached locally in Hive.
  Future<bool> areWordPacksCached(AreWordPacksCachedParams params);

  /// Fetches all word packs from Firestore and caches them locally.
  Future<void> fetchAndCacheWordPacks(FetchAndCacheWordPacksParams params);

  /// Returns the name of the currently selected word pack for the given locale.
  Future<String> getSelectedWordPackName(GetSelectedWordPackNameParams params);
}
