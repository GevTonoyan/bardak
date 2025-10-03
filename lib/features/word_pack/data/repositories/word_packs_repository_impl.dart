import 'dart:async';

import 'package:boardify/features/word_pack/data/data_sources/word_packs_local_data_source.dart';
import 'package:boardify/features/word_pack/domain/entities/word_pack_info_entity.dart';
import 'package:boardify/features/word_pack/domain/repositories/word_packs_repository.dart';
import 'package:boardify/features/word_pack/domain/usecases/get_word_packs_usecase.dart';
import 'package:boardify/features/word_pack/domain/usecases/get_words_by_pack_usecase.dart';
import 'package:boardify/features/word_pack/domain/usecases/set_selected_word_pack_usecase.dart';

/// Implementation of the [WordPacksRepository] interface.
class WordPacksRepositoryImpl implements WordPacksRepository {
  const WordPacksRepositoryImpl({required this.localDataSource});

  final WordPacksLocalDataSource localDataSource;

  @override
  Future<AliasWordPackInfoResultEntity> getWordPacks(
    GetWordPacksParams params,
  ) {
    return localDataSource.getWordPacks(params);
  }

  @override
  Future<List<String>> getWordsByPack(GetWordsByPackParams params) {
    return localDataSource.getWordsByPack(params);
  }

  @override
  Future<void> setSelectedWordPack(SetSelectedWordPackParams params) {
    return localDataSource.setSelectedWordPack(params);
  }
}
