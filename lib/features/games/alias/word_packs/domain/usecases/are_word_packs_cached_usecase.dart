import 'package:bardak/features/games/alias/word_packs/domain/repositories/word_packs_repository.dart';

/// Checks whether word packs for the locale are cached and not stale.
class AreWordPacksCachedUseCase {
  const AreWordPacksCachedUseCase(this._wordPacksRepository);

  final WordPacksRepository _wordPacksRepository;

  Future<bool> call(String localeCode) =>
      _wordPacksRepository.areWordPacksCached(localeCode);
}
