import 'package:bardak/core/localizations/app_locale.dart';
import 'package:bardak/features/games/alias/team_setup/data/data_sources/team_setup_local_data_source.dart';
import 'package:bardak/features/games/alias/team_setup/domain/repositories/team_setup_repository.dart';

/// Implementation of [TeamSetupRepository] that delegates to the data source.
class TeamSetupRepositoryImpl implements TeamSetupRepository {
  const TeamSetupRepositoryImpl({required this._localDataSource});

  final TeamSetupLocalDataSource _localDataSource;

  @override
  Map<AppLocale, Set<String>> getPredefinedTeamNames() {
    return _localDataSource.getPredefinedTeamNames();
  }
}
