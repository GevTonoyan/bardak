import 'package:bardak/core/localizations/app_locale.dart';
import 'package:bardak/features/games/alias/word_packs/data/data_sources/word_packs_fallbacks.dart';
import 'package:bardak/features/games/alias/word_packs/domain/entities/word_pack_entity.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Local data source for accessing and storing word pack information.
abstract interface class WordPacksLocalDataSource {
  /// Returns cached word packs for the given locale.
  Future<List<WordPackEntity>> getWordPacks(String localeCode);

  /// Returns bundled fallback packs shown when nothing is cached yet.
  List<WordPackEntity> getFallbackWordPacks(String localeCode);

  /// Replaces the cached word packs for the given locale.
  Future<void> cacheWordPacks(String localeCode, List<WordPackEntity> packs);

  /// Checks whether word packs are cached for the given locale.
  Future<bool> areWordPacksCached(String localeCode);

  /// Returns true if the sync interval has elapsed since the last sync.
  bool isSyncNeeded();

  /// Persists the current timestamp as the last sync time.
  Future<void> updateLastSyncTimestamp();
}

/// Implementation of [WordPacksLocalDataSource] backed by Hive (packs)
/// and SharedPreferences (sync timestamp).
class WordPacksLocalDataSourceImpl implements WordPacksLocalDataSource {
  const WordPacksLocalDataSourceImpl({required this._preferences});

  static const _boxPrefix = 'alias_word_packs';
  static const _nameKey = 'alias_word_pack_name';
  static const _wordsKey = 'alias_word_pack_words';
  static const _imageKey = 'alias_word_pack_image';
  static const _imageBlurHashKey = 'alias_word_pack_image_blur_hash';
  static const _lastSyncKey = 'last_words_sync';
  static const _syncIntervalDays = 3;

  final SharedPreferences _preferences;

  static String _boxName(String localeCode) => '${_boxPrefix}_$localeCode';

  @override
  Future<List<WordPackEntity>> getWordPacks(String localeCode) async {
    final box = await Hive.openBox<Map<dynamic, dynamic>>(
      _boxName(localeCode),
    );

    return box.keys.map((key) {
      final data = Map<String, dynamic>.from(box.get(key)!);

      return WordPackEntity(
        id: key as String,
        name: data[_nameKey] as String,
        words: List<String>.from(data[_wordsKey] as List),
        image: data[_imageKey] as String,
        imageBlurHash: data[_imageBlurHashKey] as String,
      );
    }).toList();
  }

  @override
  List<WordPackEntity> getFallbackWordPacks(String localeCode) {
    return fallbackWordPacksFor(AppLocale.fromString(localeCode));
  }

  @override
  Future<bool> areWordPacksCached(String localeCode) async {
    final boxName = _boxName(localeCode);

    if (!Hive.isBoxOpen(boxName)) {
      final exists = await Hive.boxExists(boxName);
      if (!exists) return false;
    }

    final box = await Hive.openBox<Map<dynamic, dynamic>>(boxName);
    return box.isNotEmpty;
  }

  @override
  Future<void> cacheWordPacks(
    String localeCode,
    List<WordPackEntity> packs,
  ) async {
    final box = await Hive.openBox<Map<dynamic, dynamic>>(
      _boxName(localeCode),
    );

    final entries = {
      for (final pack in packs)
        pack.id: <String, dynamic>{
          _nameKey: pack.name,
          _wordsKey: pack.words,
          _imageKey: pack.image,
          _imageBlurHashKey: pack.imageBlurHash,
        },
    };

    // Replace the whole box so packs removed remotely disappear too.
    await box.clear();
    await box.putAll(entries);
  }

  @override
  bool isSyncNeeded() {
    final lastSyncMs = _preferences.getInt(_lastSyncKey) ?? 0;
    final lastSync = DateTime.fromMillisecondsSinceEpoch(lastSyncMs);
    return DateTime.now().difference(lastSync).inDays >= _syncIntervalDays;
  }

  @override
  Future<void> updateLastSyncTimestamp() {
    return _preferences.setInt(
      _lastSyncKey,
      DateTime.now().millisecondsSinceEpoch,
    );
  }
}
