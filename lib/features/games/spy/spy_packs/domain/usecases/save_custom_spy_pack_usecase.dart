import 'package:bardak/features/games/spy/spy_packs/domain/entities/spy_pack_entity.dart';
import 'package:bardak/features/games/spy/spy_packs/domain/repositories/spy_packs_repository.dart';

/// Creates or updates (upsert) a player-created pack. A new pack (null id)
/// is assigned a locally-unique id; an existing id replaces that pack.
class SaveCustomSpyPackUseCase {
  const SaveCustomSpyPackUseCase(this._spyPacksRepository);

  final SpyPacksRepository _spyPacksRepository;

  Future<void> call(SaveCustomSpyPackParams params) {
    final id = params.id ?? 'custom_${DateTime.now().microsecondsSinceEpoch}';

    return _spyPacksRepository.saveCustomSpyPack(
      SpyPackEntity(
        id: id,
        name: params.name,
        words: params.words,
        image: '',
        imageBlurHash: '',
        isCustom: true,
      ),
    );
  }
}

class SaveCustomSpyPackParams {
  const SaveCustomSpyPackParams({
    required this.name,
    required this.words,
    this.id,
  });

  /// Null when creating a new pack; set when editing an existing one.
  final String? id;
  final String name;
  final List<String> words;
}
