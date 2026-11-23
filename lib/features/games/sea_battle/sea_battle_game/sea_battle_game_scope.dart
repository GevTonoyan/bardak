import 'package:bardak/core/di/di.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/data/data_sources/sea_battle_opponent_local_data_source.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/data/repositories/sea_battle_opponent_repository_impl.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/repositories/sea_battle_opponent_repository.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/usecases/get_random_shot_usecase.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/usecases/start_sea_battle_usecase.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_settings/domain/entities/sea_battle_bot_difficulty.dart';

void injectSeaBattleGameScope() {
  if (sl.isRegistered<StartSeaBattleUseCase>()) return;

  sl
    ..registerLazySingleton<StartSeaBattleUseCase>(StartSeaBattleUseCase.new)
    ..registerLazySingleton<GetRandomShotUseCase>(GetRandomShotUseCase.new)
    // A new opponent for every battle: the bot keeps that battle's fleet.
    ..registerFactoryParam<
      SeaBattleOpponentRepository,
      SeaBattleBotDifficulty,
      void
    >(
      (difficulty, _) => SeaBattleOpponentRepositoryImpl(
        localDataSource: SeaBattleOpponentLocalDataSourceImpl(
          difficulty: difficulty,
        ),
      ),
    );
}
