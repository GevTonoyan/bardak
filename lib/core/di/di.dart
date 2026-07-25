import 'package:bardak/core/logging/app_logger.dart';
import 'package:bardak/core/logging/console_logger.dart';
import 'package:bardak/features/app_review/app_review_scope.dart';
import 'package:bardak/features/games/alias/game_settings/game_settings_scope.dart';
import 'package:bardak/features/games/alias/team_setup/team_setup_scope.dart';
import 'package:bardak/features/games/alias/word_packs/word_packs_scope.dart';
import 'package:bardak/features/games/spy/spy_packs/spy_packs_scope.dart';
import 'package:bardak/features/games/spy/spy_settings/spy_settings_scope.dart';
import 'package:bardak/features/games/sudoku/sudoku_game/sudoku_game_scope.dart';
import 'package:bardak/features/games/sudoku/sudoku_settings/sudoku_settings_scope.dart';
import 'package:bardak/features/settings/data/data_sources/settings_local_data_source.dart';
import 'package:bardak/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:bardak/features/settings/domain/repositories/settings_repository.dart';
import 'package:bardak/features/settings/domain/usecases/get_app_settings_usecase.dart';
import 'package:bardak/features/settings/domain/usecases/update_color_scheme_usecase.dart';
import 'package:bardak/features/settings/domain/usecases/update_locale_usecase.dart';
import 'package:bardak/features/settings/domain/usecases/update_sound_enabled_usecase.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GetIt sl = GetIt.instance;

/// Global access to the app logger. Backed by GetIt, so tests can swap the
/// implementation by registering a fake [AppLogger].
AppLogger get logger => sl<AppLogger>();

Future<void> injectDependencies() async {
  final prefs = await SharedPreferences.getInstance();
  sl
    ..registerLazySingleton<AppLogger>(ConsoleLogger.new)
    ..registerLazySingleton<SharedPreferences>(() => prefs)
    ..registerLazySingleton<GetAppSettingsUseCase>(
      () => GetAppSettingsUseCase(sl()),
    )
    ..registerLazySingleton<UpdateLocaleUseCase>(
      () => UpdateLocaleUseCase(sl()),
    )
    ..registerLazySingleton<UpdateColorSchemeUseCase>(
      () => UpdateColorSchemeUseCase(sl()),
    )
    ..registerLazySingleton<UpdateSoundEnabledUseCase>(
      () => UpdateSoundEnabledUseCase(sl()),
    )
    ..registerLazySingleton<SettingsRepository>(
      () => SettingsRepositoryImpl(dataSource: sl()),
    )
    ..registerLazySingleton<SettingsLocalDataSource>(
      () => SettingsLocalDataSourceImpl(preferences: sl()),
    );

  injectAppReviewScope();
  injectWordPacksScope();
  injectTeamSetupScope();
  injectGameSettingsScope();
  injectSpySettingsScope();
  injectSpyPacksScope();
  injectSudokuSettingsScope();
  injectSudokuGameScope();
}
