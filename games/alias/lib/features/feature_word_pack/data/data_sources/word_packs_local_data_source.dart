import 'package:alias/core/alias_constants.dart';
import 'package:alias/features/feature_word_pack/domain/entities/word_pack_info_entity.dart';
import 'package:alias/features/feature_word_pack/domain/usecases/get_word_packs_usecase.dart';
import 'package:alias/features/feature_word_pack/domain/usecases/set_selected_word_pack_usecase.dart';
import 'package:hive/hive.dart' show Hive;
import 'package:shared_preferences/shared_preferences.dart';

/// Local data source for accessing and storing word pack information.
abstract interface class WordPacksLocalDataSource {
  /// Returns cached word packs for the given locale.
  Future<AliasWordPackInfoResultEntity> getWordPacks(GetWordPacksParams params);

  /// Saves the selected word pack for the given locale.
  Future<void> setSelectedWordPack(SetSelectedWordPackParams params);
}

/// Implementation of the [WordPacksLocalDataSource] using Hive and SharedPreferences for local storage.
class WordPacksLocalDataSourceImpl implements WordPacksLocalDataSource {
  final SharedPreferences preferences;

  const WordPacksLocalDataSourceImpl(this.preferences);

  @override
  Future<AliasWordPackInfoResultEntity> getWordPacks(GetWordPacksParams params) async {
    final box = await Hive.openBox('${AliasConstants.aliasWordPack}_${params.localeCode}');
    final packsList = <AliasWordPackInfoEntity>[];

    for (final key in box.keys) {
      final data = box.get(key);
      if (data is Map) {
        final map = Map<String, dynamic>.from(data);
        final name = map[AliasConstants.aliasWordPackName] as String? ?? key;
        final emoji = map[AliasConstants.aliasWordPackEmoji] as String? ?? '';
        packsList.add(AliasWordPackInfoEntity(id: key, name: name, emoji: emoji));
      }
    }

    var selectedPackId = preferences.getString(
      '${AliasConstants.aliasSelectedWordPackKey}_${params.localeCode}',
    );

    selectedPackId ??= packsList.isNotEmpty ? packsList.first.id : 'all';

    return AliasWordPackInfoResultEntity(packs: packsList, selectedPackId: selectedPackId);
  }

  @override
  Future<void> setSelectedWordPack(SetSelectedWordPackParams params) async {
    await preferences.setString(
      '${AliasConstants.aliasSelectedWordPackKey}_${params.localeCode}',
      params.packId,
    );
  }
}
