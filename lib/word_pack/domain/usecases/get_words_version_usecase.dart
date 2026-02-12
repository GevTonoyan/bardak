import 'package:boardify/word_pack/domain/repositories/word_packs_repository.dart';

class GetWordsVersionUseCase {
  const GetWordsVersionUseCase(this._repository);

  final WordPacksRepository _repository;

  int call({required GetWordsVersionParams params}) =>
      _repository.getWordsVersion(params);
}

/// Parameters required to fetch the version of words.
class GetWordsVersionParams {
  const GetWordsVersionParams({required this.localeCode});

  final String localeCode;
}
