import 'dart:math';

import 'package:bardak/features/games/spy/spy_packs/domain/entities/spy_pack_entity.dart';
import 'package:bardak/features/games/spy/spy_session/domain/entities/spy_session_entity.dart';
import 'package:bardak/features/games/spy/spy_session/presentation/bloc/spy_session_bloc.dart';
import 'package:bardak/features/games/spy/spy_session/presentation/bloc/spy_session_event.dart';
import 'package:bardak/features/games/spy/spy_session/presentation/bloc/spy_session_state.dart';
import 'package:flutter_test/flutter_test.dart';

SpySessionEntity _session({int playerCount = 3}) {
  return SpySessionEntity.create(
    pack: const SpyPackEntity(
      id: 'p',
      name: 'P',
      words: ['w'],
      image: '',
      imageBlurHash: '',
    ),
    secretWord: 'w',
    playerCount: playerCount,
    spyCount: 1,
    roundDuration: 300,
    random: Random(1),
  );
}

void main() {
  group('FinishPlayerReveal', () {
    test('advances the reveal to the next player', () async {
      final bloc = SpySessionBloc(initialSession: _session());
      addTearDown(bloc.close);

      bloc.add(const FinishPlayerReveal());
      await pumpEventQueue();

      expect(bloc.state.session.currentRevealIndex, 1);
      expect(bloc.state.session.currentRevealPlayer.number, 2);
    });

    test('completes the reveal after the last player', () async {
      final bloc = SpySessionBloc(initialSession: _session());
      addTearDown(bloc.close);

      bloc
        ..add(const FinishPlayerReveal())
        ..add(const FinishPlayerReveal())
        ..add(const FinishPlayerReveal());
      await pumpEventQueue();

      expect(bloc.state.session.isRevealCompleted, isTrue);
    });

    test('is ignored once the reveal is completed', () async {
      final bloc = SpySessionBloc(initialSession: _session());
      addTearDown(bloc.close);

      bloc
        ..add(const FinishPlayerReveal())
        ..add(const FinishPlayerReveal())
        ..add(const FinishPlayerReveal());
      await pumpEventQueue();

      final emissions = <SpySessionState>[];
      final subscription = bloc.stream.listen(emissions.add);
      addTearDown(subscription.cancel);

      bloc.add(const FinishPlayerReveal());
      await pumpEventQueue();

      expect(emissions, isEmpty);
      expect(bloc.state.session.currentRevealIndex, 3);
    });
  });
}
