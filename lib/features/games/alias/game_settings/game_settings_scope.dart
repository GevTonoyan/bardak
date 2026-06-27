import 'package:bardak/features/games/alias/game_settings/data/data_sources/game_settings_local_data_source.dart';
import 'package:bardak/features/games/alias/game_settings/data/repositories/game_settings_repository_impl.dart';
import 'package:bardak/features/games/alias/game_settings/domain/repositories/game_settings_repository.dart';
import 'package:bardak/features/games/alias/game_settings/domain/usecases/get_game_settings_usecase.dart';
import 'package:bardak/features/games/alias/game_settings/domain/usecases/update_allow_skipping_usecase.dart';
import 'package:bardak/features/games/alias/game_settings/domain/usecases/update_points_to_win_usecase.dart';
import 'package:bardak/features/games/alias/game_settings/domain/usecases/update_round_duration_usecase.dart';
import 'package:bardak/core/di/di.dart';

void injectGameSettingsScope() {
  if (sl.isRegistered<GameSettingsRepository>()) return;

  sl
    ..registerLazySingleton<GetGameSettingsUseCase>(
      () => GetGameSettingsUseCase(sl()),
    )
    ..registerLazySingleton<UpdateRoundDurationUseCase>(
      () => UpdateRoundDurationUseCase(sl()),
    )
    ..registerLazySingleton<UpdatePointsToWinUseCase>(
      () => UpdatePointsToWinUseCase(sl()),
    )
    ..registerLazySingleton<UpdateAllowSkippingUseCase>(
      () => UpdateAllowSkippingUseCase(sl()),
    )
    ..registerLazySingleton<GameSettingsRepository>(
      () => GameSettingsRepositoryImpl(dataSource: sl()),
    )
    ..registerLazySingleton<GameSettingsLocalDataSource>(
      () => GameSettingsLocalDataSourceImpl(preferences: sl()),
    );
}
