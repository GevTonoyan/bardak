import 'package:boardify/features/home/domain/entities/alias_word_pack_entity.dart';
import 'package:boardify/features/home/domain/usecases/fetch_and_cache_word_packs_usecase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Handles fetching data from Firebase Firestore.
abstract interface class HomeRemoteDataSource {
  /// Returns all word packs for a given locale from Firestore.
  Future<List<WordPackEntity>> getWordPacks(
    FetchAndCacheWordPacksParams params,
  );
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  const HomeRemoteDataSourceImpl({required this.firestore});
  final FirebaseFirestore firestore;

  @override
  Future<List<WordPackEntity>> getWordPacks(
    FetchAndCacheWordPacksParams params,
  ) async {
    final doc =
        await firestore.collection('word_packs').doc(params.localeCode).get();

    if (!doc.exists) return [];

    final data = doc.data();
    if (data == null) return [];

    final packs =
        data.entries.map((entry) {
          return WordPackEntity.fromFirestore(
            entry.key,
            Map<String, dynamic>.from(entry.value),
          );
        }).toList();

    return packs;
  }
}
