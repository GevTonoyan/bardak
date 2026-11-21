import 'package:bardak/core/di/di.dart';
import 'package:bardak/core/logging/app_logger.dart';
import 'package:bardak/core/logging/console_logger.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_online/domain/entities/sea_battle_room_entity.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_online/domain/exceptions/sea_battle_room_exception.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_online/domain/usecases/join_sea_battle_room_usecase.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_online/presentation/bloc/join_room/sea_battle_join_room_bloc.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_online/presentation/bloc/join_room/sea_battle_join_room_event.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_online/presentation/bloc/join_room/sea_battle_join_room_state.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockJoinSeaBattleRoomUseCase extends Mock
    implements JoinSeaBattleRoomUseCase {}

void main() {
  late _MockJoinSeaBattleRoomUseCase joinRoom;

  const room = SeaBattleRoomEntity(
    code: 'ABC234',
    role: .guest,
    status: .placing,
    hasOpponent: true,
  );

  setUpAll(() {
    if (!sl.isRegistered<AppLogger>()) {
      sl.registerLazySingleton<AppLogger>(ConsoleLogger.new);
    }
  });

  setUp(() => joinRoom = _MockJoinSeaBattleRoomUseCase());

  SeaBattleJoinRoomBloc buildBloc() =>
      SeaBattleJoinRoomBloc(joinSeaBattleRoomUseCase: joinRoom);

  blocTest<SeaBattleJoinRoomBloc, SeaBattleJoinRoomState>(
    'joins the room',
    setUp: () => when(() => joinRoom('ABC234')).thenAnswer((_) async => room),
    build: buildBloc,
    act: (bloc) => bloc.add(const JoinRoom('ABC234')),
    expect: () => const [
      SeaBattleJoinRoomJoining(),
      SeaBattleJoinRoomJoined(room),
    ],
  );

  for (final reason in SeaBattleRoomFailure.values) {
    blocTest<SeaBattleJoinRoomBloc, SeaBattleJoinRoomState>(
      'shows why joining failed: ${reason.name}',
      setUp: () => when(
        () => joinRoom('ABC234'),
      ).thenThrow(SeaBattleRoomException(reason)),
      build: buildBloc,
      act: (bloc) => bloc.add(const JoinRoom('ABC234')),
      expect: () => [
        const SeaBattleJoinRoomJoining(),
        SeaBattleJoinRoomFailure(reason),
      ],
    );
  }

  blocTest<SeaBattleJoinRoomBloc, SeaBattleJoinRoomState>(
    'a lost connection can be retried',
    setUp: () {
      var attempts = 0;
      when(() => joinRoom('ABC234')).thenAnswer((_) async {
        if (attempts++ == 0) throw const SeaBattleRoomException(.connection);
        return room;
      });
    },
    build: buildBloc,
    act: (bloc) async {
      bloc.add(const JoinRoom('ABC234'));
      await pumpEventQueue();
      bloc.add(const JoinRoom('ABC234'));
    },
    expect: () => const [
      SeaBattleJoinRoomJoining(),
      SeaBattleJoinRoomFailure(.connection),
      SeaBattleJoinRoomJoining(),
      SeaBattleJoinRoomJoined(room),
    ],
  );
}
