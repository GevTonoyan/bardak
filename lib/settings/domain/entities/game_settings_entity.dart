import 'package:boardify/utils/constants/constants.dart';
import 'package:equatable/equatable.dart';

/// This class represents the settings for the Alias game.
/// It contains various properties that define the game settings.
class GameSettingsEntity extends Equatable {
  const GameSettingsEntity({
    this.roundDuration = AppConstants.defaultRoundDuration,
    this.pointsToWin = AppConstants.defaultPointsToWin,
    this.soundEnabled = true,
    this.allowSkipping = true,
    this.penaltyForSkipping = true,
    this.wordsPerCard = AppConstants.defaultWordsPerCard,
  });

  factory GameSettingsEntity.initial() {
    return const GameSettingsEntity();
  }

  factory GameSettingsEntity.fromPreferences({
    int? roundDuration,
    int? pointsToWin,
    bool? soundEnabled,
    bool? allowSkipping,
    bool? penaltyForSkipping,
    int? wordsPerCard,
  }) {
    return GameSettingsEntity(
      roundDuration: roundDuration ?? AppConstants.defaultRoundDuration,
      pointsToWin: pointsToWin ?? AppConstants.defaultPointsToWin,
      soundEnabled: soundEnabled ?? true,
      allowSkipping: allowSkipping ?? true,
      penaltyForSkipping: penaltyForSkipping ?? true,
      wordsPerCard: wordsPerCard ?? AppConstants.defaultWordsPerCard,
    );
  }

  final int roundDuration;
  final int pointsToWin;
  final bool soundEnabled;
  final bool allowSkipping;
  final bool penaltyForSkipping;
  final int wordsPerCard;

  GameSettingsEntity copyWith({
    int? roundDuration,
    int? pointsToWin,
    bool? soundEnabled,
    bool? allowSkipping,
    bool? penaltyForSkipping,
    int? wordsPerCard,
  }) {
    return GameSettingsEntity(
      roundDuration: roundDuration ?? this.roundDuration,
      pointsToWin: pointsToWin ?? this.pointsToWin,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      allowSkipping: allowSkipping ?? this.allowSkipping,
      penaltyForSkipping: penaltyForSkipping ?? this.penaltyForSkipping,
      wordsPerCard: wordsPerCard ?? this.wordsPerCard,
    );
  }

  @override
  String toString() {
    return 'GameSettingsEntity(roundDuration: $roundDuration, '
        'pointsToWin: $pointsToWin, '
        'soundEnabled: $soundEnabled, '
        'allowSkipping: $allowSkipping, '
        'skipPenalty: $penaltyForSkipping, '
        'wordsPerCard: $wordsPerCard)';
  }

  @override
  List<Object?> get props => [
    roundDuration,
    pointsToWin,
    soundEnabled,
    allowSkipping,
    penaltyForSkipping,
    wordsPerCard,
  ];
}
