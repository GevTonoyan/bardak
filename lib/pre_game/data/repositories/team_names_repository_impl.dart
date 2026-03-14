import 'package:alias_pro/localizations/common/supported_locales.dart';
import 'package:alias_pro/pre_game/data/data_sources/team_names_local_data_source.dart';
import 'package:alias_pro/pre_game/domain/repositories/team_names_repository.dart';

/// Implementation of [TeamNamesRepository] that delegates to the local data source.
class TeamNamesRepositoryImpl implements TeamNamesRepository {
  const TeamNamesRepositoryImpl({required this.localDataSource});

  final TeamNamesLocalDataSource localDataSource;

  @override
  Map<AppLocales, Set<String>> getPredefinedTeamNames() {
    return localDataSource.getPredefinedTeamNames();
  }
}
