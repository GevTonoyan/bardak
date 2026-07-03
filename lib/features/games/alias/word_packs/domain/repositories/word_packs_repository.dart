import 'package:bardak/features/games/alias/word_packs/domain/entities/word_pack_entity.dart';

/// Abstract repository to handle word pack data operations.
abstract interface class WordPacksRepository {
  /// Returns cached word packs for the given locale.
  Future<List<WordPackEntity>> getWordPacks(String localeCode);

  /// Returns bundled fallback packs shown when nothing is cached yet.
  List<WordPackEntity> getFallbackWordPacks(String localeCode);

  /// Whether word packs for the locale are cached and not stale.
  Future<bool> areWordPacksCached(String localeCode);

  /// Downloads all word packs for the locale and caches them locally.
  Future<void> downloadWordPacks(String localeCode);
}
