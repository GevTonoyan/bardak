import 'package:bardak/features/games/spy/spy_packs/domain/entities/spy_pack_entity.dart';
import 'package:bardak/features/games/spy/spy_packs/domain/repositories/spy_packs_repository.dart';

/// Gets all cached spy packs for the given locale.
class GetSpyPacksUseCase {
  const GetSpyPacksUseCase(this._spyPacksRepository);

  final SpyPacksRepository _spyPacksRepository;

  Future<List<SpyPackEntity>> call(String localeCode) {
    return _spyPacksRepository.getSpyPacks(localeCode);
  }
}
