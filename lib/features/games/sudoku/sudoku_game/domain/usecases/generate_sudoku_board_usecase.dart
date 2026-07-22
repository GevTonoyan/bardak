import 'dart:isolate';

import 'package:bardak/features/games/sudoku/sudoku_game/domain/entities/sudoku_board_entity.dart';

/// Generates a fresh puzzle off the main thread.
///
/// Unique-solution digging gets slow at low givens counts (hundreds of
/// milliseconds on the harder difficulties), so the work runs in an
/// isolate to keep the UI responsive.
class GenerateSudokuBoardUseCase {
  const GenerateSudokuBoardUseCase();

  Future<SudokuBoardEntity> call(GenerateSudokuBoardParams params) {
    final givensCount = params.givensCount;
    return Isolate.run(
      () => SudokuBoardEntity.generate(givensCount: givensCount),
    );
  }
}

class GenerateSudokuBoardParams {
  const GenerateSudokuBoardParams({required this.givensCount});

  final int givensCount;
}
