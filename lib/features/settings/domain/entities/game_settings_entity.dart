import 'package:boardify/alias_constants.dart';
import 'package:equatable/equatable.dart';

/// This class represents the settings for the Alias game.
/// It contains various properties that define the game settings.
class GameSettingsEntity extends Equatable {
  final int roundDuration;
  final int pointsToWin;
  final bool soundEnabled;
  final bool allowSkipping;
  final bool penaltyForSkipping;
  final int wordsPerCard;

  const GameSettingsEntity({
    this.roundDuration = AliasConstants.defaultRoundDuration,
    this.pointsToWin = AliasConstants.defaultPointsToWin,
    this.soundEnabled = true,
    this.allowSkipping = true,
    this.penaltyForSkipping = true,
    this.wordsPerCard = AliasConstants.defaultWordsPerCard,
  });

  factory GameSettingsEntity.initial() {
    return const GameSettingsEntity(
      roundDuration: AliasConstants.defaultRoundDuration,
      pointsToWin: AliasConstants.defaultPointsToWin,
      soundEnabled: true,
      allowSkipping: true,
      penaltyForSkipping: true,
      wordsPerCard: AliasConstants.defaultWordsPerCard,
    );
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
      roundDuration: roundDuration ?? AliasConstants.defaultRoundDuration,
      pointsToWin: pointsToWin ?? AliasConstants.defaultPointsToWin,
      soundEnabled: soundEnabled ?? true,
      allowSkipping: allowSkipping ?? true,
      penaltyForSkipping: penaltyForSkipping ?? true,
      wordsPerCard: wordsPerCard ?? AliasConstants.defaultWordsPerCard,
    );
  }

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
    return 'GameSettingsEntity(roundDuration: $roundDuration, pointsToWin: $pointsToWin, soundEnabled: $soundEnabled, allowSkipping: $allowSkipping, skipPenalty: $penaltyForSkipping, wordsPerCard: $wordsPerCard)';
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
