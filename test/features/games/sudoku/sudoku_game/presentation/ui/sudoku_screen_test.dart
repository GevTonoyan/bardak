import 'dart:math';

import 'package:bardak/core/app_ui/theme/app_theme_builder.dart';
import 'package:bardak/core/app_ui/theme/app_theme_provider.dart';
import 'package:bardak/core/app_ui/theme/colors/app_color_scheme.dart';
import 'package:bardak/core/app_ui/theme/text_styles/app_text_styles.dart';
import 'package:bardak/core/localizations/app_locale.dart';
import 'package:bardak/core/localizations/l10n/app_localizations.dart';
import 'package:bardak/features/games/sudoku/sudoku_game/domain/entities/sudoku_board_entity.dart';
import 'package:bardak/features/games/sudoku/sudoku_game/presentation/bloc/sudoku_bloc.dart';
import 'package:bardak/features/games/sudoku/sudoku_game/presentation/ui/sudoku_screen.dart';
import 'package:bardak/features/games/sudoku/sudoku_settings/domain/entities/sudoku_mistakes_mode.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late SudokuBoardEntity board;
  late int emptyIndex;

  setUp(() {
    board = SudokuBoardEntity.generate(random: Random(1));
    emptyIndex = board.given.indexOf(false);
  });

  Future<SudokuBloc> pumpScreen(WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final bloc = SudokuBloc(
      board: board,
      mistakesMode: SudokuMistakesMode.errors,
      showTimer: true,
    );
    addTearDown(bloc.close);

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
          home: BlocProvider.value(value: bloc, child: const SudokuScreen()),
        ),
      ),
    );
    await tester.pump();
    return bloc;
  }

  testWidgets('tapping an empty cell selects it', (tester) async {
    final bloc = await pumpScreen(tester);

    expect(bloc.state.selectedIndex, isNull);

    await tester.tap(find.byKey(ValueKey(emptyIndex)));
    await tester.pump();

    expect(bloc.state.selectedIndex, emptyIndex);

    // Unmount so the screen's periodic timer is cancelled.
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('selecting an empty cell then a digit enters the number', (
    tester,
  ) async {
    final bloc = await pumpScreen(tester);

    await tester.tap(find.byKey(ValueKey(emptyIndex)));
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('sudoku_digit_5')));
    await tester.pump();

    expect(bloc.state.board.values[emptyIndex], 5);

    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('mistakes indicator counts a wrong entry', (tester) async {
    await pumpScreen(tester);

    expect(find.text('0/3'), findsOneWidget);

    final wrong = board.solution[emptyIndex] == 1 ? 2 : 1;
    await tester.tap(find.byKey(ValueKey(emptyIndex)));
    await tester.pump();
    await tester.tap(find.byKey(ValueKey('sudoku_digit_$wrong')));
    await tester.pump();

    expect(find.text('1/3'), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('undo button reverts the last entered digit', (tester) async {
    final bloc = await pumpScreen(tester);

    await tester.tap(find.byKey(ValueKey(emptyIndex)));
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('sudoku_digit_5')));
    await tester.pump();
    expect(bloc.state.board.values[emptyIndex], 5);

    await tester.tap(find.byKey(const ValueKey('sudoku_undo')));
    await tester.pump();
    expect(bloc.state.board.values[emptyIndex], SudokuBoardEntity.empty);

    await tester.pumpWidget(const SizedBox());
  });
}
