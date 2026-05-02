import 'package:bardak/word_pack/domain/repositories/word_packs_repository.dart';

/// Fetches all word packs from Firestore for a given locale
/// and stores them in Hive.
class FetchAndCacheWordPacksUseCase {
  FetchAndCacheWordPacksUseCase(this.repository);

  final WordPacksRepository repository;

  Future<void> call(FetchAndCacheWordPacksParams params) async {
    await repository.fetchAndCacheWordPacks(params);
  }
}

/// Parameters for fetching and caching word packs.
class FetchAndCacheWordPacksParams {
  const FetchAndCacheWordPacksParams({required this.localeCode});

  final String localeCode;
}
