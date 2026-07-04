import 'package:bardak/features/games/spy/spy_packs/domain/repositories/spy_packs_repository.dart';

/// Checks whether spy packs for the locale are cached and not stale.
class AreSpyPacksCachedUseCase {
  const AreSpyPacksCachedUseCase(this._spyPacksRepository);

  final SpyPacksRepository _spyPacksRepository;

  Future<bool> call(String localeCode) =>
      _spyPacksRepository.areSpyPacksCached(localeCode);
}
