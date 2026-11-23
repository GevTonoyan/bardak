import 'package:bardak/features/games/sea_battle/sea_battle_settings/domain/entities/sea_battle_mode.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('only solo uses the bot difficulty', () {
    expect(SeaBattleMode.solo.usesBotDifficulty, isTrue);
    expect(SeaBattleMode.online.usesBotDifficulty, isFalse);
  });

  test('fromString parses names and defaults to solo', () {
    expect(SeaBattleMode.fromString('online'), SeaBattleMode.online);
    expect(SeaBattleMode.fromString(null), SeaBattleMode.solo);
  });
}
