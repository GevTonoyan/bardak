import 'package:alias_pro/word_pack/domain/repositories/word_packs_repository.dart';

/// Checks if word packs for a given locale are cached locally (in Hive).
class ArePacksCachedUseCase {
  ArePacksCachedUseCase(this.repository);

  final WordPacksRepository repository;

  Future<bool> call(AreWordPacksCachedParams params) async =>
      repository.areWordPacksCached(params);
}

//// Parameters for checking if word packs are cached.
class AreWordPacksCachedParams {
  const AreWordPacksCachedParams({required this.localeCode});

  final String localeCode;
}
