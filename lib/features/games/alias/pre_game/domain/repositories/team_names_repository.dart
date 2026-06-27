import 'package:bardak/core/localizations/common/supported_locales.dart';

/// Abstract repository for team-name related operations.
abstract interface class TeamNamesRepository {
  /// Returns all predefined team names grouped by [AppLocales].
  Map<AppLocales, Set<String>> getPredefinedTeamNames();
}
