import 'dart:async';

import 'package:bardak/core/di/di.dart';
import 'package:bardak/core/logging/app_logger.dart';
import 'package:bardak/core/logging/console_logger.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_online/domain/entities/sea_battle_room_entity.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_online/domain/exceptions/sea_battle_room_exception.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_online/domain/usecases/create_sea_battle_room_usecase.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_online/domain/usecases/leave_sea_battle_room_usecase.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_online/domain/usecases/watch_sea_battle_room_usecase.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_online/presentation/bloc/waiting_room/sea_battle_waiting_room_bloc.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_online/presentation/bloc/waiting_room/sea_battle_waiting_room_event.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_online/presentation/bloc/waiting_room/sea_battle_waiting_room_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockCreateSeaBattleRoomUseCase extends Mock
    implements CreateSeaBattleRoomUseCase {}

class _MockWatchSeaBattleRoomUseCase extends Mock
    implements WatchSeaBattleRoomUseCase {}

class _MockLeaveSeaBattleRoomUseCase extends Mock
    implements LeaveSeaBattleRoomUseCase {}

void main() {
  late _MockCreateSeaBattleRoomUseCase createRoom;
  late _MockWatchSeaBattleRoomUseCase watchRoom;
  late _MockLeaveSeaBattleRoomUseCase leaveRoom;
  late StreamController<SeaBattleRoomEntity?> updates;

  const room = SeaBattleRoomEntity(
    code: 'ABC234',
    role: .host,
    status: .waiting,
    hasOpponent: false,
  );
  const joined = SeaBattleRoomEntity(
    code: 'ABC234',
    role: .host,
    status: .placing,
    hasOpponent: true,
  );

  setUpAll(() {
    if (!sl.isRegistered<AppLogger>()) {
      sl.registerLazySingleton<AppLogger>(ConsoleLogger.new);
    }
  });

  setUp(() {
    createRoom = _MockCreateSeaBattleRoomUseCase();
    watchRoom = _MockWatchSeaBattleRoomUseCase();
    leaveRoom = _MockLeaveSeaBattleRoomUseCase();
    updates = StreamController<SeaBattleRoomEntity?>();
    when(() => createRoom()).thenAnswer((_) async => room);
    when(() => watchRoom('ABC234')).thenAnswer((_) => updates.stream);
    when(() => leaveRoom('ABC234')).thenAnswer((_) async {
      // Deleting the room reaches the watched room right away.
      updates.add(null);
    });
  });

  // Not awaited: a stream nobody watched never finishes closing.
  tearDown(() => unawaited(updates.close()));

  SeaBattleWaitingRoomBloc buildBloc() => SeaBattleWaitingRoomBloc(
    createSeaBattleRoomUseCase: createRoom,
    watchSeaBattleRoomUseCase: watchRoom,
    leaveSeaBattleRoomUseCase: leaveRoom,
  );

  blocTest<SeaBattleWaitingRoomBloc, SeaBattleWaitingRoomState>(
    'creates the room and shows the guest joining',
    build: buildBloc,
    act: (bloc) async {
      bloc.add(const CreateRoom());
      await pumpEventQueue();
      updates.add(joined);
    },
    expect: () => const [
      SeaBattleWaitingRoomCreating(),
      SeaBattleWaitingRoomWaiting(room),
      SeaBattleWaitingRoomWaiting(joined),
    ],
  );

  blocTest<SeaBattleWaitingRoomBloc, SeaBattleWaitingRoomState>(
    'a failed create can be retried',
    setUp: () {
      var attempts = 0;
      when(() => createRoom()).thenAnswer((_) async {
        if (attempts++ == 0) throw const SeaBattleRoomException(.connection);
        return room;
      });
    },
    build: buildBloc,
    act: (bloc) async {
      bloc.add(const CreateRoom());
      await pumpEventQueue();
      bloc.add(const CreateRoom());
    },
    expect: () => const [
      SeaBattleWaitingRoomCreating(),
      SeaBattleWaitingRoomFailure(),
      SeaBattleWaitingRoomCreating(),
      SeaBattleWaitingRoomWaiting(room),
    ],
  );

  blocTest<SeaBattleWaitingRoomBloc, SeaBattleWaitingRoomState>(
    'a room that vanishes on its own is closed',
    build: buildBloc,
    act: (bloc) async {
      bloc.add(const CreateRoom());
      await pumpEventQueue();
      updates.add(null);
    },
    skip: 2,
    expect: () => const [SeaBattleWaitingRoomClosed()],
  );

  blocTest<SeaBattleWaitingRoomBloc, SeaBattleWaitingRoomState>(
    'leaving deletes the room without calling it closed',
    build: buildBloc,
    act: (bloc) async {
      bloc.add(const CreateRoom());
      await pumpEventQueue();
      bloc.add(const LeaveRoom());
    },
    skip: 2,
    expect: () => const [
      SeaBattleWaitingRoomLeaving(),
      SeaBattleWaitingRoomLeft(),
    ],
    verify: (_) => verify(() => leaveRoom('ABC234')).called(1),
  );

  blocTest<SeaBattleWaitingRoomBloc, SeaBattleWaitingRoomState>(
    'leaving lets the player out even when the room cannot be deleted',
    setUp: () => when(
      () => leaveRoom('ABC234'),
    ).thenThrow(const SeaBattleRoomException(.connection)),
    build: buildBloc,
    act: (bloc) async {
      bloc.add(const CreateRoom());
      await pumpEventQueue();
      bloc.add(const LeaveRoom());
    },
    skip: 2,
    expect: () => const [
      SeaBattleWaitingRoomLeaving(),
      SeaBattleWaitingRoomLeft(),
    ],
  );

  blocTest<SeaBattleWaitingRoomBloc, SeaBattleWaitingRoomState>(
    'losing the room shows the failure and closes it',
    build: buildBloc,
    act: (bloc) async {
      bloc.add(const CreateRoom());
      await pumpEventQueue();
      updates.addError(const SeaBattleRoomException(.connection));
    },
    skip: 2,
    expect: () => const [SeaBattleWaitingRoomFailure()],
    verify: (_) => verify(() => leaveRoom('ABC234')).called(1),
  );

  group('leaving while the room is made', () {
    late Completer<SeaBattleRoomEntity> created;

    setUp(() {
      created = Completer<SeaBattleRoomEntity>();
      when(() => createRoom()).thenAnswer((_) => created.future);
    });

    blocTest<SeaBattleWaitingRoomBloc, SeaBattleWaitingRoomState>(
      'closes the room once it exists',
      build: buildBloc,
      act: (bloc) async {
        bloc.add(const CreateRoom());
        await pumpEventQueue();
        bloc.add(const LeaveRoom());
        await pumpEventQueue();
        created.complete(room);
      },
      expect: () => const [
        SeaBattleWaitingRoomCreating(),
        SeaBattleWaitingRoomLeaving(),
        SeaBattleWaitingRoomLeft(),
      ],
      verify: (_) {
        verify(() => leaveRoom('ABC234')).called(1);
        verifyNever(() => watchRoom(any()));
      },
    );
  });
}
