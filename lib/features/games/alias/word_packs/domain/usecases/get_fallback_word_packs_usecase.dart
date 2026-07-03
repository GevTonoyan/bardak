import 'package:bardak/features/games/alias/word_packs/domain/entities/word_pack_entity.dart';
import 'package:bardak/features/games/alias/word_packs/domain/repositories/word_packs_repository.dart';

/// Gets the bundled fallback packs shown when nothing is cached yet.
class GetFallbackWordPacksUseCase {
  const GetFallbackWordPacksUseCase(this._wordPacksRepository);

  final WordPacksRepository _wordPacksRepository;

  List<WordPackEntity> call(String localeCode) {
    return _wordPacksRepository.getFallbackWordPacks(localeCode);
  }
}
