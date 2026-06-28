import 'package:bardak/core/localizations/app_locale.dart';
import 'package:bardak/features/games/alias/pre_game/data/data_sources/team_names_local_data_source.dart';
import 'package:bardak/features/games/alias/pre_game/domain/repositories/team_names_repository.dart';

/// Implementation of [TeamNamesRepository] that delegates to the local data source.
class TeamNamesRepositoryImpl implements TeamNamesRepository {
  const TeamNamesRepositoryImpl({required this.localDataSource});

  final TeamNamesLocalDataSource localDataSource;

  @override
  Map<AppLocale, Set<String>> getPredefinedTeamNames() {
    return localDataSource.getPredefinedTeamNames();
  }
}
