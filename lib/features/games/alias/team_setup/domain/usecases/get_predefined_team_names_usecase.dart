import 'package:bardak/core/localizations/app_locale.dart';
import 'package:bardak/features/games/alias/team_setup/domain/repositories/team_setup_repository.dart';

/// Returns all predefined team names grouped by [AppLocale].
class GetPredefinedTeamNamesUseCase {
  const GetPredefinedTeamNamesUseCase(this._teamSetupRepository);

  final TeamSetupRepository _teamSetupRepository;

  Map<AppLocale, Set<String>> call() {
    return _teamSetupRepository.getPredefinedTeamNames();
  }
}
