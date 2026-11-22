import 'package:bardak/features/games/sea_battle/sea_battle_online/domain/entities/sea_battle_room_entity.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_online/domain/repositories/sea_battle_room_repository.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_online/domain/usecases/create_sea_battle_room_usecase.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_online/domain/usecases/join_sea_battle_room_usecase.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_online/domain/usecases/leave_sea_battle_room_usecase.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_online/domain/usecases/mark_sea_battle_room_ready_usecase.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_online/domain/usecases/start_sea_battle_room_battle_usecase.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_online/domain/usecases/watch_sea_battle_room_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockSeaBattleRoomRepository extends Mock
    implements SeaBattleRoomRepository {}

void main() {
  late _MockSeaBattleRoomRepository repository;

  const room = SeaBattleRoomEntity(
    code: 'ABC234',
    role: .guest,
    status: .placing,
    hasOpponent: true,
  );

  setUp(() => repository = _MockSeaBattleRoomRepository());

  test('CreateSeaBattleRoomUseCase creates a room', () async {
    when(repository.createRoom).thenAnswer((_) async => room);

    expect(await CreateSeaBattleRoomUseCase(repository)(), room);
  });

  test('JoinSeaBattleRoomUseCase joins by code', () async {
    when(() => repository.joinRoom('ABC234')).thenAnswer((_) async => room);

    expect(await JoinSeaBattleRoomUseCase(repository)('ABC234'), room);
  });

  test('WatchSeaBattleRoomUseCase follows the room', () {
    when(() => repository.watchRoom('ABC234')).thenAnswer(
      (_) => Stream.value(room),
    );

    expect(WatchSeaBattleRoomUseCase(repository)('ABC234'), emits(room));
  });

  test('LeaveSeaBattleRoomUseCase leaves the room', () async {
    when(() => repository.leaveRoom('ABC234')).thenAnswer((_) async {});

    await LeaveSeaBattleRoomUseCase(repository)('ABC234');

    verify(() => repository.leaveRoom('ABC234')).called(1);
  });

  test('MarkSeaBattleRoomReadyUseCase marks the player ready', () async {
    when(() => repository.markReady('ABC234')).thenAnswer((_) async {});

    await MarkSeaBattleRoomReadyUseCase(repository)('ABC234');

    verify(() => repository.markReady('ABC234')).called(1);
  });

  test('StartSeaBattleRoomBattleUseCase starts the battle', () async {
    when(() => repository.startBattle('ABC234')).thenAnswer((_) async {});

    await StartSeaBattleRoomBattleUseCase(repository)('ABC234');

    verify(() => repository.startBattle('ABC234')).called(1);
  });
}
