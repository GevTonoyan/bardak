import 'dart:developer' as developer;

import 'package:bardak/core/logging/app_logger.dart';

/// [AppLogger] that writes to the developer console via `dart:developer`.
///
/// Levels follow the `dart:developer` convention (FINE=500 … SEVERE=1000).
class ConsoleLogger implements AppLogger {
  const ConsoleLogger();

  @override
  void debug(String message) => _log(message, name: 'DEBUG', level: 500);

  @override
  void info(String message) => _log(message, name: 'INFO', level: 800);

  @override
  void warning(String message, {Object? error, StackTrace? stackTrace}) => _log(
    message,
    name: 'WARNING',
    level: 900,
    error: error,
    stackTrace: stackTrace,
  );

  @override
  void error(String message, {Object? error, StackTrace? stackTrace}) => _log(
    message,
    name: 'ERROR',
    level: 1000,
    error: error,
    stackTrace: stackTrace,
  );

  void _log(
    String message, {
    required String name,
    required int level,
    Object? error,
    StackTrace? stackTrace,
  }) {
    developer.log(
      message,
      name: name,
      level: level,
      error: error,
      stackTrace: stackTrace,
    );
  }
}
