import 'package:bardak/game_settings/data/data_sources/game_settings_local_data_source.dart';
import 'package:bardak/game_settings/data/repositories/game_settings_repository_impl.dart';
import 'package:bardak/game_settings/domain/repositories/game_settings_repository.dart';
import 'package:bardak/game_settings/domain/usecases/get_game_settings_usecase.dart';
import 'package:bardak/game_settings/domain/usecases/update_game_settings_usecase.dart';
import 'package:bardak/utils/dependency_injection/di.dart';

void injectGameSettingsScope() {
  if (sl.isRegistered<GameSettingsRepository>()) return;

  sl
    ..registerLazySingleton<GetGameSettingsUseCase>(
      () => GetGameSettingsUseCase(sl()),
    )
    ..registerLazySingleton<UpdateGameSettingsUseCase>(
      () => UpdateGameSettingsUseCase(sl()),
    )
    ..registerLazySingleton<GameSettingsRepository>(
      () => GameSettingsRepositoryImpl(dataSource: sl()),
    )
    ..registerLazySingleton<GameSettingsLocalDataSource>(
      () => GameSettingsLocalDataSourceImpl(preferences: sl()),
    );
}
