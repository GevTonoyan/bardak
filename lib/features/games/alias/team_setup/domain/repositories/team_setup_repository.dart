import 'package:bardak/core/localizations/app_locale.dart';

/// Abstract repository for the team-setup step (predefined name suggestions).
abstract interface class TeamSetupRepository {
  /// Returns all predefined team names grouped by [AppLocale].
  Map<AppLocale, Set<String>> getPredefinedTeamNames();
}
