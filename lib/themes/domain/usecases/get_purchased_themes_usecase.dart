import 'package:alias_pro/app_ui/theme/app_color_scheme.dart';
import 'package:alias_pro/themes/domain/repositories/purchased_themes_repository.dart';

/// Use case to retrieve the list of themes the user owns.
class GetPurchasedThemesUseCase {
  const GetPurchasedThemesUseCase(this._repository);

  final PurchasedThemesRepository _repository;

  List<AppColorScheme> call() {
    return _repository.getPurchasedThemes();
  }
}
