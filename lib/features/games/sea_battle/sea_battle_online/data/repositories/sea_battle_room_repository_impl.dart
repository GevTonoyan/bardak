import 'dart:async';

import 'package:bardak/features/games/sea_battle/sea_battle_online/data/data_sources/sea_battle_room_remote_data_source.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_online/domain/entities/sea_battle_room_entity.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_online/domain/exceptions/sea_battle_room_exception.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_online/domain/repositories/sea_battle_room_repository.dart';

/// Passes room actions to the remote data source, turning its Firebase
/// and network exceptions into [SeaBattleRoomException]s. [Error]s are
/// bugs and pass through unchanged.
class SeaBattleRoomRepositoryImpl implements SeaBattleRoomRepository {
  const SeaBattleRoomRepositoryImpl({required this._remoteDataSource});

  final SeaBattleRoomRemoteDataSource _remoteDataSource;

  @override
  Future<SeaBattleRoomEntity> createRoom() =>
      _guard(_remoteDataSource.createRoom);

  @override
  Future<SeaBattleRoomEntity> joinRoom(String code) =>
      _guard(() => _remoteDataSource.joinRoom(code));

  @override
  Stream<SeaBattleRoomEntity?> watchRoom(String code) => _remoteDataSource
      .watchRoom(code)
      .transform(
        StreamTransformer.fromHandlers(
          // Errors, unlike exceptions, are bugs: they pass on unchanged
          // so they are reported as such.
          handleError: (error, stackTrace, sink) => sink.addError(
            error is Exception ? _toRoomException(error) : error,
            stackTrace,
          ),
        ),
      );

  @override
  Future<void> leaveRoom(String code) =>
      _guard(() => _remoteDataSource.leaveRoom(code));

  Future<T> _guard<T>(Future<T> Function() action) async {
    try {
      return await action();
    } on Exception catch (error, stackTrace) {
      Error.throwWithStackTrace(_toRoomException(error), stackTrace);
    }
  }

  /// Room failures pass through; anything else from Firebase or the
  /// network means the server could not be reached.
  static SeaBattleRoomException _toRoomException(Exception error) =>
      error is SeaBattleRoomException
      ? error
      : SeaBattleRoomException(.connection, cause: error);
}
