import 'package:bardak/core/di/di.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/usecases/generate_random_fleet_usecase.dart';

void injectSeaBattleGameScope() {
  if (sl.isRegistered<GenerateRandomFleetUseCase>()) return;

  sl.registerLazySingleton<GenerateRandomFleetUseCase>(
    GenerateRandomFleetUseCase.new,
  );
}
