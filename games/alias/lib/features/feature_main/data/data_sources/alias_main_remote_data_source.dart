import 'package:alias/features/feature_main/domain/entities/alias_word_pack_entity.dart';
import 'package:alias/features/feature_main/domain/usecases/fetch_and_cache_word_packs_usecase.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Handles fetching data from Firebase Firestore.
abstract interface class AliasMainRemoteDataSource {
  /// Returns all word packs for a given locale from Firestore.
  Future<List<AliasWordPackEntity>> getWordPacks(FetchAndCacheWordPacksParams params);
}

class AliasMainRemoteDataSourceImpl implements AliasMainRemoteDataSource {
  final FirebaseFirestore firestore;

  const AliasMainRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<AliasWordPackEntity>> getWordPacks(FetchAndCacheWordPacksParams params) async {
    final doc = await firestore.collection('word_packs').doc(params.localeCode).get();

    if (!doc.exists) return [];

    final data = doc.data();
    if (data == null) return [];

    final packs =
        data.entries.map((entry) {
          return AliasWordPackEntity.fromFirestore(
            entry.key,
            Map<String, dynamic>.from(entry.value),
          );
        }).toList();

    return packs;
  }
}
