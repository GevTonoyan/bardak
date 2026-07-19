import 'package:bardak/features/games/spy/spy_session/domain/entities/spy_session_entity.dart';
import 'package:equatable/equatable.dart';

class SpySessionState extends Equatable {
  const SpySessionState({required this.session});

  final SpySessionEntity session;

  @override
  List<Object?> get props => [session];
}
