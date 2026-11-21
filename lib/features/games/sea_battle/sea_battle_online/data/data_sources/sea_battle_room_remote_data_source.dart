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
    final playerId = await _signIn();
    final room = _room(code);

    // Only these fields are readable before joining.
    final status = SeaBattleRoomStatus.fromString(
      (await room.child(_statusKey).get()).value as String?,
    );
    final createdAt = (await room.child(_createdAtKey).get()).value as int?;
    if (status == null || createdAt == null || _hasExpired(createdAt)) {
      throw const SeaBattleRoomException(.notFound);
    }

    final guest = (await room.child(_guestKey).get()).value;
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

      return SeaBattleRoomEntity(
        code: code,
        role: data[_hostKey] == playerId ? .host : .guest,
        status: status,
        hasOpponent: data[_guestKey] != null,
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
