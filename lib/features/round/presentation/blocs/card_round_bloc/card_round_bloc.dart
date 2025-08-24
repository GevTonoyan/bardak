import 'package:flutter_bloc/flutter_bloc.dart';

part 'card_round_event.dart';

part 'card_round_state.dart';

class CardRoundBloc
    extends Bloc<CardRoundEvent, CardRoundState> {
  CardRoundBloc() : super(const CardRoundLoaded());
}
