import 'package:boardify/alias_constants.dart';
import 'package:boardify/features/home/domain/entities/alias_word_pack_entity.dart';
import 'package:boardify/features/home/domain/usecases/are_word_packs_cached_usecase.dart';
import 'package:boardify/features/home/domain/usecases/get_selected_word_pack_name_usecase.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Handles caching and reading data locally using Hive.
abstract interface class HomeLocalDataSource {
  /// Saves all word packs for a given locale to Hive.
  Future<void> cacheWordPacks(String localeCode, List<WordPackEntity> packs);

  /// Checks if word packs are already cached in Hive for a given locale.
  Future<bool> arePacksPresentInHive(AreWordPacksCachedParams params);

  /// Returns the name of the currently selected word pack.
  Future<String> getSelectedWordPackName(GetSelectedWordPackNameParams params);
}

/// Implementation of [HomeLocalDataSource] using Hive for local storage.
class HomeLocalDataSourceImpl implements HomeLocalDataSource {
  const HomeLocalDataSourceImpl({required this.preferences});
  final SharedPreferences preferences;

  @override
  Future<bool> arePacksPresentInHive(AreWordPacksCachedParams params) async {
    final boxName = '${AliasConstants.aliasWordPack}_${params.localeCode}';

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
      '${AliasConstants.aliasWordPack}_$localeCode',
    );

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

  @override
  Future<String> getSelectedWordPackName(
    GetSelectedWordPackNameParams params,
  ) async {
    var selectedPackId = preferences.getString(
      '${AliasConstants.aliasSelectedWordPackKey}_${params.localeCode}',
    );

    selectedPackId ??= 'all';

    final boxName = '${AliasConstants.aliasWordPack}_${params.localeCode}';
    if (!Hive.isBoxOpen(boxName)) {
      await Hive.openBox(boxName);
    }
    final box = Hive.box(boxName);

    final packData = box.get(selectedPackId);

    if (packData is Map) {
      return packData[AliasConstants.aliasWordPackName] as String? ?? 'All';
    }

    return 'All';
  }
}
