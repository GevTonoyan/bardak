import 'package:equatable/equatable.dart';

sealed class SpySettingsEvent extends Equatable {
  const SpySettingsEvent();

  @override
  List<Object?> get props => [];
}

class ChangePlayerCount extends SpySettingsEvent {
  const ChangePlayerCount(this.playerCount);

  final int playerCount;

  @override
  List<Object?> get props => [playerCount];
}

class ChangeSpyCount extends SpySettingsEvent {
  const ChangeSpyCount(this.spyCount);

  final int spyCount;

  @override
  List<Object?> get props => [spyCount];
}

class ChangeRoundDuration extends SpySettingsEvent {
  const ChangeRoundDuration(this.roundDuration);

  final int roundDuration;

  @override
  List<Object?> get props => [roundDuration];
}
