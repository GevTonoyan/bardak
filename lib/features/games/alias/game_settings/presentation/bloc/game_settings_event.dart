import 'package:equatable/equatable.dart';

sealed class GameSettingsEvent extends Equatable {
  const GameSettingsEvent();

  @override
  List<Object?> get props => [];
}

/// Loads the persisted game settings into state.
class LoadGameSettings extends GameSettingsEvent {
  const LoadGameSettings();
}

class ChangeRoundDuration extends GameSettingsEvent {
  const ChangeRoundDuration(this.roundDuration);

  final int roundDuration;

  @override
  List<Object?> get props => [roundDuration];
}

class ChangePointsToWin extends GameSettingsEvent {
  const ChangePointsToWin(this.pointsToWin);

  final int pointsToWin;

  @override
  List<Object?> get props => [pointsToWin];
}

class ChangeAllowSkipping extends GameSettingsEvent {
  const ChangeAllowSkipping({required this.allowSkipping});

  final bool allowSkipping;

  @override
  List<Object?> get props => [allowSkipping];
}
