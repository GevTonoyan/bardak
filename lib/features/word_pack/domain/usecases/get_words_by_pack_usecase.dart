import 'package:boardify/features/word_pack/domain/repositories/word_packs_repository.dart';

class GetWordsByPackUseCase {
  const GetWordsByPackUseCase(this.repository);

  final WordPacksRepository repository;

  Future<List<String>> call(GetWordsByPackParams params) {
    return repository.getWordsByPack(params);
  }
}

class GetWordsByPackParams {
  const GetWordsByPackParams({required this.localeCode});

  final String localeCode;
}
