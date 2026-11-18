import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/ship_orientation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('rotated flips between horizontal and vertical', () {
    expect(ShipOrientation.horizontal.rotated, ShipOrientation.vertical);
    expect(ShipOrientation.vertical.rotated, ShipOrientation.horizontal);
  });
}
