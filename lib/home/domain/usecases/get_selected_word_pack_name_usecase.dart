import 'package:boardify/home/domain/repositories/home_repository.dart';

/// Use case to get the selected word pack name.
/// This use case retrieves the name of the currently selected
/// word pack with the given locale code.
class GetSelectedWordPackNameUseCase {
  const GetSelectedWordPackNameUseCase(this._aliasMainRepository);

  final HomeRepository _aliasMainRepository;

  Future<String> call({required GetSelectedWordPackNameParams params}) async {
    return _aliasMainRepository.getSelectedWordPackName(params);
  }
}

/// Parameters required to fetch the selected word pack name.
class GetSelectedWordPackNameParams {
  const GetSelectedWordPackNameParams({required this.localeCode});

  final String localeCode;
}
