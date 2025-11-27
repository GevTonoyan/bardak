import 'dart:async';

import 'package:boardify/word_pack/domain/entities/word_pack_info_entity.dart';
import 'package:boardify/word_pack/domain/usecases/get_word_packs_usecase.dart';
import 'package:boardify/word_pack/domain/usecases/get_words_by_pack_usecase.dart';
import 'package:boardify/word_pack/domain/usecases/set_selected_word_pack_usecase.dart';

/// Abstract repository to handle word pack data operations.
abstract interface class WordPacksRepository {
  /// Gets cached word packs for the given locale.
  Future<AliasWordPackInfoResultEntity> getWordPacks(GetWordPacksParams params);

  /// Gets list of words for the given pack ID and locale.
  Future<List<String>> getWordsByPack(GetWordsByPackParams params);

  /// Persists the selected word pack for the given locale.
  Future<void> setSelectedWordPack(SetSelectedWordPackParams params);
}
