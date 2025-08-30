import 'package:boardify/features/home/domain/repositories/home_repository.dart';

/// Checks if word packs for a given locale are cached locally (in Hive).
class AreWordPacksCachedUseCase {
  AreWordPacksCachedUseCase(this.repository);

  final HomeRepository repository;

  Future<bool> call(AreWordPacksCachedParams params) async =>
      repository.areWordPacksCached(params);
}

//// Parameters for checking if word packs are cached.
class AreWordPacksCachedParams {
  const AreWordPacksCachedParams({required this.localeCode});

  final String localeCode;
}
