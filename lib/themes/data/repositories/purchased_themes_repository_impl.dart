import 'package:bardak/app_ui/theme/app_color_scheme.dart';
import 'package:bardak/themes/data/data_sources/purchased_themes_local_data_source.dart';
import 'package:bardak/themes/domain/repositories/purchased_themes_repository.dart';

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
