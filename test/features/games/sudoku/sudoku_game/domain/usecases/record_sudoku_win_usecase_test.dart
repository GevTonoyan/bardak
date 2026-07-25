import 'package:bardak/features/games/sudoku/sudoku_game/domain/entities/sudoku_stats_entity.dart';
import 'package:bardak/features/games/sudoku/sudoku_game/domain/repositories/sudoku_game_repository.dart';
import 'package:bardak/features/games/sudoku/sudoku_game/domain/usecases/record_sudoku_win_usecase.dart';
import 'package:bardak/features/games/sudoku/sudoku_settings/domain/entities/sudoku_difficulty.dart';
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
      const RecordSudokuWinParams(
        difficulty: SudokuDifficulty.hard,
        timeSeconds: 300,
      ),
    );

    expect(record.isNewBestTime, isTrue);
    expect(record.stats.gamesWon, 1);
    expect(record.stats.bestTimeSeconds, 300);
  });

  test('a slower win keeps the old best time', () async {
    when(() => repository.getStats()).thenReturn(
      const SudokuStatsEntity(
        byDifficulty: {
          SudokuDifficulty.hard: SudokuDifficultyStats(
            gamesWon: 3,
            bestTimeSeconds: 200,
          ),
        },
      ),
    );

    final record = await useCase(
      const RecordSudokuWinParams(
        difficulty: SudokuDifficulty.hard,
        timeSeconds: 300,
      ),
    );

    expect(record.isNewBestTime, isFalse);
    expect(record.stats.gamesWon, 4);
    expect(record.stats.bestTimeSeconds, 200);
  });

  test('stats of other difficulties are untouched', () async {
    const easyStats = SudokuDifficultyStats(gamesWon: 7, bestTimeSeconds: 150);
    when(() => repository.getStats()).thenReturn(
      const SudokuStatsEntity(
        byDifficulty: {SudokuDifficulty.easy: easyStats},
      ),
    );

    await useCase(
      const RecordSudokuWinParams(
        difficulty: SudokuDifficulty.hard,
        timeSeconds: 300,
      ),
    );

    final saved =
        verify(() => repository.updateStats(captureAny())).captured.last
            as SudokuStatsEntity;
    expect(saved.statsFor(SudokuDifficulty.easy), easyStats);
    expect(saved.statsFor(SudokuDifficulty.hard).gamesWon, 1);
  });
}
