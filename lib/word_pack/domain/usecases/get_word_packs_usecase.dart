import 'dart:async';

import 'package:boardify/word_pack/domain/entities/word_pack_info_entity.dart';
import 'package:boardify/word_pack/domain/repositories/word_packs_repository.dart';

/// Gets all available word packs for the given locale from local cache.
class GetWordPacksUseCase {
  GetWordPacksUseCase(this.repository);

  final WordPacksRepository repository;

  Future<AliasWordPackInfoResultEntity> call(GetWordPacksParams params) {
    return repository.getWordPacks(params);
  }
}

/// Parameters required to fetch cached word packs.
class GetWordPacksParams {
  const GetWordPacksParams({required this.localeCode});

  final String localeCode;
}
