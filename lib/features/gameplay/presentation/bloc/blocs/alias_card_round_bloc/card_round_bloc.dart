import 'package:flutter_bloc/flutter_bloc.dart';

part 'card_round_event.dart';

part 'card_round_state.dart';

class AliasCardRoundBloc
    extends Bloc<AliasCardRoundEvent, AliasCardRoundState> {
  AliasCardRoundBloc() : super(const AliasCardRoundLoaded());
}
