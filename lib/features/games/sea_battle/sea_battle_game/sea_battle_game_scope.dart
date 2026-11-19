import 'package:bardak/core/di/di.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/usecases/choose_bot_shot_usecase.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/usecases/start_sea_battle_usecase.dart';

void injectSeaBattleGameScope() {
  if (sl.isRegistered<StartSeaBattleUseCase>()) return;

  sl
    ..registerLazySingleton<StartSeaBattleUseCase>(StartSeaBattleUseCase.new)
    ..registerLazySingleton<ChooseBotShotUseCase>(ChooseBotShotUseCase.new);
}
