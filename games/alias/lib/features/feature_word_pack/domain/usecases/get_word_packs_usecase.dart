import 'package:alias/features/feature_word_pack/domain/entities/word_pack_info_entity.dart';
import 'package:alias/features/feature_word_pack/domain/repositories/word_packs_repository.dart';

/// Gets all available word packs for the given locale from local cache.
class GetWordPacksUseCase {
  final WordPacksRepository repository;

  GetWordPacksUseCase(this.repository);

  Future<AliasWordPackInfoResultEntity> call(GetWordPacksParams params) {
    return repository.getWordPacks(params);
  }
}

/// Parameters required to fetch cached word packs.
class GetWordPacksParams {
  final String localeCode;

  const GetWordPacksParams({required this.localeCode});
}
