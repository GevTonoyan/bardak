import 'package:bardak/core/di/di.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_online/domain/exceptions/sea_battle_room_exception.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_online/domain/usecases/join_sea_battle_room_usecase.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_online/presentation/bloc/join_room/sea_battle_join_room_event.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_online/presentation/bloc/join_room/sea_battle_join_room_state.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// The guest's way into a friend's room, from an invite link.
class SeaBattleJoinRoomBloc
    extends Bloc<SeaBattleJoinRoomEvent, SeaBattleJoinRoomState> {
  SeaBattleJoinRoomBloc({required this._joinSeaBattleRoomUseCase})
    : super(const SeaBattleJoinRoomJoining()) {
    on<JoinRoom>(_onJoinRoom, transformer: droppable());
  }

  final JoinSeaBattleRoomUseCase _joinSeaBattleRoomUseCase;

  Future<void> _onJoinRoom(
    JoinRoom event,
    Emitter<SeaBattleJoinRoomState> emit,
  ) async {
    emit(const SeaBattleJoinRoomJoining());
    try {
      emit(
        SeaBattleJoinRoomJoined(await _joinSeaBattleRoomUseCase(event.code)),
      );
    } on SeaBattleRoomException catch (error, stackTrace) {
      // A room that is gone or taken is an expected answer, not an error.
      if (error.reason == .connection) {
        logger.error(
          'Failed to join room ${event.code}',
          error: error,
          stackTrace: stackTrace,
        );
      }
      emit(SeaBattleJoinRoomFailure(error.reason));
    }
  }
}
