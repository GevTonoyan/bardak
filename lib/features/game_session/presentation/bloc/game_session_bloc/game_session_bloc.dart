import 'package:boardify/features/game_session/domain/entities/game_session_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'game_session_event.dart';

part 'game_session_state.dart';

class GameSessionBloc extends Bloc<GameSessionEvent, GameSessionState> {
  GameSessionBloc({required GameSessionEntity initialGameState})
    : super(GameSessionState(initialGameState));
}
