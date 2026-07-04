import 'package:bardak/features/games/alias/game_session/domain/entities/game_session_entity.dart';
import 'package:equatable/equatable.dart';

class GameSessionState extends Equatable {
  const GameSessionState({required this.session});

  final GameSessionEntity session;

  @override
  List<Object?> get props => [session];
}
