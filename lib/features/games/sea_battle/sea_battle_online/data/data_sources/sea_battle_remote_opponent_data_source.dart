import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/board_coordinate.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/fleet_entity.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/sea_battle_board_entity.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/ship_entity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

/// The battle in a room, under `sea_battle_rooms/{code}`: shots by both
/// players numbered in order, their answers, and the fleets revealed at
/// the end.
///
/// A fleet never leaves its owner's phone during the battle: the defender
/// answers each shot from its own fleet.
abstract interface class SeaBattleRemoteOpponentDataSource {
  /// Writes this player's shot number [index], at [cell].
  Future<void> fireShot(String code, int index, BoardCoordinate cell);

  /// Waits for the opponent's answer to shot number [index]: what it did,
  /// and the ship it sank.
  Future<(ShotResult, ShipEntity?)> getShotAnswer(String code, int index);

  /// Waits for the opponent's shot number [index].
  Future<BoardCoordinate> getOpponentShot(String code, int index);

  /// Answers the opponent's shot number [index]. A miss hands this player
  /// the turn; losing the last ship ends the battle.
  Future<void> answerShot(
    String code,
    int index, {
    required ShotResult result,
    required ShipEntity? sunkShip,
    required bool isFleetSunk,
  });

  /// Shows this player's [fleet] to the opponent, once the battle is over.
  Future<void> revealFleet(String code, FleetEntity fleet);

  /// Waits for the opponent's fleet, revealed once the battle is over.
  Future<FleetEntity> getOpponentFleet(String code);
}

class SeaBattleRemoteOpponentDataSourceImpl
    implements SeaBattleRemoteOpponentDataSource {
  SeaBattleRemoteOpponentDataSourceImpl({
    required this._database,
    required this._auth,
  });

  final FirebaseDatabase _database;
  final FirebaseAuth _auth;

  static const _roomsPath = 'sea_battle_rooms';
  static const _shotsKey = 'shots';
  static const _fleetsKey = 'fleets';
  static const _turnKey = 'turn';
  static const _missAtKey = 'missAt';
  static const _statusKey = 'status';
  static const _finishedStatus = 'finished';

  static const _byKey = 'by';
  static const _rowKey = 'row';
  static const _columnKey = 'column';
  static const _resultKey = 'result';
  static const _sunkShipKey = 'sunkShip';
  static const _idKey = 'id';
  static const _lengthKey = 'length';
  static const _orientationKey = 'orientation';

  /// The player is already signed in: they created or joined the room.
  String get _playerId => _auth.currentUser!.uid;

  DatabaseReference _room(String code) => _database.ref('$_roomsPath/$code');

  /// Shot keys sort in firing order and are never read as a list, which
  /// plain numbers would be.
  static String _shotKey(int index) => 's${index.toString().padLeft(3, '0')}';

  DatabaseReference _shot(String code, int index) =>
      _room(code).child('$_shotsKey/${_shotKey(index)}');

  @override
  Future<void> fireShot(String code, int index, BoardCoordinate cell) =>
      _shot(code, index).set({
        _byKey: _playerId,
        _rowKey: cell.row,
        _columnKey: cell.column,
      });

  @override
  Future<(ShotResult, ShipEntity?)> getShotAnswer(String code, int index) =>
      _firstWhere(_shot(code, index), (data) {
        final result = _parseResult(data[_resultKey]);
        if (result == null) return null;
        return (result, _parseShip(data[_sunkShipKey]));
      });

  @override
  Future<BoardCoordinate> getOpponentShot(String code, int index) =>
      _firstWhere(_shot(code, index), (data) {
        final (row, column) = (data[_rowKey], data[_columnKey]);
        if (data[_byKey] == _playerId || row is! int || column is! int) {
          return null;
        }
        return BoardCoordinate(row, column);
      });

  @override
  Future<void> answerShot(
    String code,
    int index, {
    required ShotResult result,
    required ShipEntity? sunkShip,
    required bool isFleetSunk,
  }) {
    final key = _shotKey(index);
    final shot = '$_shotsKey/$key';
    // One update, so the opponent never sees the answer without the turn
    // or the end of the battle that comes with it. The rules only let the
    // turn pass with the miss that passes it, named in missAt.
    return _room(code).update({
      '$shot/$_resultKey': result.name,
      if (sunkShip != null) '$shot/$_sunkShipKey': _shipToJson(sunkShip),
      if (result == .miss) ...{_turnKey: _playerId, _missAtKey: key},
      if (isFleetSunk) _statusKey: _finishedStatus,
    });
  }

  @override
  Future<void> revealFleet(String code, FleetEntity fleet) =>
      _room(code).child('$_fleetsKey/$_playerId').set([
        for (final ship in fleet.ships) _shipToJson(ship),
      ]);

  @override
  Future<FleetEntity> getOpponentFleet(String code) =>
      _firstWhere(_room(code).child(_fleetsKey), (data) {
        for (final MapEntry(:key, :value) in data.entries) {
          if (key == _playerId || value is! List) continue;
          final ships = [for (final ship in value) _parseShip(ship)];
          if (ships.contains(null)) return null;
          return FleetEntity(ships: ships.nonNulls.toList());
        }
        return null;
      });

  /// The first non-null value [parse] makes of the data at [ref], waiting
  /// for it to be written if it is not there yet.
  static Future<T> _firstWhere<T>(
    DatabaseReference ref,
    T? Function(Map<Object?, Object?> data) parse,
  ) async {
    final values = ref.onValue.map((event) {
      final data = event.snapshot.value;
      return data is Map<Object?, Object?> ? parse(data) : null;
    });
    return (await values.firstWhere((value) => value != null))!;
  }

  static ShotResult? _parseResult(Object? value) {
    for (final result in ShotResult.values) {
      if (result.name == value) return result;
    }
    return null;
  }

  static Map<String, Object> _shipToJson(ShipEntity ship) => {
    _idKey: ship.id,
    _lengthKey: ship.length,
    _rowKey: ship.origin.row,
    _columnKey: ship.origin.column,
    _orientationKey: ship.orientation.name,
  };

  static ShipEntity? _parseShip(Object? value) {
    if (value is! Map) return null;
    final (id, length, row, column) = (
      value[_idKey],
      value[_lengthKey],
      value[_rowKey],
      value[_columnKey],
    );
    final orientation = ShipOrientation.values
        .where((o) => o.name == value[_orientationKey])
        .firstOrNull;
    if (id is! int ||
        length is! int ||
        row is! int ||
        column is! int ||
        orientation == null) {
      return null;
    }
    return ShipEntity(
      id: id,
      length: length,
      origin: BoardCoordinate(row, column),
      orientation: orientation,
    );
  }
}
