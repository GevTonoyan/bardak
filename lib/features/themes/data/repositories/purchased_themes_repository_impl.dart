import 'package:bardak/core/app_ui/theme/colors/app_color_scheme.dart';
import 'package:bardak/features/themes/data/data_sources/purchased_themes_local_data_source.dart';
import 'package:bardak/features/themes/domain/repositories/purchased_themes_repository.dart';

/// Implementation of [PurchasedThemesRepository] that delegates
/// to the local data source.
class PurchasedThemesRepositoryImpl implements PurchasedThemesRepository {
  const PurchasedThemesRepositoryImpl({required this._dataSource});

  final PurchasedThemesLocalDataSource _dataSource;

  @override
  List<AppColorScheme> getPurchasedThemes() => _dataSource.getPurchasedThemes();

  @override
  Future<bool> updatePurchasedThemes(List<AppColorScheme> themes) =>
      _dataSource.updatePurchasedThemes(themes);
}
