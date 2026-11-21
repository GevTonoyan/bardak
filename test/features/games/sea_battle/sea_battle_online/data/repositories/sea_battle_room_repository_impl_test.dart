import 'package:bardak/features/games/sea_battle/sea_battle_online/data/data_sources/sea_battle_room_remote_data_source.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_online/data/repositories/sea_battle_room_repository_impl.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_online/domain/entities/sea_battle_room_entity.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_online/domain/exceptions/sea_battle_room_exception.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockRemoteDataSource extends Mock
    implements SeaBattleRoomRemoteDataSource {}

void main() {
  late _MockRemoteDataSource remoteDataSource;
  late SeaBattleRoomRepositoryImpl repository;

  const room = SeaBattleRoomEntity(
    code: 'ABC234',
    role: .host,
    status: .waiting,
    hasOpponent: false,
  );

  setUp(() {
    remoteDataSource = _MockRemoteDataSource();
    repository = SeaBattleRoomRepositoryImpl(
      remoteDataSource: remoteDataSource,
    );
  });

  test('createRoom creates it remotely', () async {
    when(remoteDataSource.createRoom).thenAnswer((_) async => room);

    expect(await repository.createRoom(), room);
  });

  test('joinRoom passes room failures on as they are', () async {
    when(() => remoteDataSource.joinRoom('ABC234')).thenAnswer(
      (_) async => throw const SeaBattleRoomException(.full),
    );

    await expectLater(
      repository.joinRoom('ABC234'),
      throwsA(
        isA<SeaBattleRoomException>().having(
          (error) => error.reason,
          'reason',
          SeaBattleRoomFailure.full,
        ),
      ),
    );
  });

  test('other errors become connection failures', () async {
    final offline = Exception('offline');
    when(remoteDataSource.createRoom).thenAnswer((_) async => throw offline);
    when(
      () => remoteDataSource.leaveRoom('ABC234'),
    ).thenAnswer((_) async => throw offline);

    final isConnectionFailure = isA<SeaBattleRoomException>()
        .having(
          (error) => error.reason,
          'reason',
          SeaBattleRoomFailure.connection,
        )
        .having((error) => error.cause, 'cause', offline);
    await expectLater(repository.createRoom(), throwsA(isConnectionFailure));
    await expectLater(
      repository.leaveRoom('ABC234'),
      throwsA(isConnectionFailure),
    );
  });

  test('watchRoom turns stream errors into connection failures', () {
    when(() => remoteDataSource.watchRoom('ABC234')).thenAnswer(
      (_) => Stream.error(Exception('permission denied')),
    );

    expect(
      repository.watchRoom('ABC234'),
      emitsError(
        isA<SeaBattleRoomException>().having(
          (error) => error.reason,
          'reason',
          SeaBattleRoomFailure.connection,
        ),
      ),
    );
  });

  test('watchRoom follows it remotely', () {
    when(() => remoteDataSource.watchRoom('ABC234')).thenAnswer(
      (_) => Stream.fromIterable([room, null]),
    );

    expect(repository.watchRoom('ABC234'), emitsInOrder([room, null]));
  });

  test('leaveRoom leaves it remotely', () async {
    when(() => remoteDataSource.leaveRoom('ABC234')).thenAnswer((_) async {});

    await repository.leaveRoom('ABC234');

    verify(() => remoteDataSource.leaveRoom('ABC234')).called(1);
  });

  test('errors are bugs and pass through unchanged', () async {
    when(remoteDataSource.createRoom)
        .thenAnswer((_) async => throw StateError('bug'));
    when(() => remoteDataSource.watchRoom('ABC234')).thenAnswer(
      (_) => Stream.error(TypeError()),
    );

    await expectLater(repository.createRoom(), throwsStateError);
    await expectLater(
      repository.watchRoom('ABC234'),
      emitsError(isA<TypeError>()),
    );
  });
}
