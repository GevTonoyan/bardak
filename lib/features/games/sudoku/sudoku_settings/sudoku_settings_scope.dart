import 'package:bardak/core/di/di.dart';
import 'package:bardak/features/games/sudoku/sudoku_settings/data/data_sources/sudoku_settings_local_data_source.dart';
import 'package:bardak/features/games/sudoku/sudoku_settings/data/repositories/sudoku_settings_repository_impl.dart';
import 'package:bardak/features/games/sudoku/sudoku_settings/domain/repositories/sudoku_settings_repository.dart';
import 'package:bardak/features/games/sudoku/sudoku_settings/domain/usecases/get_sudoku_settings_usecase.dart';
import 'package:bardak/features/games/sudoku/sudoku_settings/domain/usecases/update_sudoku_board_size_usecase.dart';
import 'package:bardak/features/games/sudoku/sudoku_settings/domain/usecases/update_sudoku_difficulty_usecase.dart';

void injectSudokuSettingsScope() {
  if (sl.isRegistered<SudokuSettingsRepository>()) return;

  sl
    ..registerLazySingleton<GetSudokuSettingsUseCase>(
      () => GetSudokuSettingsUseCase(sl()),
    )
    ..registerLazySingleton<UpdateSudokuBoardSizeUseCase>(
      () => UpdateSudokuBoardSizeUseCase(sl()),
    )
    ..registerLazySingleton<UpdateSudokuDifficultyUseCase>(
      () => UpdateSudokuDifficultyUseCase(sl()),
    )
    ..registerLazySingleton<SudokuSettingsRepository>(
      () => SudokuSettingsRepositoryImpl(dataSource: sl()),
    )
    ..registerLazySingleton<SudokuSettingsLocalDataSource>(
      () => SudokuSettingsLocalDataSourceImpl(preferences: sl()),
    );
}
