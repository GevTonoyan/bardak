import 'dart:async';

import 'package:boardify/utils/constants/constants.dart';
import 'package:boardify/word_pack/domain/entities/word_pack_info_entity.dart';
import 'package:boardify/word_pack/domain/usecases/get_word_packs_usecase.dart';
import 'package:boardify/word_pack/domain/usecases/get_words_by_pack_usecase.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Local data source for accessing and storing word pack information.
abstract interface class WordPacksLocalDataSource {
  /// Returns cached word packs for the given locale.
  Future<AliasWordPackInfoResultEntity> getWordPacks(GetWordPacksParams params);

  /// Returns list of words for the given pack ID and locale.
  Future<List<String>> getWordsByPack(GetWordsByPackParams params);
}

/// Implementation of the [WordPacksLocalDataSource] using Hive and SharedPreferences for local storage.
class WordPacksLocalDataSourceImpl implements WordPacksLocalDataSource {
  const WordPacksLocalDataSourceImpl(this.preferences);

  final SharedPreferences preferences;

  @override
  Future<AliasWordPackInfoResultEntity> getWordPacks(
    GetWordPacksParams params,
  ) async {
    final box = await Hive.openBox(
      '${AppConstants.aliasWordPack}_${params.localeCode}',
    );
    final packsList = <AliasWordPackInfoEntity>[];

    for (final key in box.keys) {
      final data = box.get(key);
      if (data is Map) {
        final map = Map<String, dynamic>.from(data);

        final name = map[AppConstants.aliasWordPackName] as String? ?? key;
        final emoji = map[AppConstants.aliasWordPackEmoji] as String? ?? '';
        final words =
            map[AppConstants.aliasWordPackWords] as List<String>? ?? [];

        packsList.add(
          AliasWordPackInfoEntity(
            id: key,
            name: name,
            emoji: emoji,
            words: words,
          ),
        );
      }
    }

    var selectedPackId = preferences.getString(
      '${AppConstants.aliasSelectedWordPackKey}_${params.localeCode}',
    );

    selectedPackId ??= packsList.isNotEmpty ? packsList.first.id : 'all';

    return AliasWordPackInfoResultEntity(packs: packsList);
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
}
