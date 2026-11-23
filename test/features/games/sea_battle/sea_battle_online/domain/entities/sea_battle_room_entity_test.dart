import 'dart:math';

import 'package:bardak/features/games/sea_battle/sea_battle_online/domain/entities/sea_battle_room_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('generated codes are valid and vary', () {
    final random = Random(1);
    final codes = {
      for (var i = 0; i < 200; i++) SeaBattleRoomEntity.generateCode(random),
    };

    expect(codes, hasLength(200));
    for (final code in codes) {
      expect(code, hasLength(SeaBattleRoomEntity.codeLength));
      expect(
        code.split('').every(SeaBattleRoomEntity.codeAlphabet.contains),
        isTrue,
        reason: code,
      );
    }
  });

  test('the alphabet leaves out look-alikes', () {
    for (final lookAlike in ['0', 'O', '1', 'I']) {
      expect(SeaBattleRoomEntity.codeAlphabet, isNot(contains(lookAlike)));
    }
  });

  test('the invite link carries the code', () {
    const room = SeaBattleRoomEntity(
      code: 'ABC234',
      role: .host,
      status: .waiting,
      hasOpponent: false,
    );

    expect(
      room.inviteLink.toString(),
      'https://bardakgames.com/join/ABC234',
    );
  });

  test('statuses parse from their names', () {
    expect(
      SeaBattleRoomStatus.fromString('placing'),
      SeaBattleRoomStatus.placing,
    );
    expect(SeaBattleRoomStatus.fromString('unknown'), isNull);
    expect(SeaBattleRoomStatus.fromString(null), isNull);
  });
}
