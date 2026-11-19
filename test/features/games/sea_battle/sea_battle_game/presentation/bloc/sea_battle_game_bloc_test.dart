import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/board_coordinate.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/fleet_entity.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/sea_battle_board_entity.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/sea_battle_entity.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/sea_battle_side.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/ship_entity.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/shot_entity.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/entities/shot_result.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/usecases/choose_bot_shot_usecase.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/domain/usecases/start_sea_battle_usecase.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/presentation/bloc/sea_battle_game_bloc/sea_battle_game_bloc.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_game/presentation/bloc/sea_battle_game_bloc/sea_battle_game_event.dart';
import 'package:bardak/features/games/sea_battle/sea_battle_settings/domain/entities/sea_battle_bot_difficulty.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class _MockStartSeaBattleUseCase extends Mock
    implements StartSeaBattleUseCase {}

class _MockChooseBotShotUseCase extends Mock implements ChooseBotShotUseCase {}

/// Each side has one 2-cell ship: the player's at the top-left, the
/// opponent's at the bottom-right.
SeaBattleEntity _battle(SeaBattleSide turn) => SeaBattleEntity(
  playerBoard: SeaBattleBoardEntity(
    fleet: const FleetEntity().withShip(
      const ShipEntity(id: 0, length: 2, origin: BoardCoordinate(0, 0)),
    ),
  ),
  opponentBoard: SeaBattleBoardEntity(
    fleet: const FleetEntity().withShip(
      const ShipEntity(id: 0, length: 2, origin: BoardCoordinate(9, 8)),
    ),
  ),
  turn: turn,
);

void main() {
  late _MockStartSeaBattleUseCase startSeaBattle;
  late _MockChooseBotShotUseCase chooseBotShot;

  setUpAll(() {
    registerFallbackValue(
      const StartSeaBattleParams(playerFleet: FleetEntity()),
    );
    registerFallbackValue(
      const ChooseBotShotParams(
        board: SeaBattleBoardEntity(fleet: FleetEntity()),
        difficulty: .medium,
      ),
    );
  });

  setUp(() {
    startSeaBattle = _MockStartSeaBattleUseCase();
    chooseBotShot = _MockChooseBotShotUseCase();
  });

  SeaBattleGameBloc buildBloc(SeaBattleSide firstShooter) {
    when(() => startSeaBattle(any())).thenReturn(_battle(firstShooter));
    final bloc = SeaBattleGameBloc(
      playerFleet: const FleetEntity(),
      botDifficulty: .hard,
      startSeaBattleUseCase: startSeaBattle,
      chooseBotShotUseCase: chooseBotShot,
    );
    addTearDown(bloc.close);
    return bloc;
  }

  /// Waits out the bot's pause before each of its [shots].
  Future<void> waitForBot({int shots = 1}) =>
      Future<void>.delayed(const Duration(milliseconds: 750) * shots);

  /// The bot fires at [cells] in order.
  void botFiresAt(List<BoardCoordinate> cells) {
    final queue = [...cells];
    when(() => chooseBotShot(any())).thenAnswer((_) => queue.removeAt(0));
  }

  test('a player miss hands the turn to the bot, which fires back', () async {
    botFiresAt([const BoardCoordinate(5, 5)]);
    final bloc = buildBloc(.player)..add(const FireShot(BoardCoordinate(3, 3)));
    await waitForBot();

    final battle = bloc.state.battle;
    expect(battle.opponentBoard.missCells, {const BoardCoordinate(3, 3)});
    expect(battle.playerBoard.missCells, {const BoardCoordinate(5, 5)});
    expect(battle.turn, SeaBattleSide.player);
    expect(
      bloc.state.lastShot,
      const ShotEntity(
        shooter: .opponent,
        cell: BoardCoordinate(5, 5),
        result: .miss,
      ),
    );
    verify(
      () => chooseBotShot(
        any(
          that: isA<ChooseBotShotParams>().having(
            (params) => params.difficulty,
            'difficulty',
            SeaBattleBotDifficulty.hard,
          ),
        ),
      ),
    ).called(1);
  });

  test('a player hit keeps the turn', () async {
    final bloc = buildBloc(.player)..add(const FireShot(BoardCoordinate(9, 8)));
    await pumpEventQueue();

    expect(bloc.state.battle.turn, SeaBattleSide.player);
    expect(bloc.state.lastShot?.result, ShotResult.hit);
    verifyNever(() => chooseBotShot(any()));
  });

  test('the bot keeps firing while it hits', () async {
    botFiresAt(const [
      BoardCoordinate(0, 0),
      BoardCoordinate(5, 5),
    ]);
    final bloc = buildBloc(.player)..add(const FireShot(BoardCoordinate(3, 3)));
    await waitForBot(shots: 2);

    expect(bloc.state.battle.playerBoard.hitCells, {
      const BoardCoordinate(0, 0),
    });
    expect(bloc.state.battle.turn, SeaBattleSide.player);
    verify(() => chooseBotShot(any())).called(2);
  });

  test('the bot fires first when the battle starts on its turn', () async {
    botFiresAt([const BoardCoordinate(5, 5)]);
    final bloc = buildBloc(.opponent);
    await waitForBot();

    expect(bloc.state.battle.playerBoard.missCells, {
      const BoardCoordinate(5, 5),
    });
    expect(bloc.state.battle.turn, SeaBattleSide.player);
  });

  test('player shots on the bot turn or at marked cells are ignored', () async {
    botFiresAt([const BoardCoordinate(0, 0), const BoardCoordinate(5, 5)]);
    final bloc = buildBloc(.player)
      ..add(const FireShot(BoardCoordinate(3, 3)))
      // Still the bot's turn: dropped.
      ..add(const FireShot(BoardCoordinate(4, 4)));
    await waitForBot(shots: 2);
    bloc.add(const FireShot(BoardCoordinate(3, 3)));
    await pumpEventQueue();

    expect(bloc.state.battle.opponentBoard.marked, {
      const BoardCoordinate(3, 3),
    });
  });

  test('sinking the last enemy ship wins and stops the bot', () async {
    final bloc = buildBloc(.player)
      ..add(const FireShot(BoardCoordinate(9, 8)))
      ..add(const FireShot(BoardCoordinate(9, 9)));
    await pumpEventQueue();

    expect(bloc.state.battle.winner, SeaBattleSide.player);
    expect(bloc.state.lastShot?.result, ShotResult.sunk);
    verifyNever(() => chooseBotShot(any()));
  });
}
