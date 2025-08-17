import 'package:boardify/features/home/domain/repositories/home_repository.dart';


/// Fetches all word packs from Firestore for a given locale and stores them in Hive.
class FetchAndCacheWordPacksUseCase {
  final HomeRepository repository;

  FetchAndCacheWordPacksUseCase(this.repository);

  Future<void> call(FetchAndCacheWordPacksParams params) async {
    await repository.fetchAndCacheWordPacks(params);
  }
}

/// Parameters for fetching and caching word packs.
class FetchAndCacheWordPacksParams {
  final String localeCode;

  const FetchAndCacheWordPacksParams({required this.localeCode});
}
