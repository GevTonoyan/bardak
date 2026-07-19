import 'package:bardak/features/games/spy/spy_session/domain/entities/spy_session_entity.dart';
import 'package:bardak/features/games/spy/spy_session/presentation/bloc/spy_session_event.dart';
import 'package:bardak/features/games/spy/spy_session/presentation/bloc/spy_session_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SpySessionBloc extends Bloc<SpySessionEvent, SpySessionState> {
  SpySessionBloc({required SpySessionEntity initialSession})
    : super(SpySessionState(session: initialSession)) {
    on<FinishPlayerReveal>(_onFinishPlayerReveal);
  }

  void _onFinishPlayerReveal(
    FinishPlayerReveal event,
    Emitter<SpySessionState> emit,
  ) {
    final session = state.session;
    if (session.isRevealCompleted) return;

    emit(
      SpySessionState(
        session: session.copyWith(
          currentRevealIndex: session.currentRevealIndex + 1,
        ),
      ),
    );
  }
}
