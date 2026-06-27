import 'package:bardak/features/games/alias/pre_game/data/data_sources/team_names_local_data_source.dart';
import 'package:bardak/features/games/alias/pre_game/data/repositories/team_names_repository_impl.dart';
import 'package:bardak/features/games/alias/pre_game/domain/repositories/team_names_repository.dart';
import 'package:bardak/features/games/alias/pre_game/domain/usecases/get_predefined_team_names_usecase.dart';
import 'package:get_it/get_it.dart';

final GetIt sl = GetIt.instance;

void injectPreGameScope() {
  if (sl.isRegistered<TeamNamesRepository>()) return;

  sl
    ..registerLazySingleton<TeamNamesLocalDataSource>(
      () => const TeamNamesLocalDataSourceImpl(),
    )
    ..registerLazySingleton<TeamNamesRepository>(
      () => TeamNamesRepositoryImpl(localDataSource: sl()),
    )
    ..registerLazySingleton<GetPredefinedTeamNamesUseCase>(
      () => GetPredefinedTeamNamesUseCase(sl()),
    );
}
