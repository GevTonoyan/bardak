import 'dart:math';

import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/fleet_entity.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/sea_battle_rules.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/usecases/generate_random_fleet_usecase.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('returns a complete fleet that follows the rules', () {
    final fleet = GenerateRandomFleetUseCase(random: Random(1))();

    expect(fleet.isComplete, isTrue);
    expect(
      fleet.ships.map((ship) => ship.length),
      SeaBattleRules.fleetShipLengths,
    );
    for (final ship in fleet.ships) {
      expect(ship.isOnBoard, isTrue);
      // Re-placing each ship checks it touches no other one.
      expect(fleet.canPlace(ship), isTrue);
    }
  });

  test('the same seed gives the same fleet', () {
    expect(
      GenerateRandomFleetUseCase(random: Random(5))(),
      GenerateRandomFleetUseCase(random: Random(5))(),
    );
  });

  test('each call gives a new layout', () {
    final generateRandomFleet = GenerateRandomFleetUseCase(random: Random(5));

    expect(generateRandomFleet(), isNot(generateRandomFleet()));
  });

  test('works without an injected Random', () {
    expect(GenerateRandomFleetUseCase()(), isA<FleetEntity>());
  });
}
