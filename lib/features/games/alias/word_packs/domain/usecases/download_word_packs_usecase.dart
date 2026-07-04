import 'package:bardak/features/games/alias/word_packs/domain/repositories/word_packs_repository.dart';

/// Downloads all word packs for the locale and caches them locally.
class DownloadWordPacksUseCase {
  const DownloadWordPacksUseCase(this._wordPacksRepository);

  final WordPacksRepository _wordPacksRepository;

  Future<void> call(String localeCode) =>
      _wordPacksRepository.downloadWordPacks(localeCode);
}
