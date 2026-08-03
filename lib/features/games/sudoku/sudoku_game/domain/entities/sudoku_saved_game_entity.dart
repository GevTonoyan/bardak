import 'package:bardak/features/games/sudoku/sudoku_game/domain/entities/sudoku_board_entity.dart';
import 'package:bardak/features/games/sudoku/sudoku_settings/domain/entities/sudoku_board_size.dart';
import 'package:bardak/features/games/sudoku/sudoku_settings/domain/entities/sudoku_difficulty.dart';
import 'package:equatable/equatable.dart';

/// A snapshot of an unfinished Sudoku game, persisted so the player can
/// leave mid-puzzle and resume later.
class SudokuSavedGameEntity extends Equatable {
  const SudokuSavedGameEntity({
    required this.board,
    required this.boardSize,
    required this.difficulty,
    required this.mistakes,
    required this.elapsedSeconds,
  });

  /// Restores a snapshot previously serialized with [toJson]. Missing
  /// fields (from older app versions) fall back to safe defaults.
  factory SudokuSavedGameEntity.fromJson(Map<String, dynamic> json) {
    return SudokuSavedGameEntity(
      board: SudokuBoardEntity.fromJson(json['board'] as Map<String, dynamic>),
      boardSize: SudokuBoardSize.fromString(json['boardSize'] as String?),
      difficulty: SudokuDifficulty.fromString(json['difficulty'] as String?),
      mistakes: json['mistakes'] as int? ?? 0,
      elapsedSeconds: json['elapsedSeconds'] as int? ?? 0,
    );
  }

  final SudokuBoardEntity board;
  final SudokuBoardSize boardSize;
  final SudokuDifficulty difficulty;
  final int mistakes;
  final int elapsedSeconds;

  /// Serializes the snapshot for persistence; see
  /// [SudokuSavedGameEntity.fromJson].
  Map<String, dynamic> toJson() => {
    'board': board.toJson(),
    'boardSize': boardSize.name,
    'difficulty': difficulty.name,
    'mistakes': mistakes,
    'elapsedSeconds': elapsedSeconds,
  };

  @override
  List<Object?> get props => [
    board,
    boardSize,
    difficulty,
    mistakes,
    elapsedSeconds,
  ];
}
