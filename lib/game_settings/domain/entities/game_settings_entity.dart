import 'package:bardak/utils/constants/constants.dart';
import 'package:equatable/equatable.dart';

/// Settings for the Alias game (round duration, scoring, skipping rules).
///
/// Lives in its own feature so each game can own its settings independently
/// as more games are added.
class GameSettingsEntity extends Equatable {
  const GameSettingsEntity({
    this.roundDuration = AppConstants.defaultRoundDuration,
    this.pointsToWin = AppConstants.defaultPointsToWin,
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
    bool? allowSkipping,
    bool? penaltyForSkipping,
    int? wordsPerCard,
  }) {
    return GameSettingsEntity(
      roundDuration: roundDuration ?? AppConstants.defaultRoundDuration,
      pointsToWin: pointsToWin ?? AppConstants.defaultPointsToWin,
      allowSkipping: allowSkipping ?? true,
      penaltyForSkipping: penaltyForSkipping ?? true,
      wordsPerCard: wordsPerCard ?? AppConstants.defaultWordsPerCard,
    );
  }

  final int roundDuration;
  final int pointsToWin;
  final bool allowSkipping;
  final bool penaltyForSkipping;
  final int wordsPerCard;

  GameSettingsEntity copyWith({
    int? roundDuration,
    int? pointsToWin,
    bool? allowSkipping,
    bool? penaltyForSkipping,
    int? wordsPerCard,
  }) {
    return GameSettingsEntity(
      roundDuration: roundDuration ?? this.roundDuration,
      pointsToWin: pointsToWin ?? this.pointsToWin,
      allowSkipping: allowSkipping ?? this.allowSkipping,
      penaltyForSkipping: penaltyForSkipping ?? this.penaltyForSkipping,
      wordsPerCard: wordsPerCard ?? this.wordsPerCard,
    );
  }

  @override
  String toString() {
    return 'GameSettingsEntity(roundDuration: $roundDuration, '
        'pointsToWin: $pointsToWin, '
        'allowSkipping: $allowSkipping, '
        'skipPenalty: $penaltyForSkipping, '
        'wordsPerCard: $wordsPerCard)';
  }

  @override
  List<Object?> get props => [
    roundDuration,
    pointsToWin,
    allowSkipping,
    penaltyForSkipping,
    wordsPerCard,
  ];
}
