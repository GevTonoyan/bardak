import 'package:bardak/features/games/spy/spy_packs/domain/entities/spy_pack_entity.dart';
import 'package:bardak/features/games/spy/spy_packs/domain/repositories/spy_packs_repository.dart';

/// Gets the player-created packs, shown in every language.
class GetCustomSpyPacksUseCase {
  const GetCustomSpyPacksUseCase(this._spyPacksRepository);

  final SpyPacksRepository _spyPacksRepository;

  Future<List<SpyPackEntity>> call() {
    return _spyPacksRepository.getCustomSpyPacks();
  }
}
