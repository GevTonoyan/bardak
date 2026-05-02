import 'dart:async';

import 'package:bardak/utils/constants/constants.dart';
import 'package:bardak/word_pack/domain/entities/word_pack_info_entity.dart';
import 'package:bardak/word_pack/domain/usecases/are_packs_cached_usecase.dart';
import 'package:bardak/word_pack/domain/usecases/get_word_packs_usecase.dart';
import 'package:bardak/word_pack/domain/usecases/get_words_by_pack_usecase.dart';
import 'package:bardak/word_pack/domain/usecases/get_words_version_usecase.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Local data source for accessing and storing word pack information.
abstract interface class WordPacksLocalDataSource {
  /// Returns cached word packs for the given locale.
  Future<WordPackInfoResultEntity> getWordPacks(GetWordPacksParams params);

  /// Returns list of words for the given pack ID and locale.
  Future<List<String>> getWordsByPack(GetWordsByPackParams params);

  /// Saves all word packs for a given locale to Hive.
  Future<void> cacheWordPacks(String localeCode, List<WordPackEntity> packs);

  /// Checks if word packs are already cached in Hive for a given locale.
  Future<bool> arePacksPresentInHive(AreWordPacksCachedParams params);

  /// Returns the version of the words for a specific locale
  int getWordsVersion(GetWordsVersionParams params);
}

/// Implementation of the [WordPacksLocalDataSource] using Hive and SharedPreferences for local storage.
class WordPacksLocalDataSourceImpl implements WordPacksLocalDataSource {
  const WordPacksLocalDataSourceImpl(this.preferences);

  final SharedPreferences preferences;

  @override
  Future<WordPackInfoResultEntity> getWordPacks(
    GetWordPacksParams params,
  ) async {
    final box = await Hive.openBox(
      '${AppConstants.aliasWordPack}_${params.localeCode}',
    );
    final packsList = <WordPackEntity>[];

    for (final key in box.keys) {
      final data = box.get(key);
      if (data is Map) {
        final map = Map<String, dynamic>.from(data);

        final name = map[AppConstants.aliasWordPackName] as String;
        final words = map[AppConstants.aliasWordPackWords] as List<String>;
        final image = map[AppConstants.aliasWordPackImage] as String;
        final imageBlurHash =
            map[AppConstants.aliasWordPackImageBlurHash] as String;

        packsList.add(
          WordPackEntity(
            id: key,
            name: name,
            words: words,
            image: image,
            imageBlurHash: imageBlurHash,
          ),
        );
      }
    }

    return WordPackInfoResultEntity(packs: packsList);
  }

  @override
  Future<List<String>> getWordsByPack(GetWordsByPackParams params) async {
    final box = await Hive.openBox(
      '${AppConstants.aliasWordPack}_${params.localeCode}',
    );

    final selectedPackId = preferences.getString(
      '${AppConstants.aliasSelectedWordPackKey}_${params.localeCode}',
    );

    final pack = box.get(selectedPackId ?? 'all');
    if (pack is! Map) return [];

    final words = pack[AppConstants.aliasWordPackWords] as List<String>? ?? [];

    return words;
  }

  @override
  Future<bool> arePacksPresentInHive(AreWordPacksCachedParams params) async {
    final boxName = '${AppConstants.aliasWordPack}_${params.localeCode}';

    if (!Hive.isBoxOpen(boxName)) {
      final exists = await Hive.boxExists(boxName);
      if (!exists) return false;

      await Hive.openBox(boxName);
    }

    final box = Hive.box(boxName);
    return box.isNotEmpty;
  }

  @override
  Future<void> cacheWordPacks(
    String localeCode,
    List<WordPackEntity> packs,
  ) async {
    final box = await Hive.openBox(
      '${AppConstants.aliasWordPack}_$localeCode',
    );

    // We are keeping the locale code as the key for the box
    // and the word packs as the value.
    // e.g. en_movies: {name:Movies, words: [word1, word2]}
    for (final pack in packs) {
      final key = pack.id;
      await box.put(key, <String, dynamic>{
        AppConstants.aliasWordPackName: pack.name,
        AppConstants.aliasWordPackWords: pack.words,
        AppConstants.aliasWordPackImage: pack.image,
        AppConstants.aliasWordPackImageBlurHash: pack.imageBlurHash,
      });
    }
  }

  @override
  int getWordsVersion(GetWordsVersionParams params) =>
      preferences.getInt(
        '${AppConstants.wordsVersionKey}_${params.localeCode}',
      ) ??
      1;
}
