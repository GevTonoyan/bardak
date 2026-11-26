import 'dart:async';
import 'dart:math';

import 'package:bardak/core/di/di.dart';
import 'package:bardak/core/logging/app_logger.dart';
import 'package:bardak/core/logging/console_logger.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/fleet_entity.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_online/domain/entities/sea_battle_room_entity.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_online/domain/exceptions/sea_battle_room_exception.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_online/domain/usecases/leave_sea_battle_room_usecase.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_online/domain/usecases/mark_sea_battle_room_ready_usecase.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_online/domain/usecases/start_sea_battle_room_battle_usecase.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_online/domain/usecases/watch_sea_battle_room_usecase.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_online/presentation/bloc/online_placement/sea_battle_online_placement_bloc.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_online/presentation/bloc/online_placement/sea_battle_online_placement_event.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_online/presentation/bloc/online_placement/sea_battle_online_placement_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockWatchSeaBattleRoomUseCase extends Mock
    implements WatchSeaBattleRoomUseCase {}

class _MockMarkSeaBattleRoomReadyUseCase extends Mock
    implements MarkSeaBattleRoomReadyUseCase {}

class _MockStartSeaBattleRoomBattleUseCase extends Mock
    implements StartSeaBattleRoomBattleUseCase {}

class _MockLeaveSeaBattleRoomUseCase extends Mock
    implements LeaveSeaBattleRoomUseCase {}

void main() {
  late _MockWatchSeaBattleRoomUseCase watchRoom;
  late _MockMarkSeaBattleRoomReadyUseCase markReady;
  late _MockStartSeaBattleRoomBattleUseCase startBattle;
  late _MockLeaveSeaBattleRoomUseCase leaveRoom;
  late StreamController<SeaBattleRoomEntity?> updates;

  const code = 'ABC234';
  final placedFleet = FleetEntity.random(Random(1));

  SeaBattleRoomEntity room({
    SeaBattleRoomRole role = .host,
    bool isPlayerReady = false,
    bool isOpponentReady = false,
    bool startedWithPlayer = false,
  }) => SeaBattleRoomEntity(
    code: code,
    role: role,
    status: startedWithPlayer ? .battle : .placing,
    hasOpponent: true,
    isPlayerReady: isPlayerReady,
    isOpponentReady: isOpponentReady,
    firstTurn: startedWithPlayer ? .player : null,
  );

  setUpAll(() {
    if (!sl.isRegistered<AppLogger>()) {
      sl.registerLazySingleton<AppLogger>(ConsoleLogger.new);
    }
  });

  setUp(() {
    watchRoom = _MockWatchSeaBattleRoomUseCase();
    markReady = _MockMarkSeaBattleRoomReadyUseCase();
    startBattle = _MockStartSeaBattleRoomBattleUseCase();
    leaveRoom = _MockLeaveSeaBattleRoomUseCase();
    updates = StreamController<SeaBattleRoomEntity?>();
    when(() => watchRoom(code)).thenAnswer((_) => updates.stream);
    when(() => markReady(code)).thenAnswer((_) async {});
    when(() => startBattle(code)).thenAnswer((_) async {});
    when(() => leaveRoom(code)).thenAnswer((_) async {});
  });

  // Not awaited: a stream nobody watched never finishes closing.
  tearDown(() => unawaited(updates.close()));

  SeaBattleOnlinePlacementBloc buildBloc({
    SeaBattleRoomRole role = .host,
  }) => SeaBattleOnlinePlacementBloc(
    room: room(role: role),
    watchSeaBattleRoomUseCase: watchRoom,
    markSeaBattleRoomReadyUseCase: markReady,
    startSeaBattleRoomBattleUseCase: startBattle,
    leaveSeaBattleRoomUseCase: leaveRoom,
  );

  test('starts placing', () {
    expect(buildBloc().state, const SeaBattleOnlinePlacementPlacing());
  });

  blocTest<SeaBattleOnlinePlacementBloc, SeaBattleOnlinePlacementState>(
    'getting ready waits for the other player',
    build: buildBloc,
    act: (bloc) => bloc.add(MarkReady(placedFleet)),
    expect: () => [SeaBattleOnlinePlacementWaiting(placedFleet)],
    verify: (_) => verify(() => markReady(code)).called(1),
  );

  blocTest<SeaBattleOnlinePlacementBloc, SeaBattleOnlinePlacementState>(
    'a failed ready keeps the fleet to retry',
    setUp: () => when(
      () => markReady(code),
    ).thenThrow(const SeaBattleRoomException(.connection)),
    build: buildBloc,
    act: (bloc) => bloc.add(MarkReady(placedFleet)),
    expect: () => [
      SeaBattleOnlinePlacementWaiting(placedFleet),
      SeaBattleOnlinePlacementFailure(placedFleet),
    ],
  );

  blocTest<SeaBattleOnlinePlacementBloc, SeaBattleOnlinePlacementState>(
    'the host starts the battle once both are ready',
    build: buildBloc,
    act: (bloc) async {
      bloc.add(const WatchRoom());
      await pumpEventQueue();
      updates.add(room(isPlayerReady: true, isOpponentReady: true));
    },
    verify: (_) => verify(() => startBattle(code)).called(1),
  );

  blocTest<SeaBattleOnlinePlacementBloc, SeaBattleOnlinePlacementState>(
    'the guest leaves starting the battle to the host',
    build: () => buildBloc(role: .guest),
    act: (bloc) async {
      bloc.add(const WatchRoom());
      await pumpEventQueue();
      updates.add(
        room(role: .guest, isPlayerReady: true, isOpponentReady: true),
      );
    },
    verify: (_) => verifyNever(() => startBattle(code)),
  );

  blocTest<SeaBattleOnlinePlacementBloc, SeaBattleOnlinePlacementState>(
    'once the battle starts, the ready player moves on with their fleet',
    build: buildBloc,
    act: (bloc) async {
      bloc
        ..add(const WatchRoom())
        ..add(MarkReady(placedFleet));
      await pumpEventQueue();
      updates.add(
        room(
          isPlayerReady: true,
          isOpponentReady: true,
          startedWithPlayer: true,
        ),
      );
    },
    skip: 1,
    expect: () => [
      SeaBattleOnlinePlacementStarted(
        room: room(
          isPlayerReady: true,
          isOpponentReady: true,
          startedWithPlayer: true,
        ),
        fleet: placedFleet,
      ),
    ],
  );

  blocTest<SeaBattleOnlinePlacementBloc, SeaBattleOnlinePlacementState>(
    'a room that disappears is closed',
    build: buildBloc,
    act: (bloc) async {
      bloc.add(const WatchRoom());
      await pumpEventQueue();
      updates.add(null);
    },
    expect: () => const [SeaBattleOnlinePlacementClosed()],
  );

  blocTest<SeaBattleOnlinePlacementBloc, SeaBattleOnlinePlacementState>(
    'a room that can no longer be watched is closed',
    build: buildBloc,
    act: (bloc) async {
      bloc.add(const WatchRoom());
      await pumpEventQueue();
      updates.addError(const SeaBattleRoomException(.connection));
    },
    expect: () => const [SeaBattleOnlinePlacementClosed()],
  );

  blocTest<SeaBattleOnlinePlacementBloc, SeaBattleOnlinePlacementState>(
    'leaving closes the room',
    build: buildBloc,
    act: (bloc) => bloc.add(const LeaveRoom()),
    expect: () => [const SeaBattleOnlinePlacementLeft()],
    verify: (_) => verify(() => leaveRoom(code)).called(1),
  );

  blocTest<SeaBattleOnlinePlacementBloc, SeaBattleOnlinePlacementState>(
    'the room deleted by leaving does not count as closed',
    build: buildBloc,
    act: (bloc) async {
      bloc
        ..add(const WatchRoom())
        ..add(const LeaveRoom());
      await pumpEventQueue();
      updates.add(null);
    },
    expect: () => [const SeaBattleOnlinePlacementLeft()],
  );

  blocTest<SeaBattleOnlinePlacementBloc, SeaBattleOnlinePlacementState>(
    'a failed leave still lets the player out',
    setUp: () => when(
      () => leaveRoom(code),
    ).thenThrow(const SeaBattleRoomException(.connection)),
    build: buildBloc,
    act: (bloc) => bloc.add(const LeaveRoom()),
    expect: () => [const SeaBattleOnlinePlacementLeft()],
  );
}
