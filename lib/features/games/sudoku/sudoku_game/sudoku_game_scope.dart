import 'package:bardak/core/di/di.dart';
import 'package:bardak/features/games/sudoku/sudoku_game/data/data_sources/sudoku_game_local_data_source.dart';
import 'package:bardak/features/games/sudoku/sudoku_game/data/repositories/sudoku_game_repository_impl.dart';
import 'package:bardak/features/games/sudoku/sudoku_game/domain/repositories/sudoku_game_repository.dart';
import 'package:bardak/features/games/sudoku/sudoku_game/domain/usecases/clear_saved_sudoku_game_usecase.dart';
import 'package:bardak/features/games/sudoku/sudoku_game/domain/usecases/generate_sudoku_board_usecase.dart';
import 'package:bardak/features/games/sudoku/sudoku_game/domain/usecases/get_saved_sudoku_game_usecase.dart';
import 'package:bardak/features/games/sudoku/sudoku_game/domain/usecases/get_sudoku_stats_usecase.dart';
import 'package:bardak/features/games/sudoku/sudoku_game/domain/usecases/has_saved_sudoku_game_usecase.dart';
import 'package:bardak/features/games/sudoku/sudoku_game/domain/usecases/record_sudoku_win_usecase.dart';
import 'package:bardak/features/games/sudoku/sudoku_game/domain/usecases/update_saved_sudoku_game_usecase.dart';

void injectSudokuGameScope() {
  if (sl.isRegistered<SudokuGameRepository>()) return;

  sl
    ..registerLazySingleton<GenerateSudokuBoardUseCase>(
      GenerateSudokuBoardUseCase.new,
    )
    ..registerLazySingleton<GetSavedSudokuGameUseCase>(
      () => GetSavedSudokuGameUseCase(sl()),
    )
    ..registerLazySingleton<GetSudokuStatsUseCase>(
      () => GetSudokuStatsUseCase(sl()),
    )
    ..registerLazySingleton<HasSavedSudokuGameUseCase>(
      () => HasSavedSudokuGameUseCase(sl()),
    )
    ..registerLazySingleton<UpdateSavedSudokuGameUseCase>(
      () => UpdateSavedSudokuGameUseCase(sl()),
    )
    ..registerLazySingleton<ClearSavedSudokuGameUseCase>(
      () => ClearSavedSudokuGameUseCase(sl()),
    )
    ..registerLazySingleton<RecordSudokuWinUseCase>(
      () => RecordSudokuWinUseCase(sl()),
    )
    ..registerLazySingleton<SudokuGameRepository>(
      () => SudokuGameRepositoryImpl(dataSource: sl()),
    )
    ..registerLazySingleton<SudokuGameLocalDataSource>(
      () => SudokuGameLocalDataSourceImpl(preferences: sl()),
    );
}
