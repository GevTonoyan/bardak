import 'package:bardak/features/games/spy/spy_packs/domain/repositories/spy_packs_repository.dart';

/// Downloads all spy packs for the locale and caches them locally.
class DownloadSpyPacksUseCase {
  const DownloadSpyPacksUseCase(this._spyPacksRepository);

  final SpyPacksRepository _spyPacksRepository;

  Future<void> call(String localeCode) =>
      _spyPacksRepository.downloadSpyPacks(localeCode);
}
