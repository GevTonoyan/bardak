import 'package:bardak/features/games/spy/spy_packs/domain/repositories/spy_packs_repository.dart';

/// Deletes the player-created pack with the given id.
class DeleteCustomSpyPackUseCase {
  const DeleteCustomSpyPackUseCase(this._spyPacksRepository);

  final SpyPacksRepository _spyPacksRepository;

  Future<void> call(String id) {
    return _spyPacksRepository.deleteCustomSpyPack(id);
  }
}
