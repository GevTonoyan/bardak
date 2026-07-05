import 'dart:math';

import 'package:bardak/features/games/spy/spy_packs/domain/entities/spy_pack_entity.dart';
import 'package:bardak/features/games/spy/spy_session/domain/entities/spy_player_entity.dart';
import 'package:equatable/equatable.dart';

/// Full in-memory state of one Spy match.
class SpySessionEntity extends Equatable {
  const SpySessionEntity({
    required this.pack,
    required this.secretWord,
    required this.players,
    required this.roundDuration,
    this.currentRevealIndex = 0,
  });

  /// Creates a session for [pack], randomly assigning [spyCount] spies
  /// among [playerCount] players.
  factory SpySessionEntity.create({
    required SpyPackEntity pack,
    required String secretWord,
    required int playerCount,
    required int spyCount,
    required int roundDuration,
    Random? random,
  }) {
    final numbers = List.generate(playerCount, (index) => index + 1)
      ..shuffle(random ?? Random());
    final spyNumbers = numbers.take(spyCount).toSet();

    return SpySessionEntity(
      pack: pack,
      secretWord: secretWord,
      players: [
        for (var number = 1; number <= playerCount; number++)
          SpyPlayerEntity(number: number, isSpy: spyNumbers.contains(number)),
      ],
      roundDuration: roundDuration,
    );
  }

  /// The pack this match is played with; also feeds "play again".
  final SpyPackEntity pack;

  /// The secret word every non-spy knows.
  final String secretWord;

  /// Players in pass-the-phone order.
  final List<SpyPlayerEntity> players;

  /// Round duration in seconds.
  final int roundDuration;

  /// Index of the player currently seeing their role card.
  final int currentRevealIndex;

  SpyPlayerEntity get currentRevealPlayer => players[currentRevealIndex];

  /// Whether every player has seen their role.
  bool get isRevealCompleted => currentRevealIndex >= players.length;

  /// The spies of this match, revealed on the result screen.
  List<SpyPlayerEntity> get spies =>
      players.where((player) => player.isSpy).toList();

  SpySessionEntity copyWith({int? currentRevealIndex}) {
    return SpySessionEntity(
      pack: pack,
      secretWord: secretWord,
      players: players,
      roundDuration: roundDuration,
      currentRevealIndex: currentRevealIndex ?? this.currentRevealIndex,
    );
  }

  @override
  List<Object?> get props => [
    pack,
    secretWord,
    players,
    roundDuration,
    currentRevealIndex,
  ];
}
