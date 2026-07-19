import 'package:bardak/core/localizations/app_locale.dart';
import 'package:bardak/features/games/alias/team_setup/domain/repositories/team_setup_repository.dart';
import 'package:bardak/features/games/alias/team_setup/domain/usecases/get_predefined_team_names_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockTeamSetupRepository extends Mock implements TeamSetupRepository {}

void main() {
  test('returns the predefined names grouped by locale', () {
    final repository = _MockTeamSetupRepository();
    final names = {
      AppLocale.en: {'Reds', 'Blues'},
      AppLocale.ru: {'Красные'},
    };
    when(repository.getPredefinedTeamNames).thenReturn(names);

    expect(GetPredefinedTeamNamesUseCase(repository)(), names);
  });
}
