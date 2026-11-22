import 'dart:async';
import 'dart:math';

import 'package:bardak/features/games/sea_battle/sea_battle_game/data/data_sources/sea_battle_opponent_local_data_source.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/board_coordinate.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/fleet_entity.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/sea_battle_board_entity.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/sea_battle_entity.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/repositories/sea_battle_opponent_repository.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_online/domain/entities/sea_battle_room_entity.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_online/domain/repositories/sea_battle_room_repository.dart';

/// Whether online Sea Battle is played against the fakes below instead of
/// Firebase, to try the online screens on one device. Development only:
/// `flutter run --dart-define=SEA_BATTLE_FAKE_ONLINE=true`.
const useFakeSeaBattleOnline = bool.fromEnvironment('SEA_BATTLE_FAKE_ONLINE');

/// A room played by a pretend friend: they join shortly after the room is
/// created, and finish placing their fleet a while later.
class FakeSeaBattleRoomRepository implements SeaBattleRoomRepository {
  FakeSeaBattleRoomRepository({Random? random}) : _random = random ?? Random();

  final Random _random;

  static const _code = 'DEMO42';
  static const _joinDelay = Duration(seconds: 3);
  static const _opponentPlacingTime = Duration(seconds: 15);

  final _changes = StreamController<SeaBattleRoomEntity?>.broadcast();
  final _timers = <Timer>[];
  SeaBattleRoomEntity? _room;

  void _set(SeaBattleRoomEntity? room) {
    _room = room;
    _changes.add(room);
  }

  @override
  Future<SeaBattleRoomEntity> createRoom() async {
    for (final timer in _timers) {
      timer.cancel();
    }
    _timers.clear();

    const room = SeaBattleRoomEntity(
      code: _code,
      role: .host,
      status: .waiting,
      hasOpponent: false,
    );
    _set(room);

    _timers
      ..add(
        Timer(_joinDelay, () {
          _update((room) => _copy(room, hasOpponent: true, status: .placing));
        }),
      )
      ..add(
        Timer(_joinDelay + _opponentPlacingTime, () {
          _update((room) => _copy(room, isOpponentReady: true));
        }),
      );
    return room;
  }

  @override
  Future<SeaBattleRoomEntity> joinRoom(String code) => createRoom();

  @override
  Stream<SeaBattleRoomEntity?> watchRoom(String code) async* {
    yield _room;
    yield* _changes.stream;
  }

  @override
  Future<void> leaveRoom(String code) async {
    for (final timer in _timers) {
      timer.cancel();
    }
    _timers.clear();
    _set(null);
  }

  @override
  Future<void> markReady(String code) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    _update((room) => _copy(room, isPlayerReady: true));
  }

  @override
  Future<void> startBattle(String code) async {
    _update(
      (room) => _copy(
        room,
        status: .battle,
        firstTurn: _random.nextBool() ? .player : .opponent,
      ),
    );
  }

  void _update(SeaBattleRoomEntity Function(SeaBattleRoomEntity) change) {
    final room = _room;
    if (room != null) _set(change(room));
  }

  static SeaBattleRoomEntity _copy(
    SeaBattleRoomEntity room, {
    SeaBattleRoomStatus? status,
    bool? hasOpponent,
    bool? isPlayerReady,
    bool? isOpponentReady,
    SeaBattleSide? firstTurn,
  }) => SeaBattleRoomEntity(
    code: room.code,
    role: room.role,
    status: status ?? room.status,
    hasOpponent: hasOpponent ?? room.hasOpponent,
    isPlayerReady: isPlayerReady ?? room.isPlayerReady,
    isOpponentReady: isOpponentReady ?? room.isOpponentReady,
    firstTurn: firstTurn ?? room.firstTurn,
  );
}

/// A pretend remote player: the medium bot, taking a human-like few
/// seconds over each shot so the turn timer can be seen running.
class FakeSeaBattleRemoteOpponentRepository
    implements SeaBattleOpponentRepository {
  FakeSeaBattleRemoteOpponentRepository({Random? random})
    : _random = random ?? Random(),
      _bot = SeaBattleOpponentLocalDataSourceImpl(difficulty: .medium);

  final Random _random;
  final SeaBattleOpponentLocalDataSource _bot;

  static const _networkDelay = Duration(milliseconds: 250);

  @override
  Future<ShotEntity> answerPlayerShot(BoardCoordinate cell) async {
    await Future<void>.delayed(_networkDelay);
    return _bot.answerPlayerShot(cell);
  }

  @override
  Future<BoardCoordinate> getOpponentShot(
    SeaBattleBoardEntity playerBoard,
  ) async {
    await Future<void>.delayed(
      Duration(milliseconds: 1000 + _random.nextInt(4000)),
    );
    return _bot.getOpponentShot(playerBoard);
  }

  @override
  Future<void> reportOpponentShot(ShotEntity shot) =>
      Future<void>.delayed(_networkDelay);

  @override
  Future<FleetEntity> getOpponentFleet() => _bot.getOpponentFleet();
}
