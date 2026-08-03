import 'dart:math';

import 'package:bardak/core/app_ui/theme/app_theme_builder.dart';
import 'package:bardak/core/app_ui/theme/app_theme_provider.dart';
import 'package:bardak/core/app_ui/theme/colors/app_color_scheme.dart';
import 'package:bardak/core/app_ui/theme/text_styles/app_text_styles.dart';
import 'package:bardak/core/localizations/app_locale.dart';
import 'package:bardak/core/localizations/l10n/app_localizations.dart';
import 'package:bardak/features/games/sudoku/sudoku_game/domain/entities/sudoku_board_entity.dart';
import 'package:bardak/features/games/sudoku/sudoku_game/domain/entities/sudoku_saved_game_entity.dart';
import 'package:bardak/features/games/sudoku/sudoku_game/domain/entities/sudoku_stats_entity.dart';
import 'package:bardak/features/games/sudoku/sudoku_game/domain/entities/sudoku_win_record_entity.dart';
import 'package:bardak/features/games/sudoku/sudoku_game/domain/usecases/clear_saved_sudoku_game_usecase.dart';
import 'package:bardak/features/games/sudoku/sudoku_game/domain/usecases/generate_sudoku_board_usecase.dart';
import 'package:bardak/features/games/sudoku/sudoku_game/domain/usecases/get_sudoku_stats_usecase.dart';
import 'package:bardak/features/games/sudoku/sudoku_game/domain/usecases/has_saved_sudoku_game_usecase.dart';
import 'package:bardak/features/games/sudoku/sudoku_game/domain/usecases/record_sudoku_win_usecase.dart';
import 'package:bardak/features/games/sudoku/sudoku_game/domain/usecases/update_saved_sudoku_game_usecase.dart';
import 'package:bardak/features/games/sudoku/sudoku_game/presentation/bloc/sudoku_bloc.dart';
import 'package:bardak/features/games/sudoku/sudoku_game/presentation/ui/screens/sudoku_screen.dart';
import 'package:bardak/features/games/sudoku/sudoku_settings/domain/entities/sudoku_board_size.dart';
import 'package:bardak/features/games/sudoku/sudoku_settings/domain/entities/sudoku_difficulty.dart';
import 'package:bardak/features/games/sudoku/sudoku_settings/domain/entities/sudoku_settings_entity.dart';
import 'package:bardak/features/games/sudoku/sudoku_settings/domain/usecases/get_sudoku_settings_usecase.dart';
import 'package:bardak/features/games/sudoku/sudoku_settings/domain/usecases/update_sudoku_board_size_usecase.dart';
import 'package:bardak/features/games/sudoku/sudoku_settings/domain/usecases/update_sudoku_difficulty_usecase.dart';
import 'package:bardak/features/games/sudoku/sudoku_settings/presentation/bloc/sudoku_settings_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockGenerateSudokuBoardUseCase extends Mock
    implements GenerateSudokuBoardUseCase {}

class _MockUpdateSavedSudokuGameUseCase extends Mock
    implements UpdateSavedSudokuGameUseCase {}

class _MockClearSavedSudokuGameUseCase extends Mock
    implements ClearSavedSudokuGameUseCase {}

class _MockRecordSudokuWinUseCase extends Mock
    implements RecordSudokuWinUseCase {}

class _MockGetSudokuSettingsUseCase extends Mock
    implements GetSudokuSettingsUseCase {}

class _MockUpdateSudokuDifficultyUseCase extends Mock
    implements UpdateSudokuDifficultyUseCase {}

class _MockUpdateSudokuBoardSizeUseCase extends Mock
    implements UpdateSudokuBoardSizeUseCase {}

class _MockGetSudokuStatsUseCase extends Mock
    implements GetSudokuStatsUseCase {}

class _MockHasSavedSudokuGameUseCase extends Mock
    implements HasSavedSudokuGameUseCase {}

void main() {
  late SudokuBoardEntity board;
  late int emptyIndex;

  setUpAll(() {
    registerFallbackValue(
      SudokuSavedGameEntity(
        board: SudokuBoardEntity.generate(
          boxSize: 3,
          givensCount: 36,
          random: Random(0),
        ),
        boardSize: SudokuBoardSize.standard,
        difficulty: SudokuDifficulty.medium,
        mistakes: 0,
        elapsedSeconds: 0,
      ),
    );
    registerFallbackValue(
      const RecordSudokuWinParams(statsKey: 'medium', timeSeconds: 0),
    );
  });

  setUp(() {
    board = SudokuBoardEntity.generate(
      boxSize: 3,
      givensCount: 36,
      random: Random(1),
    );
    emptyIndex = board.given.indexOf(false);
  });

  Future<SudokuBloc> pumpScreen(WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final updateSavedUseCase = _MockUpdateSavedSudokuGameUseCase();
    final clearSavedUseCase = _MockClearSavedSudokuGameUseCase();
    final recordWinUseCase = _MockRecordSudokuWinUseCase();
    final getStatsUseCase = _MockGetSudokuStatsUseCase();
    when(() => updateSavedUseCase(any())).thenAnswer((_) async => true);
    when(() => clearSavedUseCase()).thenAnswer((_) async => true);
    when(getStatsUseCase.call).thenReturn(const SudokuStatsEntity());
    when(() => recordWinUseCase(any())).thenAnswer(
      (_) async => const SudokuWinRecordEntity(
        stats: SudokuDifficultyStats(gamesWon: 1, bestTimeSeconds: 1),
        isNewBestTime: true,
      ),
    );

    final bloc = SudokuBloc(
      boardSize: SudokuBoardSize.standard,
      difficulty: SudokuDifficulty.medium,
      generateSudokuBoardUseCase: _MockGenerateSudokuBoardUseCase(),
      updateSavedSudokuGameUseCase: updateSavedUseCase,
      clearSavedSudokuGameUseCase: clearSavedUseCase,
      recordSudokuWinUseCase: recordWinUseCase,
      getSudokuStatsUseCase: getStatsUseCase,
      board: board,
    );
    addTearDown(bloc.close);

    final getSettingsUseCase = _MockGetSudokuSettingsUseCase();
    final hasSavedUseCase = _MockHasSavedSudokuGameUseCase();
    when(() => getSettingsUseCase()).thenReturn(const SudokuSettingsEntity());
    when(() => hasSavedUseCase()).thenReturn(false);
    final settingsBloc = SudokuSettingsBloc(
      getSudokuSettingsUseCase: getSettingsUseCase,
      updateSudokuBoardSizeUseCase: _MockUpdateSudokuBoardSizeUseCase(),
      updateSudokuDifficultyUseCase: _MockUpdateSudokuDifficultyUseCase(),
      hasSavedSudokuGameUseCase: hasSavedUseCase,
    );
    addTearDown(settingsBloc.close);

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
          home: MultiBlocProvider(
            providers: [
              BlocProvider.value(value: bloc),
              BlocProvider.value(value: settingsBloc),
            ],
            child: const SudokuScreen(),
          ),
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

  testWidgets('tapping outside the cells clears the selection', (
    tester,
  ) async {
    final bloc = await pumpScreen(tester);

    await tester.tap(find.byKey(ValueKey(emptyIndex)));
    await tester.pump();
    expect(bloc.state.selectedIndex, emptyIndex);

    // The difficulty label has no tap handler, so the tap falls through to
    // the screen's deselect gesture.
    await tester.tap(find.text('Medium'));
    await tester.pump();
    expect(bloc.state.selectedIndex, isNull);

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

  testWidgets('a wrong entry costs a heart', (tester) async {
    await pumpScreen(tester);

    expect(find.byIcon(Icons.favorite_rounded), findsNWidgets(3));

    final wrong = board.solution[emptyIndex] == 1 ? 2 : 1;
    await tester.tap(find.byKey(ValueKey(emptyIndex)));
    await tester.pump();
    await tester.tap(find.byKey(ValueKey('sudoku_digit_$wrong')));
    await tester.pump();
    // Let the shake animation finish.
    await tester.pump(const Duration(seconds: 1));

    expect(find.byIcon(Icons.favorite_rounded), findsNWidgets(2));
    expect(find.byIcon(Icons.heart_broken_rounded), findsOneWidget);

    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('digit keys show how many are left to place', (tester) async {
    final bloc = await pumpScreen(tester);

    final digit = board.solution[emptyIndex];
    final before = bloc.state.remainingOf(digit);

    await tester.tap(find.byKey(ValueKey(emptyIndex)));
    await tester.pump();
    await tester.tap(find.byKey(ValueKey('sudoku_digit_$digit')));
    await tester.pump();

    final counter = find.descendant(
      of: find.byKey(ValueKey('sudoku_digit_$digit')),
      matching: find.text('${before - 1}'),
    );
    expect(counter, findsOneWidget);

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
