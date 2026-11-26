import 'dart:async';

import 'package:bardak/core/di/di.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_online/domain/entities/sea_battle_room_entity.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_online/domain/exceptions/sea_battle_room_exception.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_online/domain/usecases/create_sea_battle_room_usecase.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_online/domain/usecases/leave_sea_battle_room_usecase.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_online/domain/usecases/watch_sea_battle_room_usecase.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_online/presentation/bloc/waiting_room/sea_battle_waiting_room_event.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_online/presentation/bloc/waiting_room/sea_battle_waiting_room_state.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// The host's room: creates it, then waits for a guest to join.
class SeaBattleWaitingRoomBloc
    extends Bloc<SeaBattleWaitingRoomEvent, SeaBattleWaitingRoomState> {
  SeaBattleWaitingRoomBloc({
    required this._createSeaBattleRoomUseCase,
    required this._watchSeaBattleRoomUseCase,
    required this._leaveSeaBattleRoomUseCase,
  }) : super(const SeaBattleWaitingRoomCreating()) {
    on<CreateRoom>(_onCreateRoom, transformer: restartable());
    on<LeaveRoom>(_onLeaveRoom, transformer: droppable());
  }

  final CreateSeaBattleRoomUseCase _createSeaBattleRoomUseCase;
  final WatchSeaBattleRoomUseCase _watchSeaBattleRoomUseCase;
  final LeaveSeaBattleRoomUseCase _leaveSeaBattleRoomUseCase;

  /// The player chose to leave, so nothing that arrives afterwards counts.
  bool get _isLeaving =>
      state is SeaBattleWaitingRoomLeaving || state is SeaBattleWaitingRoomLeft;

  Future<void> _onCreateRoom(
    CreateRoom event,
    Emitter<SeaBattleWaitingRoomState> emit,
  ) async {
    emit(const SeaBattleWaitingRoomCreating());
    final SeaBattleRoomEntity room;
    try {
      room = await _createSeaBattleRoomUseCase();
    } on SeaBattleRoomException catch (error, stackTrace) {
      logger.error(
        'Failed to create a room',
        error: error,
        stackTrace: stackTrace,
      );
      if (!_isLeaving) emit(const SeaBattleWaitingRoomFailure());
      return;
    }

    // The player left while the room was being made: close it right away.
    if (_isLeaving) return _leave(room.code);

    emit(SeaBattleWaitingRoomWaiting(room));
    await emit.onEach(
      _watchSeaBattleRoomUseCase(room.code),
      onData: (room) {
        // Only an open room is followed. Deleting it on leaving or after a
        // failure also ends up here, and only a room that vanished on its
        // own counts as closed.
        if (state is! SeaBattleWaitingRoomWaiting) return;
        emit(
          room == null
              ? const SeaBattleWaitingRoomClosed()
              : SeaBattleWaitingRoomWaiting(room),
        );
      },
      onError: (error, stackTrace) {
        logger.error(
          'Lost the room ${room.code}',
          error: error,
          stackTrace: stackTrace,
        );
        if (state is! SeaBattleWaitingRoomWaiting) return;
        // A friend can no longer join this room, so it goes; trying again
        // makes a new one.
        emit(const SeaBattleWaitingRoomFailure());
        unawaited(_leave(room.code));
      },
    );
  }

  /// Always lets the player out. The deletion is sent as soon as there
  /// is a connection; a room it never reaches can no longer be joined
  /// after an hour, but stays in the database.
  Future<void> _onLeaveRoom(
    LeaveRoom event,
    Emitter<SeaBattleWaitingRoomState> emit,
  ) async {
    final current = state;
    emit(const SeaBattleWaitingRoomLeaving());
    if (current is SeaBattleWaitingRoomWaiting) await _leave(current.room.code);
    emit(const SeaBattleWaitingRoomLeft());
  }

  Future<void> _leave(String code) async {
    try {
      await _leaveSeaBattleRoomUseCase(code);
    } on SeaBattleRoomException catch (error, stackTrace) {
      logger.error(
        'Failed to leave room $code',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }
}
