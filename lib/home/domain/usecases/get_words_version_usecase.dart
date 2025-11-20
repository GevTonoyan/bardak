import 'package:boardify/home/domain/repositories/home_repository.dart';

class GetWordsVersionUseCase {
  const GetWordsVersionUseCase(this._homeRepository);

  final HomeRepository _homeRepository;

  int call({required GetWordsVersionParams params}) =>
      _homeRepository.getWordsVersion(params);
}

/// Parameters required to fetch the version of words.
class GetWordsVersionParams {
  const GetWordsVersionParams({required this.localeCode});

  final String localeCode;
}
