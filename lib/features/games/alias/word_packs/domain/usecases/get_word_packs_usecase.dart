import 'package:bardak/features/games/alias/word_packs/domain/entities/word_pack_entity.dart';
import 'package:bardak/features/games/alias/word_packs/domain/repositories/word_packs_repository.dart';

/// Gets all cached word packs for the given locale.
class GetWordPacksUseCase {
  const GetWordPacksUseCase(this._wordPacksRepository);

  final WordPacksRepository _wordPacksRepository;

  Future<List<WordPackEntity>> call(String localeCode) {
    return _wordPacksRepository.getWordPacks(localeCode);
  }
}
