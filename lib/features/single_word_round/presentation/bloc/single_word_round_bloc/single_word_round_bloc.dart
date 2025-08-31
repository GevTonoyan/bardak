import 'package:flutter_bloc/flutter_bloc.dart';

part 'single_word_round_event.dart';

part 'single_word_round_state.dart';

class SingleWordRoundBloc
    extends Bloc<SingleWordRoundEvent, SingleWordRoundState> {
  SingleWordRoundBloc({
    required List<String> words,
    required int roundDuration,
    required bool penaltyForSkipping,
    required bool allowSkipping,
  }) : super(
         SingleWordRoundState.initial(
           words: words,
           roundDuration: roundDuration,
           allowSkipping: allowSkipping,
           penaltyForSkipping: penaltyForSkipping,
         ),
       );
}
