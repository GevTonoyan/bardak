import 'package:alias/features/feature_main/domain/repositories/alias_main_repository.dart';

/// Use case to get the selected word pack name.
/// This use case retrieves the name of the currently selected word pack with the given locale code.
class GetSelectedWordPackNameUseCase {
  final AliasMainRepository _aliasMainRepository;

  const GetSelectedWordPackNameUseCase(this._aliasMainRepository);

  Future<String> call({required GetSelectedWordPackNameParams params}) async {
    return _aliasMainRepository.getSelectedWordPackName(params);
  }
}

/// Parameters required to fetch the selected word pack name.
class GetSelectedWordPackNameParams {
  final String localeCode;

  const GetSelectedWordPackNameParams({required this.localeCode});
}
