import 'package:bardak/core/app_ui/theme/colors/app_color_scheme.dart';
import 'package:bardak/features/themes/data/data_sources/purchased_themes_local_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late PurchasedThemesLocalDataSourceImpl dataSource;

  setUp(() async {
    SharedPreferences.setMockInitialValues(const {});
    dataSource = PurchasedThemesLocalDataSourceImpl(
      preferences: await SharedPreferences.getInstance(),
    );
  });

  test('main, blue and dark are owned by default', () {
    expect(
      dataSource.getPurchasedThemes(),
      [AppColorScheme.main, AppColorScheme.blue, AppColorScheme.dark],
    );
  });

  test('updates round-trip through getPurchasedThemes', () async {
    final owned = [AppColorScheme.main, AppColorScheme.purple];

    await dataSource.updatePurchasedThemes(owned);

    expect(dataSource.getPurchasedThemes(), owned);
  });
}
