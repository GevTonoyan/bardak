import 'dart:math';

import 'package:bardak/core/app_ui/theme/app_theme_builder.dart';
import 'package:bardak/core/app_ui/theme/app_theme_provider.dart';
import 'package:bardak/core/app_ui/theme/colors/app_color_scheme.dart';
import 'package:bardak/core/app_ui/theme/text_styles/app_text_styles.dart';
import 'package:bardak/core/app_ui/widgets/app_button/app_button.dart';
import 'package:bardak/core/localizations/app_locale.dart';
import 'package:bardak/core/localizations/l10n/app_localizations.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/ship_entity.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_placement/domain/usecases/generate_random_fleet_usecase.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_placement/presentation/bloc/ship_placement_bloc.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_placement/presentation/ui/sea_battle_placement_screen.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_placement/presentation/ui/widgets/placement_board.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<ShipPlacementBloc> pumpScreen(WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final bloc = ShipPlacementBloc(
      generateRandomFleetUseCase: GenerateRandomFleetUseCase(
        random: Random(1),
      ),
    );
    addTearDown(bloc.close);

    final themeData = AppThemeData(
      colors: AppColorScheme.main.colors,
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
          home: BlocProvider.value(
            value: bloc,
            child: const SeaBattlePlacementScreen(
              args: SeaBattlePlacementArgs(mode: .solo),
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    return bloc;
  }

  /// The Start button, disabled until the whole fleet is placed.
  AppButton startButton(WidgetTester tester) =>
      tester.widget<AppButton>(find.widgetWithText(AppButton, 'Start'));

  testWidgets('Start waits for the whole fleet', (tester) async {
    await pumpScreen(tester);

    expect(startButton(tester).onPressed, isNull);
  });

  testWidgets('Shuffle places the whole fleet', (tester) async {
    final bloc = await pumpScreen(tester);

    await tester.tap(find.bySemanticsLabel('Shuffle'));
    await tester.pumpAndSettle();

    expect(bloc.state.fleet.isComplete, isTrue);
    expect(startButton(tester).onPressed, isNotNull);
  });

  testWidgets('tapping a placed ship turns it', (tester) async {
    final bloc = await pumpScreen(tester);
    await tester.tap(find.bySemanticsLabel('Shuffle'));
    await tester.pumpAndSettle();

    // A ship that has room to turn in place, so the outcome is known.
    final ship = bloc.state.fleet.ships.firstWhere(
      (ship) =>
          ship.length > 1 && bloc.state.fleet.canPlace(ship.rotations.first),
    );
    final board = tester.getTopLeft(find.byType(PlacementBoard));
    final cellSize = tester.getSize(find.byType(PlacementBoard)).width / 10;
    await tester.tapAt(
      board +
          Offset(
            (ship.origin.column + 0.5) * cellSize,
            (ship.origin.row + 0.5) * cellSize,
          ),
    );
    await tester.pumpAndSettle();

    final turned = bloc.state.fleet.ships.firstWhere((s) => s.id == ship.id);
    expect(turned.orientation, isNot(ship.orientation));
    expect(turned, ship.rotations.first);
    expect(turned, isA<ShipEntity>());
  });
}
