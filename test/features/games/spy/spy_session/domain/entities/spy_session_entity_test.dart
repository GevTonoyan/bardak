import 'dart:math';

import 'package:bardak/features/games/spy/spy_packs/domain/entities/spy_pack_entity.dart';
import 'package:bardak/features/games/spy/spy_session/domain/entities/spy_session_entity.dart';
import 'package:flutter_test/flutter_test.dart';

const _pack = SpyPackEntity(
  id: 'locations',
  name: 'Locations',
  words: ['Beach', 'Hospital'],
  image: '',
  imageBlurHash: '',
);

void main() {
  group('SpySessionEntity.create', () {
    test('creates players numbered 1..N in pass order', () {
      final session = SpySessionEntity.create(
        pack: _pack,
        secretWord: 'Beach',
        playerCount: 5,
        spyCount: 1,
        roundDuration: 300,
        random: Random(42),
      );

      expect(session.players, hasLength(5));
      expect(
        session.players.map((p) => p.number).toList(),
        [1, 2, 3, 4, 5],
      );
      expect(session.secretWord, 'Beach');
      expect(session.pack, _pack);
      expect(session.roundDuration, 300);
      expect(session.currentRevealIndex, 0);
    });

    test('assigns exactly spyCount spies', () {
      for (var seed = 0; seed < 20; seed++) {
        final session = SpySessionEntity.create(
          pack: _pack,
          secretWord: 'Beach',
          playerCount: 6,
          spyCount: 2,
          roundDuration: 300,
          random: Random(seed),
        );

        expect(
          session.players.where((p) => p.isSpy).length,
          2,
          reason: 'seed $seed must produce exactly 2 spies',
        );
      }
    });

    test('spy assignment varies across randomness', () {
      final assignments = <String>{};
      for (var seed = 0; seed < 20; seed++) {
        final session = SpySessionEntity.create(
          pack: _pack,
          secretWord: 'Beach',
          playerCount: 6,
          spyCount: 1,
          roundDuration: 300,
          random: Random(seed),
        );
        assignments.add(
          session.players.map((p) => p.isSpy ? '1' : '0').join(),
        );
      }

      expect(
        assignments.length,
        greaterThan(1),
        reason: 'the spy must not always be the same player',
      );
    });

    test('every player can be a spy when spyCount equals playerCount', () {
      final session = SpySessionEntity.create(
        pack: _pack,
        secretWord: 'Beach',
        playerCount: 3,
        spyCount: 3,
        roundDuration: 300,
        random: Random(1),
      );

      expect(session.players.every((p) => p.isSpy), isTrue);
    });
  });

  group('reveal progression', () {
    final session = SpySessionEntity.create(
      pack: _pack,
      secretWord: 'Beach',
      playerCount: 3,
      spyCount: 1,
      roundDuration: 300,
      random: Random(7),
    );

    test('currentRevealPlayer follows currentRevealIndex', () {
      expect(session.currentRevealPlayer.number, 1);
      expect(
        session.copyWith(currentRevealIndex: 2).currentRevealPlayer.number,
        3,
      );
    });

    test('isRevealCompleted only after every player has looked', () {
      expect(session.isRevealCompleted, isFalse);
      expect(
        session.copyWith(currentRevealIndex: 2).isRevealCompleted,
        isFalse,
      );
      expect(session.copyWith(currentRevealIndex: 3).isRevealCompleted, isTrue);
    });
  });
}
