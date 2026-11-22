import 'dart:async';
import 'dart:math' show Random;

import 'package:bardak/core/di/di.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_online/domain/entities/sea_battle_room_entity.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_online/domain/exceptions/sea_battle_room_exception.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

/// Rooms stored in the Realtime Database, under `sea_battle_rooms/{code}`.
abstract interface class SeaBattleRoomRemoteDataSource {
  Future<SeaBattleRoomEntity> createRoom();

  Future<SeaBattleRoomEntity> joinRoom(String code);

  Stream<SeaBattleRoomEntity?> watchRoom(String code);

  Future<void> leaveRoom(String code);

  /// Marks this player's fleet as placed.
  Future<void> markReady(String code);

  /// Picks who fires first and starts the battle. Only the host may, once
  /// both players are ready; a second call is refused by the rules.
  Future<void> startBattle(String code);
}

/// The player is signed in anonymously before the first room action, so
/// the database rules can tell the two players of a room apart.
class SeaBattleRoomRemoteDataSourceImpl
    implements SeaBattleRoomRemoteDataSource {
  SeaBattleRoomRemoteDataSourceImpl({
    required this._database,
    required this._auth,
    Random? random,
  }) : _random = random ?? Random.secure();

  final FirebaseDatabase _database;
  final FirebaseAuth _auth;
  final Random _random;

  static const _roomsPath = 'sea_battle_rooms';
  static const _hostKey = 'host';
  static const _guestKey = 'guest';
  static const _statusKey = 'status';
  static const _createdAtKey = 'createdAt';
  static const _readyKey = 'ready';
  static const _turnKey = 'turn';

  /// The rules refuse writes that are not allowed — such as taking a code
  /// or a seat that is already taken.
  static const _permissionDenied = 'permission-denied';

  /// Codes to try before giving up on creating a room.
  static const _maxCreateAttempts = 5;

  /// Auth errors meaning the saved account no longer exists, as after an
  /// anonymous account is cleaned up.
  static const _accountGoneCodes = {
    'user-not-found',
    'user-disabled',
    'user-token-expired',
    'invalid-user-token',
  };

  /// Rooms older than this are treated as gone.
  static const _roomLifetime = Duration(hours: 1);

  DatabaseReference _room(String code) => _database.ref('$_roomsPath/$code');

  @override
  Future<SeaBattleRoomEntity> createRoom() async {
    final playerId = await _signIn();

    for (var attempt = 1; ; attempt++) {
      final code = SeaBattleRoomEntity.generateCode(_random);
      try {
        // The rules refuse to overwrite an existing room, so a taken code
        // fails here and a new one is tried.
        await _room(code).set({
          _hostKey: playerId,
          _statusKey: SeaBattleRoomStatus.waiting.name,
          _createdAtKey: ServerValue.timestamp,
        });
        return SeaBattleRoomEntity(
          code: code,
          role: .host,
          status: .waiting,
          hasOpponent: false,
        );
      } on FirebaseException catch (error) {
        if (error.code != _permissionDenied || attempt == _maxCreateAttempts) {
          rethrow;
        }
      }
    }
  }

  @override
  Future<SeaBattleRoomEntity> joinRoom(String code) async {
    // Codes arrive in links anyone can edit; one that could never have
    // been generated is not looked up, as it may not even form a valid
    // database path.
    if (!_isWellFormed(code)) {
      throw const SeaBattleRoomException(.notFound);
    }
    final playerId = await _signIn();
    final room = _room(code);

    // Only these fields are readable before joining; read together, so
    // joining waits for one round trip instead of three.
    // Future.wait passes a failed read's own exception on.
    final [
      statusSnapshot,
      createdAtSnapshot,
      guestSnapshot,
    ] = await Future.wait([
      room.child(_statusKey).get(),
      room.child(_createdAtKey).get(),
      room.child(_guestKey).get(),
    ]);
    final status = SeaBattleRoomStatus.fromString(
      statusSnapshot.value as String?,
    );
    final createdAt = createdAtSnapshot.value as int?;
    if (status == null || createdAt == null || _hasExpired(createdAt)) {
      throw const SeaBattleRoomException(.notFound);
    }

    final guest = guestSnapshot.value;
    if (status != .waiting || (guest != null && guest != playerId)) {
      throw const SeaBattleRoomException(.full);
    }

    try {
      await room.child(_guestKey).set(playerId);
    } on FirebaseException catch (error) {
      // Someone else took the seat between the check and the write.
      if (error.code == _permissionDenied) {
        throw const SeaBattleRoomException(.full);
      }
      rethrow;
    }
    await room.child(_statusKey).set(SeaBattleRoomStatus.placing.name);

    return SeaBattleRoomEntity(
      code: code,
      role: .guest,
      status: .placing,
      hasOpponent: true,
    );
  }

  @override
  Stream<SeaBattleRoomEntity?> watchRoom(String code) async* {
    final playerId = await _signIn();

    yield* _room(code).onValue.map((event) {
      final data = event.snapshot.value;
      if (data is! Map) return null;

      final status = SeaBattleRoomStatus.fromString(
        data[_statusKey] as String?,
      );
      if (status == null) return null;

      final ready = data[_readyKey];
      final readyIds = {
        if (ready is Map)
          for (final MapEntry(:key, :value) in ready.entries)
            if (value == true) key,
      };
      final turn = data[_turnKey];

      return SeaBattleRoomEntity(
        code: code,
        role: data[_hostKey] == playerId ? .host : .guest,
        status: status,
        hasOpponent: data[_guestKey] != null,
        isPlayerReady: readyIds.contains(playerId),
        isOpponentReady: readyIds.any((id) => id != playerId),
        firstTurn: turn == null
            ? null
            : turn == playerId
            ? .player
            : .opponent,
      );
    });
  }

  /// Deletes the room without waiting for the server: the database sends
  /// the deletion as soon as it can, even if the connection is down right
  /// now, and the player should not be kept on the screen meanwhile.
  @override
  Future<void> leaveRoom(String code) async {
    await _signIn();
    unawaited(
      _room(code).remove().catchError((Object error, StackTrace stackTrace) {
        logger.error(
          'Failed to delete room $code',
          error: error,
          stackTrace: stackTrace,
        );
      }),
    );
  }

  static bool _isWellFormed(String code) =>
      code.length == SeaBattleRoomEntity.codeLength &&
      code.split('').every(SeaBattleRoomEntity.codeAlphabet.contains);

  @override
  Future<void> markReady(String code) async {
    final playerId = await _signIn();
    await _room(code).child('$_readyKey/$playerId').set(true);
  }

  @override
  Future<void> startBattle(String code) async {
    final hostId = await _signIn();
    // once() rather than get(): with the room already being watched, get()
    // can come back empty.
    final guestId = (await _room(code).child(_guestKey).once()).snapshot.value;
    if (guestId is! String) {
      throw StateError('Room $code has no guest to start a battle with');
    }
    // One update, so the battle never starts without a first turn.
    await _room(code).update({
      _turnKey: _random.nextBool() ? hostId : guestId,
      _statusKey: SeaBattleRoomStatus.battle.name,
    });
  }

  bool _hasExpired(int createdAt) =>
      DateTime.now().difference(
        DateTime.fromMillisecondsSinceEpoch(createdAt),
      ) >
      _roomLifetime;

  /// The signed-in player's id, signing in anonymously first if needed.
  ///
  /// An anonymous account may be cleaned up by Firebase after 30 days; its
  /// token then fails to refresh, and a fresh account is created.
  Future<String> _signIn() async {
    final user = _auth.currentUser;
    if (user != null) {
      try {
        await user.getIdToken();
        return user.uid;
      } on FirebaseAuthException catch (error) {
        // Any other error, such as no connection, is not a reason to drop
        // the account.
        if (!_accountGoneCodes.contains(error.code)) rethrow;
        await _auth.signOut();
      }
    }
    final credential = await _auth.signInAnonymously();
    return credential.user!.uid;
  }
}
