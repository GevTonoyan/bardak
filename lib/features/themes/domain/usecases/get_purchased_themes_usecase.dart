import 'package:bardak/core/app_ui/theme/colors/app_color_scheme.dart';
import 'package:bardak/features/themes/domain/repositories/purchased_themes_repository.dart';

/// Use case to retrieve the list of themes the user owns.
class GetPurchasedThemesUseCase {
  const GetPurchasedThemesUseCase(this._purchasedThemesRepository);

  final PurchasedThemesRepository _purchasedThemesRepository;

  List<AppColorScheme> call() {
    return _purchasedThemesRepository.getPurchasedThemes();
  }
}
