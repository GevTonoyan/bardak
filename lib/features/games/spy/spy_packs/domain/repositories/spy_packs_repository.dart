import 'package:bardak/features/games/spy/spy_packs/domain/entities/spy_pack_entity.dart';

/// Abstract repository to handle spy pack data operations.
abstract interface class SpyPacksRepository {
  /// Returns cached spy packs for the given locale.
  Future<List<SpyPackEntity>> getSpyPacks(String localeCode);

  /// Returns bundled placeholder packs shown when nothing is cached yet.
  List<SpyPackEntity> getFallbackSpyPacks(String localeCode);

  /// Whether spy packs for the locale are cached and not stale.
  Future<bool> areSpyPacksCached(String localeCode);

  /// Downloads all spy packs for the locale and caches them locally.
  Future<void> downloadSpyPacks(String localeCode);

  /// Draws a random not-yet-played secret word from [pack] and records it,
  /// reshuffling the deck when every word has been played.
  Future<String> drawSecret({
    required String localeCode,
    required SpyPackEntity pack,
  });
}
