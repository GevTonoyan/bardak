import 'dart:convert';

import 'package:bardak/features/games/sudoku/sudoku_game/domain/entities/sudoku_saved_game_entity.dart';
import 'package:bardak/features/games/sudoku/sudoku_game/domain/entities/sudoku_stats_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Persists the resumable game snapshot and lifetime statistics in
/// [SharedPreferences] as JSON strings.
abstract interface class SudokuGameLocalDataSource {
  SudokuSavedGameEntity? getSavedGame();

  Future<bool> updateSavedGame(SudokuSavedGameEntity game);

  Future<bool> clearSavedGame();

  SudokuStatsEntity getStats();

  Future<bool> updateStats(SudokuStatsEntity stats);
}

class SudokuGameLocalDataSourceImpl implements SudokuGameLocalDataSource {
  const SudokuGameLocalDataSourceImpl({required this._preferences});

  static const _savedGameKey = 'sudoku_saved_game';
  static const _statsKey = 'sudoku_stats';

  final SharedPreferences _preferences;

  @override
  SudokuSavedGameEntity? getSavedGame() {
    final json = _preferences.getString(_savedGameKey);
    if (json == null) return null;

    try {
      return SudokuSavedGameEntity.fromJson(
        jsonDecode(json) as Map<String, dynamic>,
      );
    } on FormatException {
      // A corrupt snapshot is unrecoverable; treat it as absent.
      return null;
    }
  }

  @override
  Future<bool> updateSavedGame(SudokuSavedGameEntity game) {
    return _preferences.setString(_savedGameKey, jsonEncode(game.toJson()));
  }

  @override
  Future<bool> clearSavedGame() => _preferences.remove(_savedGameKey);

  @override
  SudokuStatsEntity getStats() {
    final json = _preferences.getString(_statsKey);
    if (json == null) return const SudokuStatsEntity();

    try {
      return SudokuStatsEntity.fromJson(
        jsonDecode(json) as Map<String, dynamic>,
      );
    } on FormatException {
      return const SudokuStatsEntity();
    }
  }

  @override
  Future<bool> updateStats(SudokuStatsEntity stats) {
    return _preferences.setString(_statsKey, jsonEncode(stats.toJson()));
  }
}
