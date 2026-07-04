import 'package:bardak/features/games/alias/word_packs/domain/entities/word_pack_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Remote data source for fetching word packs.
abstract interface class WordPacksRemoteDataSource {
  /// Returns all word packs for the given locale.
  Future<List<WordPackEntity>> getWordPacks(String localeCode);
}

/// Implementation of [WordPacksRemoteDataSource] backed by Firestore.
class WordPacksRemoteDataSourceImpl implements WordPacksRemoteDataSource {
  const WordPacksRemoteDataSourceImpl({required this._firestore});

  static const _wordPacksCollection = 'word_packs';

  final FirebaseFirestore _firestore;

  @override
  Future<List<WordPackEntity>> getWordPacks(String localeCode) async {
    final doc = await _firestore
        .collection(_wordPacksCollection)
        .doc(localeCode)
        .get();

    if (!doc.exists) return [];

    final data = doc.data();
    if (data == null) return [];

    return data.entries.map((entry) {
      return WordPackEntity.fromJson(
        entry.key,
        Map<String, dynamic>.from(entry.value as Map),
      );
    }).toList();
  }
}
