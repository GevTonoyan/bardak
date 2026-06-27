import 'package:bardak/core/app_ui/theme/colors/app_color_scheme.dart';
import 'package:bardak/features/themes/domain/repositories/purchased_themes_repository.dart';

/// Use case to persist an updated list of purchased themes.
class UpdatePurchasedThemesUseCase {
  const UpdatePurchasedThemesUseCase(this._repository);

  final PurchasedThemesRepository _repository;

  Future<bool> call(List<AppColorScheme> themes) async {
    return _repository.updatePurchasedThemes(themes);
  }
}
