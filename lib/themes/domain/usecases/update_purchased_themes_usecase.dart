import 'package:alias_pro/app_ui/theme/app_color_scheme.dart';
import 'package:alias_pro/themes/domain/repositories/purchased_themes_repository.dart';

/// Use case to persist an updated list of purchased themes.
class UpdatePurchasedThemesUseCase {
  const UpdatePurchasedThemesUseCase(this._repository);

  final PurchasedThemesRepository _repository;

  Future<bool> call(List<AppColorScheme> themes) async {
    return _repository.updatePurchasedThemes(themes);
  }
}
