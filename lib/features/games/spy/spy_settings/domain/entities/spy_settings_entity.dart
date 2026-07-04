import 'package:equatable/equatable.dart';

/// Settings for the Spy game (players, spies, round duration).
///
/// Persisted, so choices are remembered across sessions.
class SpySettingsEntity extends Equatable {
  const SpySettingsEntity({
    this.playerCount = _defaultPlayerCount,
    this.spyCount = _defaultSpyCount,
    this.roundDuration = _defaultRoundDuration,
  });

  static const _defaultPlayerCount = 4;
  static const _minPlayerCount = 3;
  static const _maxPlayerCount = 30;
  static const _defaultSpyCount = 1;
  static const _minSpyCount = 1;
  static const int _defaultRoundDuration = 7 * 60;
  static const int _minRoundDuration = 60;
  static const int _maxRoundDuration = 20 * 60;

  final int playerCount;
  final int spyCount;

  /// Round duration in seconds.
  final int roundDuration;

  /// Round duration shown to the user, in whole minutes.
  int get roundDurationInMinutes => roundDuration ~/ 60;

  /// Spies can go all the way up to every player being a spy.
  int get maxSpyCount => playerCount;

  bool get canIncreasePlayerCount => playerCount < _maxPlayerCount;
  bool get canDecreasePlayerCount => playerCount > _minPlayerCount;
  bool get canIncreaseSpyCount => spyCount < maxSpyCount;
  bool get canDecreaseSpyCount => spyCount > _minSpyCount;
  bool get canIncreaseRoundDuration => roundDuration < _maxRoundDuration;
  bool get canDecreaseRoundDuration => roundDuration > _minRoundDuration;

  SpySettingsEntity copyWith({
    int? playerCount,
    int? spyCount,
    int? roundDuration,
  }) {
    return SpySettingsEntity(
      playerCount: playerCount ?? this.playerCount,
      spyCount: spyCount ?? this.spyCount,
      roundDuration: roundDuration ?? this.roundDuration,
    );
  }

  @override
  List<Object?> get props => [playerCount, spyCount, roundDuration];
}
