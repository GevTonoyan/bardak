import 'package:bardak/core/localizations/app_locale.dart';

/// Abstract repository for team-name related operations.
abstract interface class TeamNamesRepository {
  /// Returns all predefined team names grouped by [AppLocale].
  Map<AppLocale, Set<String>> getPredefinedTeamNames();
}
