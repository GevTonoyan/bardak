import 'package:boardify/features/home/domain/repositories/home_repository.dart';


/// Checks if word packs for a given locale are cached locally (in Hive).
class AreWordPacksCachedUseCase {
  final HomeRepository repository;

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
