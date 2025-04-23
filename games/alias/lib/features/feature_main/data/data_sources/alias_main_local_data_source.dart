import 'package:alias/core/constants.dart';
import 'package:alias/features/feature_main/domain/entities/alias_word_pack_entity.dart';
import 'package:alias/features/feature_main/domain/usecases/are_word_packs_cached_usecase.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

/// Handles caching and reading data locally using Hive.
abstract interface class AliasMainLocalDataSource {
  /// Saves all word packs for a given locale to Hive.
  Future<void> cacheWordPacks(String localeCode, List<AliasWordPackEntity> packs);

  /// Checks if word packs are already cached in Hive for a given locale.
  Future<bool> arePacksPresentInHive(AreWordPacksCachedParams params);
}

/// Implementation of [AliasMainLocalDataSource] using Hive for local storage.
class AliasMainLocalDataSourceImpl implements AliasMainLocalDataSource {
  @override
  Future<bool> arePacksPresentInHive(AreWordPacksCachedParams params) async {
    const boxName = AliasConstants.aliasWordPack;

    if (!Hive.isBoxOpen(boxName)) {
      final exists = await Hive.boxExists(boxName);
      if (!exists) return false;

      await Hive.openBox(boxName);
    }

    final box = Hive.box(boxName);
    final data = box.get(params.localeCode);
    return data != null;
  }

  @override
  Future<void> cacheWordPacks(String localeCode, List<AliasWordPackEntity> packs) async {
    final box = await Hive.openBox('${AliasConstants.aliasWordPack}_$localeCode');

    // We are keeping the locale code as the key for the box
    // and the word packs as the value.
    // e.g. en_movies: {name:Movies, words: [word1, word2]}
    for (final pack in packs) {
      final key = pack.id;
      await box.put(key, <String, dynamic>{
        AliasConstants.aliasWordPackName: pack.name,
        AliasConstants.aliasWordPackEmoji: pack.emoji,
        AliasConstants.aliasWordPackWords: pack.words,
      });
    }
  }
}
