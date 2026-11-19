import 'dart:math';

import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/fleet_entity.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/sea_battle_entity.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/usecases/start_sea_battle_usecase.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final playerFleet = FleetEntity.random(Random(1));

  test("pits the player's fleet against a hidden one", () {
    final battle = StartSeaBattleUseCase(random: Random(2))(playerFleet);

    expect(battle.playerBoard.fleet, playerFleet);
    expect(battle.playerBoard.marked, isEmpty);
    expect(battle.opponentBoard.fleet, isNull);
    expect(battle.opponentBoard.marked, isEmpty);
    expect(battle.isOver, isFalse);
  });

  test('either side may fire first', () {
    final firstShooters = {
      for (var seed = 0; seed < 20; seed++)
        StartSeaBattleUseCase(random: Random(seed))(playerFleet).turn,
    };

    expect(firstShooters, SeaBattleSide.values.toSet());
  });
}
