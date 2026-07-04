import 'package:bardak/features/games/spy/spy_packs/domain/entities/spy_pack_entity.dart';
import 'package:bardak/features/games/spy/spy_packs/domain/repositories/spy_packs_repository.dart';

/// Draws a random not-yet-played secret word from a pack and records it,
/// so words never repeat until the whole pack has been played.
class DrawSpySecretUseCase {
  const DrawSpySecretUseCase(this._spyPacksRepository);

  final SpyPacksRepository _spyPacksRepository;

  Future<String> call(DrawSpySecretParams params) {
    return _spyPacksRepository.drawSecret(
      localeCode: params.localeCode,
      pack: params.pack,
    );
  }
}

/// Parameters for drawing a secret word.
class DrawSpySecretParams {
  const DrawSpySecretParams({required this.localeCode, required this.pack});

  final String localeCode;
  final SpyPackEntity pack;
}
