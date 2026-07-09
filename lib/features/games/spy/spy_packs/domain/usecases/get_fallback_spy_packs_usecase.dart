import 'package:bardak/features/games/spy/spy_packs/domain/entities/spy_pack_entity.dart';
import 'package:bardak/features/games/spy/spy_packs/domain/repositories/spy_packs_repository.dart';

/// Gets the bundled placeholder packs shown when nothing is cached yet.
class GetFallbackSpyPacksUseCase {
  const GetFallbackSpyPacksUseCase(this._spyPacksRepository);

  final SpyPacksRepository _spyPacksRepository;

  List<SpyPackEntity> call(String localeCode) {
    return _spyPacksRepository.getFallbackSpyPacks(localeCode);
  }
}
