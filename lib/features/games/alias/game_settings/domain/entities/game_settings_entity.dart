import 'package:bardak/features/games/alias/game_settings/domain/entities/game_mode.dart';
import 'package:equatable/equatable.dart';

/// Settings for the Alias game (game mode, round duration, scoring, skipping).
///
/// Lives in its own feature so each game can own its settings independently
/// as more games are added. Persisted, so choices are remembered across
/// sessions.
class GameSettingsEntity extends Equatable {
  const GameSettingsEntity({
    this.gameMode = .card,
    this.roundDuration = _defaultRoundDuration,
    this.pointsToWin = _defaultPointsToWin,
    this.allowSkipping = true,
    this.wordsPerCard = _defaultWordsPerCard,
  });

  static const _defaultRoundDuration = 60;
  static const _minRoundDuration = 30;
  static const _maxRoundDuration = 120;
  static const _defaultPointsToWin = 60;
  static const _minPointsToWin = 30;
  static const _maxPointsToWin = 120;
  static const _defaultWordsPerCard = 6;

  final GameMode gameMode;
  final int roundDuration;
  final int pointsToWin;
  final bool allowSkipping;
  final int wordsPerCard;

  bool get canDecreaseRoundDuration => roundDuration > _minRoundDuration;
  bool get canIncreaseRoundDuration => roundDuration < _maxRoundDuration;
  bool get canDecreasePointsToWin => pointsToWin > _minPointsToWin;
  bool get canIncreasePointsToWin => pointsToWin < _maxPointsToWin;

  GameSettingsEntity copyWith({
    GameMode? gameMode,
    int? roundDuration,
    int? pointsToWin,
    bool? allowSkipping,
    int? wordsPerCard,
  }) {
    return GameSettingsEntity(
      gameMode: gameMode ?? this.gameMode,
      roundDuration: roundDuration ?? this.roundDuration,
      pointsToWin: pointsToWin ?? this.pointsToWin,
      allowSkipping: allowSkipping ?? this.allowSkipping,
      wordsPerCard: wordsPerCard ?? this.wordsPerCard,
    );
  }

  @override
  String toString() {
    return 'GameSettingsEntity(gameMode: $gameMode, '
        'roundDuration: $roundDuration, '
        'pointsToWin: $pointsToWin, '
        'allowSkipping: $allowSkipping, '
        'wordsPerCard: $wordsPerCard)';
  }

  @override
  List<Object?> get props => [
    gameMode,
    roundDuration,
    pointsToWin,
    allowSkipping,
    wordsPerCard,
  ];
}
