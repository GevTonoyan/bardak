import 'package:bardak/core/localizations/common/supported_locales.dart';
import 'package:bardak/features/games/alias/pre_game/domain/repositories/team_names_repository.dart';

/// Returns all predefined team names grouped by [AppLocales] from the local data source.
class GetPredefinedTeamNamesUseCase {
  const GetPredefinedTeamNamesUseCase(this.repository);

  final TeamNamesRepository repository;

  Map<AppLocales, Set<String>> call() {
    return repository.getPredefinedTeamNames();
  }
}
