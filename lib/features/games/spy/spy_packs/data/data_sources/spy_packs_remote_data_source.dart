import 'package:bardak/features/games/spy/spy_packs/domain/entities/spy_pack_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Remote data source for fetching spy packs.
abstract interface class SpyPacksRemoteDataSource {
  /// Returns all spy packs for the given locale.
  Future<List<SpyPackEntity>> getSpyPacks(String localeCode);
}

/// Implementation of [SpyPacksRemoteDataSource] backed by Firestore.
class SpyPacksRemoteDataSourceImpl implements SpyPacksRemoteDataSource {
  const SpyPacksRemoteDataSourceImpl({required this._firestore});

  static const _spyPacksCollection = 'spy_packs';

  final FirebaseFirestore _firestore;

  @override
  Future<List<SpyPackEntity>> getSpyPacks(String localeCode) async {
    final doc = await _firestore
        .collection(_spyPacksCollection)
        .doc(localeCode)
        .get();

    if (!doc.exists) return [];

    final data = doc.data();
    if (data == null) return [];

    return data.entries.map((entry) {
      return SpyPackEntity.fromJson(
        entry.key,
        Map<String, dynamic>.from(entry.value as Map),
      );
    }).toList();
  }
}
