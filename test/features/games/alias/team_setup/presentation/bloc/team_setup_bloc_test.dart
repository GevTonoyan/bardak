import 'package:bardak/core/localizations/app_locale.dart';
import 'package:bardak/features/games/alias/team_setup/domain/usecases/get_predefined_team_names_usecase.dart';
import 'package:bardak/features/games/alias/team_setup/presentation/bloc/team_setup_bloc.dart';
import 'package:bardak/features/games/alias/team_setup/presentation/bloc/team_setup_event.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockGetPredefinedTeamNames extends Mock
    implements GetPredefinedTeamNamesUseCase {}

void main() {
  late _MockGetPredefinedTeamNames getPredefinedTeamNames;

  setUp(() {
    getPredefinedTeamNames = _MockGetPredefinedTeamNames();
    when(getPredefinedTeamNames.call).thenReturn({
      AppLocale.en: {'Reds', 'Blues'},
    });
  });

  test('starts with the predefined names and no teams', () {
    final bloc = TeamSetupBloc(
      getPredefinedTeamNamesUseCase: getPredefinedTeamNames,
    );
    addTearDown(bloc.close);

    expect(bloc.state.teamNames, isEmpty);
    expect(bloc.state.predefinedTeamNames[AppLocale.en], {'Reds', 'Blues'});
  });

  test('SetTeamNames stores the chosen names', () async {
    final bloc = TeamSetupBloc(
      getPredefinedTeamNamesUseCase: getPredefinedTeamNames,
    )..add(const SetTeamNames(['Alpha', 'Beta']));
    addTearDown(bloc.close);
    await pumpEventQueue();

    expect(bloc.state.teamNames, ['Alpha', 'Beta']);
  });
}
