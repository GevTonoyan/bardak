import 'package:bardak/core/di/di.dart';
import 'package:bardak/features/games/spy/spy_settings/data/data_sources/spy_settings_local_data_source.dart';
import 'package:bardak/features/games/spy/spy_settings/data/repositories/spy_settings_repository_impl.dart';
import 'package:bardak/features/games/spy/spy_settings/domain/repositories/spy_settings_repository.dart';
import 'package:bardak/features/games/spy/spy_settings/domain/usecases/get_spy_settings_usecase.dart';
import 'package:bardak/features/games/spy/spy_settings/domain/usecases/update_player_count_usecase.dart';
import 'package:bardak/features/games/spy/spy_settings/domain/usecases/update_spy_count_usecase.dart';
import 'package:bardak/features/games/spy/spy_settings/domain/usecases/update_spy_round_duration_usecase.dart';

void injectSpySettingsScope() {
  if (sl.isRegistered<SpySettingsRepository>()) return;

  sl
    ..registerLazySingleton<GetSpySettingsUseCase>(
      () => GetSpySettingsUseCase(sl()),
    )
    ..registerLazySingleton<UpdatePlayerCountUseCase>(
      () => UpdatePlayerCountUseCase(sl()),
    )
    ..registerLazySingleton<UpdateSpyCountUseCase>(
      () => UpdateSpyCountUseCase(sl()),
    )
    ..registerLazySingleton<UpdateSpyRoundDurationUseCase>(
      () => UpdateSpyRoundDurationUseCase(sl()),
    )
    ..registerLazySingleton<SpySettingsRepository>(
      () => SpySettingsRepositoryImpl(dataSource: sl()),
    )
    ..registerLazySingleton<SpySettingsLocalDataSource>(
      () => SpySettingsLocalDataSourceImpl(preferences: sl()),
    );
}
