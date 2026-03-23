import 'package:alias_pro/app_ui/theme/app_color_scheme.dart';
import 'package:alias_pro/themes/data/data_sources/purchased_themes_local_data_source.dart';
import 'package:alias_pro/themes/domain/repositories/purchased_themes_repository.dart';

/// Implementation of [PurchasedThemesRepository] that delegates
/// to the local data source.
class PurchasedThemesRepositoryImpl implements PurchasedThemesRepository {
  const PurchasedThemesRepositoryImpl({required this.dataSource});

  final PurchasedThemesLocalDataSource dataSource;

  @override
  List<AppColorScheme> getPurchasedThemes() => dataSource.getPurchasedThemes();

  @override
  Future<bool> updatePurchasedThemes(List<AppColorScheme> themes) =>
      dataSource.updatePurchasedThemes(themes);
}
