import 'dart:convert';

import 'package:boardify/alias_constants.dart';

/// AliasPreGameConfig is a data class that holds the configuration
/// settings for the Alias game.
class PreGameEntity {
  const PreGameEntity({
    required this.gameMode,
    required this.roundDuration,
    required this.pointsToWin,
    required this.soundEnabled,
    required this.wordsPerCard,
    required this.allowSkipping,
    required this.penaltyForSkipping,
    required this.teamNames,
  });

  factory PreGameEntity.fromJson(String json) {
    final data = jsonDecode(json) as Map<String, dynamic>;
    return PreGameEntity(
      gameMode: GameMode.fromString(data[AliasConstants.gameModeKey]),
      roundDuration: data[AliasConstants.roundDurationKey] as int,
      pointsToWin: data[AliasConstants.pointsToWinKey] as int,
      soundEnabled: data[AliasConstants.soundEnabledKey] as bool,
      wordsPerCard: data[AliasConstants.wordsPerCardKey] as int,
      allowSkipping: data[AliasConstants.allowSkippingKey] as bool,
      penaltyForSkipping: data[AliasConstants.penaltyForSkippingKey] as bool,
      teamNames: List<String>.from(data[AliasConstants.teamNamesKey] as List),
    );
  }

  factory PreGameEntity.initial() {
    return const PreGameEntity(
      roundDuration: AliasConstants.defaultRoundDuration,
      pointsToWin: AliasConstants.defaultPointsToWin,
      soundEnabled: true,
      allowSkipping: true,
      penaltyForSkipping: true,
      wordsPerCard: AliasConstants.defaultWordsPerCard,
      gameMode: GameMode.card,
      teamNames: ['Team 1', 'Team 2'],
    );
  }

  final GameMode gameMode;
  final int roundDuration;
  final int pointsToWin;
  final bool soundEnabled;
  final int wordsPerCard;
  final bool allowSkipping;
  final bool penaltyForSkipping;
  final List<String> teamNames;

  PreGameEntity copyWith({
    GameMode? gameMode,
    int? roundDuration,
    int? pointsToWin,
    bool? soundEnabled,
    int? wordsPerCard,
    bool? allowSkipping,
    bool? penaltyForSkipping,
    List<String>? teamNames,
  }) {
    return PreGameEntity(
      gameMode: gameMode ?? this.gameMode,
      roundDuration: roundDuration ?? this.roundDuration,
      pointsToWin: pointsToWin ?? this.pointsToWin,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      wordsPerCard: wordsPerCard ?? this.wordsPerCard,
      allowSkipping: allowSkipping ?? this.allowSkipping,
      penaltyForSkipping: penaltyForSkipping ?? this.penaltyForSkipping,
      teamNames: teamNames ?? this.teamNames,
    );
  }

  String toJson() {
    final data = <String, dynamic>{
      AliasConstants.gameModeKey: gameMode.toString(),
      AliasConstants.roundDurationKey: roundDuration,
      AliasConstants.pointsToWinKey: pointsToWin,
      AliasConstants.soundEnabledKey: soundEnabled,
      AliasConstants.wordsPerCardKey: wordsPerCard,
      AliasConstants.allowSkippingKey: allowSkipping,
      AliasConstants.penaltyForSkippingKey: penaltyForSkipping,
      AliasConstants.teamNamesKey: teamNames,
    };

    return jsonEncode(data);
  }

  @override
  String toString() {
    return 'AliasPreGameEntity{gameMode: $gameMode,'
        ' roundDuration: $roundDuration,'
        ' pointsToWin: $pointsToWin,'
        ' soundEnabled: $soundEnabled,'
        ' wordsPerCard: $wordsPerCard,'
        ' allowSkipping: $allowSkipping,'
        ' penaltyForSkipping: $penaltyForSkipping,'
        ' teamNames: $teamNames}';
  }
}

enum GameMode {
  card,
  singleWord;

  @override
  String toString() {
    switch (this) {
      case GameMode.card:
        return 'card';
      case GameMode.singleWord:
        return 'single word';
    }
  }

  static GameMode fromString(String value) {
    switch (value.toLowerCase()) {
      case 'card':
        return GameMode.card;
      case 'single word':
        return GameMode.singleWord;
      default:
        throw ArgumentError('Unknown game mode: $value');
    }
  }
}
