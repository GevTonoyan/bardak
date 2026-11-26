import 'dart:math';

import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/board_coordinate.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/fleet_entity.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/ship_entity.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_placement/domain/usecases/generate_random_fleet_usecase.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_placement/presentation/bloc/ship_placement_bloc.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_placement/presentation/bloc/ship_placement_event.dart';
import 'package:flutter_test/flutter_test.dart';

const _ship = ShipEntity(id: 0, length: 4, origin: BoardCoordinate(0, 0));

void main() {
  late ShipPlacementBloc bloc;

  setUp(() {
    bloc = ShipPlacementBloc(
      generateRandomFleetUseCase: GenerateRandomFleetUseCase(
        random: Random(1),
      ),
    );
    addTearDown(bloc.close);
  });

  test('starts with an empty board', () {
    expect(bloc.state.fleet, const FleetEntity());
  });

  test('PlaceShip places a valid ship and ignores an invalid one', () async {
    bloc
      ..add(const PlaceShip(_ship))
      // Touches the first ship diagonally.
      ..add(
        const PlaceShip(
          ShipEntity(id: 1, length: 3, origin: BoardCoordinate(1, 4)),
        ),
      );
    await pumpEventQueue();

    expect(bloc.state.fleet.ships, [_ship]);
  });

  test('RotateShip turns a ship that fits', () async {
    bloc
      ..add(const PlaceShip(_ship))
      ..add(const RotateShip(0));
    await pumpEventQueue();

    expect(
      bloc.state.fleet.ships.single.orientation,
      ShipOrientation.vertical,
    );
  });

  test('RotateShip turns a ship upwards when there is no room below', () async {
    const nearBottom = ShipEntity(
      id: 0,
      length: 4,
      origin: BoardCoordinate(8, 0),
    );
    bloc
      ..add(const PlaceShip(nearBottom))
      ..add(const RotateShip(0));
    await pumpEventQueue();

    expect(
      bloc.state.fleet.ships.single,
      const ShipEntity(
        id: 0,
        length: 4,
        origin: BoardCoordinate(5, 0),
        orientation: .vertical,
      ),
    );
  });

  test('RotateShip is ignored when no rotation fits', () async {
    const boxedIn = ShipEntity(id: 0, length: 4, origin: BoardCoordinate(4, 0));
    bloc
      ..add(const PlaceShip(boxedIn))
      // One ship two rows above and one two rows below: any upright
      // four-cell ship through row 4 reaches them.
      ..add(
        const PlaceShip(
          ShipEntity(id: 1, length: 3, origin: BoardCoordinate(2, 0)),
        ),
      )
      ..add(
        const PlaceShip(
          ShipEntity(id: 2, length: 3, origin: BoardCoordinate(6, 1)),
        ),
      )
      ..add(const RotateShip(0));
    await pumpEventQueue();

    expect(bloc.state.fleet.ships.first, boxedIn);
  });

  test('RemoveShip takes a ship off the board', () async {
    bloc
      ..add(const PlaceShip(_ship))
      ..add(const RemoveShip(0));
    await pumpEventQueue();
    expect(bloc.state.fleet.ships, isEmpty);
  });

  test('ShuffleShips places the full fleet', () async {
    bloc.add(const ShuffleShips());
    await pumpEventQueue();

    expect(bloc.state.fleet.isComplete, isTrue);
  });

  test('ClearShips takes every ship off the board', () async {
    bloc
      ..add(const ShuffleShips())
      ..add(const ClearShips());
    await pumpEventQueue();

    expect(bloc.state.fleet, const FleetEntity());
  });
}
