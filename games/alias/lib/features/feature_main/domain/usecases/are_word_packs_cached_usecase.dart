import 'package:alias/features/feature_main/domain/repositories/alias_main_repository.dart';

/// Checks if word packs for a given locale are cached locally (in Hive).
class AreWordPacksCachedUseCase {
  final AliasMainRepository repository;

  AreWordPacksCachedUseCase(this.repository);

  Future<bool> call(AreWordPacksCachedParams params) async {
    return await repository.areWordPacksCached(params);
  }
}

//// Parameters for checking if word packs are cached.
class AreWordPacksCachedParams {
  final String localeCode;

  const AreWordPacksCachedParams({required this.localeCode});
}
