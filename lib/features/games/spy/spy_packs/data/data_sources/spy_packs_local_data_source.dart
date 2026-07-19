import 'package:bardak/core/localizations/app_locale.dart';
import 'package:bardak/features/games/spy/spy_packs/data/data_sources/spy_packs_fallbacks.dart';
import 'package:bardak/features/games/spy/spy_packs/domain/entities/spy_pack_entity.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Local data source for caching spy packs and remembering played secrets.
abstract interface class SpyPacksLocalDataSource {
  /// Returns cached spy packs for the given locale.
  Future<List<SpyPackEntity>> getSpyPacks(String localeCode);

  /// Returns bundled placeholder packs shown when nothing is cached yet.
  List<SpyPackEntity> getFallbackSpyPacks(String localeCode);

  /// Replaces the cached spy packs for the given locale.
  Future<void> cacheSpyPacks(String localeCode, List<SpyPackEntity> packs);

  /// Checks whether spy packs are cached for the given locale.
  Future<bool> areSpyPacksCached(String localeCode);

  /// Returns true if the sync interval has elapsed since the last sync.
  bool isSyncNeeded();

  /// Persists the current timestamp as the last sync time.
  Future<void> updateLastSyncTimestamp();

  /// Returns the secrets already played from the pack, in play order.
  List<String> getUsedSecrets(String localeCode, String packId);

  /// Persists the secrets already played from the pack.
  Future<bool> updateUsedSecrets(
    String localeCode,
    String packId,
    List<String> usedSecrets,
  );
}

/// Implementation of [SpyPacksLocalDataSource] backed by Hive (packs)
/// and SharedPreferences (sync timestamp, played secrets).
class SpyPacksLocalDataSourceImpl implements SpyPacksLocalDataSource {
  const SpyPacksLocalDataSourceImpl({required this._preferences});

  static const _boxPrefix = 'spy_packs';
  static const _nameKey = 'spy_pack_name';
  static const _wordsKey = 'spy_pack_words';
  static const _imageKey = 'spy_pack_image';
  static const _imageBlurHashKey = 'spy_pack_image_blur_hash';
  static const _lastSyncKey = 'spy_last_packs_sync';
  static const _usedSecretsKeyPrefix = 'spy_used_secrets';
  static const _syncIntervalDays = 3;

  final SharedPreferences _preferences;

  static String _boxName(String localeCode) => '${_boxPrefix}_$localeCode';

  static String _usedSecretsKey(String localeCode, String packId) =>
      '${_usedSecretsKeyPrefix}_${localeCode}_$packId';

  @override
  Future<List<SpyPackEntity>> getSpyPacks(String localeCode) async {
    final box = await Hive.openBox<Map<dynamic, dynamic>>(
      _boxName(localeCode),
    );

    return box.keys.map((key) {
      final data = Map<String, dynamic>.from(box.get(key)!);

      return SpyPackEntity(
        id: key as String,
        name: data[_nameKey] as String,
        words: List<String>.from(data[_wordsKey] as List),
        image: data[_imageKey] as String,
        imageBlurHash: data[_imageBlurHashKey] as String,
      );
    }).toList();
  }

  @override
  List<SpyPackEntity> getFallbackSpyPacks(String localeCode) {
    return fallbackSpyPacksFor(AppLocale.fromString(localeCode));
  }

  @override
  Future<bool> areSpyPacksCached(String localeCode) async {
    final boxName = _boxName(localeCode);

    if (!Hive.isBoxOpen(boxName)) {
      final exists = await Hive.boxExists(boxName);
      if (!exists) return false;
    }

    final box = await Hive.openBox<Map<dynamic, dynamic>>(boxName);
    return box.isNotEmpty;
  }

  @override
  Future<void> cacheSpyPacks(
    String localeCode,
    List<SpyPackEntity> packs,
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

  @override
  List<String> getUsedSecrets(String localeCode, String packId) {
    return _preferences.getStringList(_usedSecretsKey(localeCode, packId)) ??
        const [];
  }

  @override
  Future<bool> updateUsedSecrets(
    String localeCode,
    String packId,
    List<String> usedSecrets,
  ) {
    return _preferences.setStringList(
      _usedSecretsKey(localeCode, packId),
      usedSecrets,
    );
  }
}
