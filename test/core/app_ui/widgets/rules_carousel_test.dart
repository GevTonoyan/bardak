import 'package:bardak/core/app_ui/theme/app_theme_builder.dart';
import 'package:bardak/core/app_ui/theme/app_theme_provider.dart';
import 'package:bardak/core/app_ui/theme/colors/app_color_scheme.dart';
import 'package:bardak/core/app_ui/theme/text_styles/app_text_styles.dart';
import 'package:bardak/core/app_ui/widgets/rules_carousel.dart';
import 'package:bardak/core/localizations/app_locale.dart';
import 'package:bardak/core/localizations/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> pumpCarousel(WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final themeData = AppThemeData(
      colors: AppColorScheme.turquoise.colors,
      typography: AppTextStyles(),
      themeData: buildAppTheme(AppTextStyles()),
    );

    await tester.pumpWidget(
      AppThemeProvider(
        data: themeData,
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocale.supportedLocales,
          locale: const Locale('en'),
          theme: themeData.themeData,
          home: const RulesCarousel(
            steps: [
              RuleStep(
                illustration: SizedBox(width: 40, height: 40),
                title: 'Rule one',
                description: 'First rule description',
              ),
              RuleStep(
                illustration: SizedBox(width: 40, height: 40),
                title: 'Rule two',
                description: 'Second rule description',
              ),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('starts on the first step with a Next button', (tester) async {
    await pumpCarousel(tester);

    // TextWithBorder renders the title twice (stroke + fill).
    expect(find.text('Rule one'), findsWidgets);
    expect(find.text('Next'), findsOneWidget);
    expect(find.text('Got it'), findsNothing);
  });

  testWidgets('Next advances to the last step and shows Got it', (
    tester,
  ) async {
    await pumpCarousel(tester);

    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    expect(find.text('Rule two'), findsWidgets);
    expect(find.text('Got it'), findsOneWidget);
    expect(find.text('Next'), findsNothing);
  });
}
