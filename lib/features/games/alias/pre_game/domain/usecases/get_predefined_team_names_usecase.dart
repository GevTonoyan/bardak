import 'package:bardak/core/localizations/app_locale.dart';
import 'package:bardak/features/games/alias/pre_game/domain/repositories/team_names_repository.dart';

/// Returns all predefined team names grouped by [AppLocale] from the local data source.
class GetPredefinedTeamNamesUseCase {
  const GetPredefinedTeamNamesUseCase(this.repository);

  final TeamNamesRepository repository;

  Map<AppLocale, Set<String>> call() {
    return repository.getPredefinedTeamNames();
  }
}
