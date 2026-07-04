import 'package:bardak/core/di/di.dart';
import 'package:bardak/features/games/alias/team_setup/data/data_sources/team_setup_local_data_source.dart';
import 'package:bardak/features/games/alias/team_setup/data/repositories/team_setup_repository_impl.dart';
import 'package:bardak/features/games/alias/team_setup/domain/repositories/team_setup_repository.dart';
import 'package:bardak/features/games/alias/team_setup/domain/usecases/get_predefined_team_names_usecase.dart';

void injectTeamSetupScope() {
  if (sl.isRegistered<TeamSetupRepository>()) return;

  sl
    ..registerLazySingleton<GetPredefinedTeamNamesUseCase>(
      () => GetPredefinedTeamNamesUseCase(sl()),
    )
    ..registerLazySingleton<TeamSetupRepository>(
      () => TeamSetupRepositoryImpl(localDataSource: sl()),
    )
    ..registerLazySingleton<TeamSetupLocalDataSource>(
      () => const TeamSetupLocalDataSourceImpl(),
    );
}
