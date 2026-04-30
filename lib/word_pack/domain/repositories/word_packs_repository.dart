import 'dart:async';

import 'package:alias_pro/word_pack/domain/entities/word_pack_info_entity.dart';
import 'package:alias_pro/word_pack/domain/usecases/are_packs_cached_usecase.dart';
import 'package:alias_pro/word_pack/domain/usecases/fetch_and_cache_word_packs_usecase.dart';
import 'package:alias_pro/word_pack/domain/usecases/get_word_packs_usecase.dart';
import 'package:alias_pro/word_pack/domain/usecases/get_words_by_pack_usecase.dart';
import 'package:alias_pro/word_pack/domain/usecases/get_words_version_usecase.dart';

/// Abstract repository to handle word pack data operations.
abstract interface class WordPacksRepository {
  /// Gets cached word packs for the given locale.
  Future<WordPackInfoResultEntity> getWordPacks(GetWordPacksParams params);

  /// Gets list of words for the given pack ID and locale.
  Future<List<String>> getWordsByPack(GetWordsByPackParams params);

  /// Checks if the word packs are cached locally in Hive.
  Future<bool> areWordPacksCached(AreWordPacksCachedParams params);

  /// Fetches all word packs from Firestore and caches them locally.
  Future<void> fetchAndCacheWordPacks(FetchAndCacheWordPacksParams params);

  /// Returns the version of the words for a specific locale
  int getWordsVersion(GetWordsVersionParams params);
}
