import 'package:bardak/features/games/sudoku/sudoku_game/domain/entities/sudoku_stats_entity.dart';
import 'package:bardak/features/games/sudoku/sudoku_game/domain/repositories/sudoku_game_repository.dart';
import 'package:bardak/features/games/sudoku/sudoku_game/domain/usecases/record_sudoku_win_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockSudokuGameRepository extends Mock implements SudokuGameRepository {}

void main() {
  late _MockSudokuGameRepository repository;
  late RecordSudokuWinUseCase useCase;

  setUpAll(() {
    registerFallbackValue(const SudokuStatsEntity());
  });

  setUp(() {
    repository = _MockSudokuGameRepository();
    useCase = RecordSudokuWinUseCase(repository);
    when(() => repository.updateStats(any())).thenAnswer((_) async => true);
  });

  test('the first win sets the best time', () async {
    when(() => repository.getStats()).thenReturn(const SudokuStatsEntity());

    final record = await useCase(
      const RecordSudokuWinParams(statsKey: 'hard', timeSeconds: 300),
    );

    expect(record.isNewBestTime, isTrue);
    expect(record.stats.gamesWon, 1);
    expect(record.stats.bestTimeSeconds, 300);
  });

  test('a slower win keeps the old best time', () async {
    when(() => repository.getStats()).thenReturn(
      const SudokuStatsEntity(
        byKey: {
          'hard': SudokuDifficultyStats(gamesWon: 3, bestTimeSeconds: 200),
        },
      ),
    );

    final record = await useCase(
      const RecordSudokuWinParams(statsKey: 'hard', timeSeconds: 300),
    );

    expect(record.isNewBestTime, isFalse);
    expect(record.stats.gamesWon, 4);
    expect(record.stats.bestTimeSeconds, 200);
  });

  test('stats of other modes are untouched', () async {
    const easyStats = SudokuDifficultyStats(gamesWon: 7, bestTimeSeconds: 150);
    when(() => repository.getStats()).thenReturn(
      const SudokuStatsEntity(byKey: {'easy': easyStats}),
    );

    await useCase(
      const RecordSudokuWinParams(statsKey: 'hard', timeSeconds: 300),
    );

    final saved =
        verify(() => repository.updateStats(captureAny())).captured.last
            as SudokuStatsEntity;
    expect(saved.statsFor('easy'), easyStats);
    expect(saved.statsFor('hard').gamesWon, 1);
  });

  test('the 4×4 mode records under its own key', () async {
    const hardStats = SudokuDifficultyStats(gamesWon: 2, bestTimeSeconds: 90);
    when(() => repository.getStats()).thenReturn(
      const SudokuStatsEntity(byKey: {'hard': hardStats}),
    );

    await useCase(
      const RecordSudokuWinParams(statsKey: 'small', timeSeconds: 30),
    );

    final saved =
        verify(() => repository.updateStats(captureAny())).captured.last
            as SudokuStatsEntity;
    // The 4×4 record is separate; the classic 'hard' bucket is untouched.
    expect(saved.statsFor('small').bestTimeSeconds, 30);
    expect(saved.statsFor('hard'), hardStats);
  });
}
