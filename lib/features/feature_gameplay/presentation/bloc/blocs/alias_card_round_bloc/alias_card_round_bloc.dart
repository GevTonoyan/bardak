import 'package:flutter_bloc/flutter_bloc.dart';

part 'alias_card_round_event.dart';

part 'alias_card_round_state.dart';

class AliasCardRoundBloc
    extends Bloc<AliasCardRoundEvent, AliasCardRoundState> {
  AliasCardRoundBloc() : super(const AliasCardRoundLoaded());
}
