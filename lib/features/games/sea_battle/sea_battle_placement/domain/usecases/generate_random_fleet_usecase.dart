import 'dart:math';

import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/fleet_entity.dart';

/// Places a full fleet at random positions, following the rules.
///
/// Used by the Shuffle button and, later, to place the bot's ships.
class GenerateRandomFleetUseCase {
  GenerateRandomFleetUseCase({Random? random}) : _random = random ?? Random();

  final Random _random;

  FleetEntity call() => FleetEntity.random(_random);
}
