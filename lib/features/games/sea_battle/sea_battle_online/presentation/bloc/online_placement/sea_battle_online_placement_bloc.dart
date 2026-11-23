import 'package:bardak/core/di/di.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_online/domain/entities/sea_battle_room_entity.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_online/domain/exceptions/sea_battle_room_exception.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_online/domain/usecases/leave_sea_battle_room_usecase.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_online/domain/usecases/mark_sea_battle_room_ready_usecase.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_online/domain/usecases/start_sea_battle_room_battle_usecase.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_online/domain/usecases/watch_sea_battle_room_usecase.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_online/presentation/bloc/online_placement/sea_battle_online_placement_event.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_online/presentation/bloc/online_placement/sea_battle_online_placement_state.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// The online side of placing ships: telling the room the fleet is ready,
/// starting the battle once both players are, and leaving.
///
/// The ships themselves are moved by the shared placement bloc; this one
/// only learns the fleet when it is confirmed.
class SeaBattleOnlinePlacementBloc
    extends Bloc<SeaBattleOnlinePlacementEvent, SeaBattleOnlinePlacementState> {
  SeaBattleOnlinePlacementBloc({
    required this._room,
    required this._watchSeaBattleRoomUseCase,
    required this._markSeaBattleRoomReadyUseCase,
    required this._startSeaBattleRoomBattleUseCase,
    required this._leaveSeaBattleRoomUseCase,
  }) : super(const SeaBattleOnlinePlacementPlacing()) {
    on<WatchRoom>(_onWatchRoom, transformer: restartable());
    on<MarkReady>(_onMarkReady, transformer: droppable());
    on<StartBattle>(_onStartBattle, transformer: droppable());
    on<LeaveRoom>(_onLeaveRoom, transformer: droppable());
  }

  /// The room as it was when placement began: its code and this player's
  /// role.
  final SeaBattleRoomEntity _room;
  final WatchSeaBattleRoomUseCase _watchSeaBattleRoomUseCase;
  final MarkSeaBattleRoomReadyUseCase _markSeaBattleRoomReadyUseCase;
  final StartSeaBattleRoomBattleUseCase _startSeaBattleRoomBattleUseCase;
  final LeaveSeaBattleRoomUseCase _leaveSeaBattleRoomUseCase;

  Future<void> _onWatchRoom(
    WatchRoom event,
    Emitter<SeaBattleOnlinePlacementState> emit,
  ) {
    return emit.onEach(
      _watchSeaBattleRoomUseCase(_room.code),
      onData: (room) {
        final current = state;
        // Leaving deletes the room, which is not the other player closing
        // it.
        if (current is SeaBattleOnlinePlacementLeft) return;
        if (room == null) {
          emit(const SeaBattleOnlinePlacementClosed());
        } else if (room.firstTurn != null &&
            current is SeaBattleOnlinePlacementWaiting) {
          emit(
            SeaBattleOnlinePlacementStarted(room: room, fleet: current.fleet),
          );
        } else if (room.role == .host &&
            room.areBothReady &&
            room.firstTurn == null) {
          add(const StartBattle());
        }
      },
      onError: (error, stackTrace) => logger.error(
        'Lost the room ${_room.code} while placing',
        error: error,
        stackTrace: stackTrace,
      ),
    );
  }

  Future<void> _onMarkReady(
    MarkReady event,
    Emitter<SeaBattleOnlinePlacementState> emit,
  ) async {
    final fleet = event.fleet;
    emit(SeaBattleOnlinePlacementWaiting(fleet));
    try {
      await _markSeaBattleRoomReadyUseCase(_room.code);
    } on SeaBattleRoomException catch (error, stackTrace) {
      logger.error(
        'Failed to mark ready in room ${_room.code}',
        error: error,
        stackTrace: stackTrace,
      );
      emit(SeaBattleOnlinePlacementFailure(fleet));
    }
  }

  /// A second start, from another room update arriving first, is refused
  /// by the database and needs nothing more.
  Future<void> _onStartBattle(
    StartBattle event,
    Emitter<SeaBattleOnlinePlacementState> emit,
  ) async {
    try {
      await _startSeaBattleRoomBattleUseCase(_room.code);
    } on SeaBattleRoomException catch (error, stackTrace) {
      logger.warning(
        'Could not start the battle in room ${_room.code}',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }

  /// Always lets the player out: a room that cannot be deleted now
  /// expires on the server.
  Future<void> _onLeaveRoom(
    LeaveRoom event,
    Emitter<SeaBattleOnlinePlacementState> emit,
  ) async {
    emit(const SeaBattleOnlinePlacementLeft());
    try {
      await _leaveSeaBattleRoomUseCase(_room.code);
    } on SeaBattleRoomException catch (error, stackTrace) {
      logger.error(
        'Failed to leave room ${_room.code} while placing',
        error: error,
        stackTrace: stackTrace,
      );
    }
  }
}
