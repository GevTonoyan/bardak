import 'dart:async';

import 'package:boardify/features/word_pack/domain/repositories/word_packs_repository.dart';

/// Stores the user's selected word pack ID to local cache.
class SetSelectedWordPackUseCase {
  SetSelectedWordPackUseCase(this.repository);

  final WordPacksRepository repository;

  Future<void> call(SetSelectedWordPackParams params) {
    return repository.setSelectedWordPack(params);
  }
}

class SetSelectedWordPackParams {
  const SetSelectedWordPackParams({
    required this.localeCode,
    required this.packId,
  });

  final String localeCode;
  final String packId;
}
