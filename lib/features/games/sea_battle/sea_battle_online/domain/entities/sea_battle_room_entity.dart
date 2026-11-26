import 'dart:math';

import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/sea_battle_entity.dart';
import 'package:equatable/equatable.dart';

/// An online Sea Battle room, as one of its two players sees it.
///
/// The host creates the room and shares its [code]; a guest joins with it.
class SeaBattleRoomEntity extends Equatable {
  const SeaBattleRoomEntity({
    required this.code,
    required this.role,
    required this.status,
    required this.hasOpponent,
    this.isPlayerReady = false,
    this.isOpponentReady = false,
    this.firstTurn,
  });

  /// Characters a code is made of: capitals and digits without the
  /// look-alikes 0/O and 1/I, so a code is easy to read out and type.
  static const codeAlphabet = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';

  static const codeLength = 6;

  /// A random room code.
  static String generateCode(Random random) => String.fromCharCodes([
    for (var i = 0; i < codeLength; i++)
      codeAlphabet.codeUnitAt(random.nextInt(codeAlphabet.length)),
  ]);

  /// The site invite links point at; the app opens them itself.
  static const inviteHost = 'bardakgames.com';

  /// The path invite links start with, followed by `/<code>`.
  static const invitePath = '/join';

  /// Time for each shot in the battle; when it runs out, a random shot is
  /// fired.
  static const turnTimeLimit = Duration(seconds: 20);

  final String code;

  /// Whether this player created the room or joined it.
  final SeaBattleRoomRole role;

  final SeaBattleRoomStatus status;

  /// Whether the other player is in the room.
  final bool hasOpponent;

  /// Whether this player has placed their fleet and is ready to fight.
  final bool isPlayerReady;

  /// Whether the other player is ready.
  final bool isOpponentReady;

  /// Who fires first, from this player's side; null until the host starts
  /// the battle.
  final SeaBattleSide? firstTurn;

  /// Whether both fleets are placed, so the host can start the battle.
  bool get areBothReady => isPlayerReady && isOpponentReady;

  /// The link that brings a friend into this room.
  Uri get inviteLink => Uri.https(inviteHost, '$invitePath/$code');

  @override
  List<Object?> get props => [
    code,
    role,
    status,
    hasOpponent,
    isPlayerReady,
    isOpponentReady,
    firstTurn,
  ];
}

/// Whether a player created a room or joined it.
enum SeaBattleRoomRole { host, guest }

/// Where a room is in the game.
enum SeaBattleRoomStatus {
  /// The host is waiting for a guest.
  waiting,

  /// Both players are placing their ships.
  placing,

  /// The battle is on.
  battle,

  /// The battle is over.
  finished;

  /// Parses a stored status, or null when it is unknown.
  static SeaBattleRoomStatus? fromString(String? value) {
    for (final status in values) {
      if (status.name == value) return status;
    }
    return null;
  }
}
