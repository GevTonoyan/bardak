import 'package:bardak/core/di/di.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_settings/data/data_sources/sea_battle_settings_local_data_source.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_settings/data/repositories/sea_battle_settings_repository_impl.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_settings/domain/repositories/sea_battle_settings_repository.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_settings/domain/usecases/get_sea_battle_settings_usecase.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_settings/domain/usecases/update_sea_battle_bot_difficulty_usecase.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_settings/domain/usecases/update_sea_battle_mode_usecase.dart';

void injectSeaBattleSettingsScope() {
  if (sl.isRegistered<SeaBattleSettingsRepository>()) return;

  sl
    ..registerLazySingleton<GetSeaBattleSettingsUseCase>(
      () => GetSeaBattleSettingsUseCase(sl()),
    )
    ..registerLazySingleton<UpdateSeaBattleModeUseCase>(
      () => UpdateSeaBattleModeUseCase(sl()),
    )
    ..registerLazySingleton<UpdateSeaBattleBotDifficultyUseCase>(
      () => UpdateSeaBattleBotDifficultyUseCase(sl()),
    )
    ..registerLazySingleton<SeaBattleSettingsRepository>(
      () => SeaBattleSettingsRepositoryImpl(dataSource: sl()),
    )
    ..registerLazySingleton<SeaBattleSettingsLocalDataSource>(
      () => SeaBattleSettingsLocalDataSourceImpl(preferences: sl()),
    );
}
